///|
/// A digest of a distribution: the values are grouped into centroids, each a
/// mean with a weight, and the groups are kept small where the quantiles are
/// dense — near the ends — so a quantile costs the same whether the digest has
/// seen a thousand values or a million. The compression parameter is how many
/// groups the digest is willing to keep; a hundred is the usual choice for a
/// relative error of about one percent at the tails.
///
/// ```mbt check
/// test {
///   let digest : @sketch.TDigest = @sketch.TDigest::new()
///   for i in 0..<1000 {
///     digest.add(i.to_double())
///   }
///   let median = digest.quantile(0.5)
///   assert_true(median > 450.0)
///   assert_true(median < 550.0)
///   assert_true(digest.count() == 1000.0)
/// }
/// ```
pub struct TDigest {
  compression : Double
  mut means : Array[Double]
  mut weights : Array[Double]
  buffer : Array[Double]
  mut count_ : Double
  mut minimum : Double
  mut maximum : Double
}

///|
/// An empty digest with the given `compression` — higher keeps more centroids and answers more precisely; a value outside the range the digest accepts raises `Refused`.
pub fn TDigest::new(
  compression~ : Double = 100.0,
) -> TDigest raise @spec.Refused {
  if !(compression >= 1.0) {
    raise @spec.Refused::Probability(got=compression)
  }
  {
    compression,
    means: [],
    weights: [],
    buffer: [],
    count_: 0.0,
    minimum: 0.0,
    maximum: 0.0,
  }
}

///|
/// Adds one value with weight one.
pub fn TDigest::add(self : TDigest, value : Double) -> Unit {
  if value != value {
    // A not-a-number would poison every centroid it joined.
    return
  }
  if self.count_ == 0.0 {
    self.minimum = value
    self.maximum = value
  } else {
    if value < self.minimum {
      self.minimum = value
    }
    if value > self.maximum {
      self.maximum = value
    }
  }
  self.buffer.push(value)
  self.count_ = self.count_ + 1.0
  if self.buffer.length().to_double() > 4.0 * self.compression {
    self.compress()
  }
}

///|
/// Adds `value` with the weight `weight`, which is how a merged sample keeps its proportions.
pub fn TDigest::add_weighted(
  self : TDigest,
  value : Double,
  weight : Double,
) -> Unit {
  if weight <= 0.0 {
    return
  }
  let repeat = if weight > 1000.0 { 1000 } else { weight.to_int() }
  for _ in 0..<(if repeat < 1 { 1 } else { repeat }) {
    self.add(value)
  }
}

///|
/// Folds the buffered values into the centroids and merges neighbours that have
/// grown past the size the compression allows at their quantile.
pub fn TDigest::compress(self : TDigest) -> Unit {
  if self.buffer.length() == 0 && self.means.length() > 0 {
    return
  }
  let values : Array[Double] = []
  let weights : Array[Double] = []
  for i in 0..<self.means.length() {
    values.push(self.means[i])
    weights.push(self.weights[i])
  }
  for value in self.buffer {
    values.push(value)
    weights.push(1.0)
  }
  self.buffer.clear()
  let order : Array[Int32] = []
  for i in 0..<values.length() {
    order.push(i)
  }
  order.sort_by((a, b) => values[a].compare(values[b]))
  let sorted_values : Array[Double] = []
  let sorted_weights : Array[Double] = []
  for index in order {
    sorted_values.push(values[index])
    sorted_weights.push(weights[index])
  }
  let means : Array[Double] = []
  let kept : Array[Double] = []
  let total = self.count_
  let mut at = 0
  while at < sorted_values.length() {
    let mut mean = sorted_values[at]
    let mut weight = sorted_weights[at]
    let mut next = at + 1
    while next < sorted_values.length() {
      let combined = weight + sorted_weights[next]
      // The share of the distribution covered so far decides how large a
      // centroid may grow: small at the tails, large in the middle.
      let covered = (weight + sorted_weights[next] / 2.0) / total
      let allowed = 4.0 * total * covered * (1.0 - covered) / self.compression
      if combined > allowed && combined > 1.0 {
        break
      }
      mean = (mean * weight + sorted_values[next] * sorted_weights[next]) /
        combined
      weight = combined
      next = next + 1
    }
    means.push(mean)
    kept.push(weight)
    at = next
  }
  self.means = means
  self.weights = kept
}

///|
/// The total weight the digest holds.
pub fn TDigest::count(self : TDigest) -> Double {
  self.count_
}

///|
/// The smallest value added, or zero when nothing has been.
pub fn TDigest::minimum(self : TDigest) -> Double {
  self.minimum
}

///|
/// The largest value added, or zero when nothing has been.
pub fn TDigest::maximum(self : TDigest) -> Double {
  self.maximum
}

///|
/// Whether nothing has been added.
pub fn TDigest::is_empty(self : TDigest) -> Bool {
  self.count_ == 0.0
}

///|
/// The value at quantile `q`: interpolated inside the centroid that covers that
/// share of the distribution, and between the extreme and the nearest centroid
/// outside it.
pub fn TDigest::quantile(self : TDigest, q : Double) -> Double {
  if self.count_ == 0.0 {
    return 0.0
  }
  self.compress()
  let target = if q < 0.0 { 0.0 } else if q > 1.0 { 1.0 } else { q }
  if target <= 0.0 {
    return self.minimum
  }
  if target >= 1.0 {
    return self.maximum
  }
  let index = target * self.count_
  let mut cumulative = 0.0
  for i in 0..<self.means.length() {
    let weight = self.weights[i]
    let center = cumulative + weight / 2.0
    if index < center {
      if i == 0 {
        // Below the first centroid's centre, interpolate towards the minimum.
        let span = weight / 2.0
        let share = if span == 0.0 { 0.0 } else { (index - cumulative) / span }
        return self.minimum + (self.means[0] - self.minimum) * share
      }
      let previous_center = cumulative - self.weights[i - 1] / 2.0
      let span = center - previous_center
      let share = if span == 0.0 {
        0.0
      } else {
        (index - previous_center) / span
      }
      return self.means[i - 1] + (self.means[i] - self.means[i - 1]) * share
    }
    cumulative = cumulative + weight
  }
  self.maximum
}

///|
/// The share of the values at or below `value`.
pub fn TDigest::cdf(self : TDigest, value : Double) -> Double {
  if self.count_ == 0.0 {
    return 0.0
  }
  self.compress()
  let mut cumulative = 0.0
  for i in 0..<self.means.length() {
    let weight = self.weights[i]
    if value < self.means[i] {
      if i == 0 {
        let share = if self.means[0] == self.minimum {
          0.0
        } else {
          (value - self.minimum) / (self.means[0] - self.minimum)
        }
        return (cumulative + share * weight / 2.0) / self.count_
      }
      let previous = self.means[i - 1]
      let share = if self.means[i] == previous {
        0.0
      } else {
        (value - previous) / (self.means[i] - previous)
      }
      return (cumulative + share * weight / 2.0) / self.count_
    }
    cumulative = cumulative + weight
  }
  1.0
}

///|
/// Drops every centroid, keeping the compression.
pub fn TDigest::clear(self : TDigest) -> Unit {
  self.means.clear()
  self.weights.clear()
  self.buffer.clear()
  self.count_ = 0.0
  self.minimum = 0.0
  self.maximum = 0.0
}

///|
/// A copy that owns its centroids: an add to either digest leaves the other alone.
pub fn TDigest::copy(self : TDigest) -> TDigest {
  {
    compression: self.compression,
    means: self.means.copy(),
    weights: self.weights.copy(),
    buffer: self.buffer.copy(),
    count_: self.count_,
    minimum: self.minimum,
    maximum: self.maximum,
  }
}

///|
/// Adds every value of another digest, keeping the centroids it had.
pub fn TDigest::merge(self : TDigest, other : TDigest) -> Unit {
  for i in 0..<other.means.length() {
    let weight = other.weights[i]
    let mean = other.means[i]
    self.means.push(mean)
    self.weights.push(weight)
    self.count_ = self.count_ + weight
  }
  for value in other.buffer {
    self.buffer.push(value)
    self.count_ = self.count_ + 1.0
  }
  if other.count_ > 0.0 {
    if self.minimum > other.minimum || self.count_ == other.count_ {
      self.minimum = other.minimum
    }
    if other.maximum > self.maximum {
      self.maximum = other.maximum
    }
  }
  self.compress()
}

///|
/// The digest as bytes, in the format this module reads back with `decode`.
pub fn TDigest::encode(self : TDigest) -> Bytes {
  let writer = Writer::new()
  writer.write_header(MAGIC_TDIGEST)
  writer.write_double(self.compression)
  writer.write_u32(self.count_.to_uint())
  writer.write_double(self.minimum)
  writer.write_double(self.maximum)
  for i in 0..<self.means.length() {
    writer.write_double(self.means[i])
    writer.write_double(self.weights[i])
  }
  writer.to_bytes()
}

///|
/// Reads a digest back from the bytes `encode` wrote, refusing anything that is not one of its states.
pub fn TDigest::decode(view : BytesView) -> TDigest raise @spec.Refused {
  let reader = Reader::new(view)
  reader.read_header(MAGIC_TDIGEST)
  let compression = reader.read_double()
  let count = reader.read_u32().reinterpret_as_int()
  let minimum = reader.read_double()
  let maximum = reader.read_double()
  if !(compression >= 1.0) || count < 0 {
    decode_failure()
  }
  let means : Array[Double] = []
  let weights : Array[Double] = []
  let pairs = reader.remaining() / 16
  for _ in 0..<pairs {
    means.push(reader.read_double())
    weights.push(reader.read_double())
  }
  reader.expect_end()
  {
    compression,
    means,
    weights,
    buffer: [],
    count_: count.to_double(),
    minimum,
    maximum,
  }
}
