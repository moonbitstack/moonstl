const $reinterpret_view = new DataView(new ArrayBuffer(8));
function $i64_reinterpret_f64(a) {
  $reinterpret_view.setBigUint64(0, BigInt.asUintN(64, a), false);
  return $reinterpret_view.getFloat64(0, false);
}
function _M0TPC28internal7strconv9FloatInfo(param0, param1, param2) {
  this.mantissa_bits = param0;
  this.exponent_bits = param1;
  this.bias = param2;
}
function _M0TP212moonbitstack8moonjson6Flavor(param0, param1, param2, param3, param4, param5, param6, param7, param8, param9) {
  this.comments = param0;
  this.trailing_commas = param1;
  this.unquoted_keys = param2;
  this.single_quotes = param3;
  this.extra_numbers = param4;
  this.extra_escapes = param5;
  this.extra_space = param6;
  this.depth = param7;
  this.surrogates = param8;
  this.duplicates = param9;
}
function _M0TP312moonbitstack7moonstl4spec9SeedState(param0, param1) {
  this.value = param0;
  this.random = param1;
}
function _M0TP312moonbitstack7moonstl3phf10PhfOptions(param0, param1) {
  this.build = param0;
  this.seed = param1;
}
function _M0TP312moonbitstack7moonstl3phf11BuildParams(param0, param1, param2, param3) {
  this.bucket_div = param0;
  this.load_den = param1;
  this.load_num = param2;
  this.max_displacement = param3;
}
function _M0TP312moonbitstack7moonstl6sketch12BloomOptions(param0, param1) {
  this.false_positive_rate = param0;
  this.growth = param1;
}
const $bytes_literal$0 = new Uint8Array();
const _M0FPB22uint64__to__string__js = (num, radix) => num.toString(radix);
function _M0TPC16string10StringView(param0, param1, param2) {
  this.str = param0;
  this.start = param1;
  this.end = param2;
}
function $oob() {
  throw new Error("Index out of bounds");
}
class $PanicError extends Error {}
function $panic(message) {
  throw new $PanicError(message);
}
function _M0TPB13StringBuilder(param0) {
  this.val = param0;
}
const _M0FPB12random__seed = () => {
  if (globalThis.crypto?.getRandomValues) {
    const array = new Uint32Array(1);
    globalThis.crypto.getRandomValues(array);
    return array[0] | 0; // Convert to signed 32
  } else {
    return Math.floor(Math.random() * 0x100000000) | 0; // Fallback to Math.random
  }
};
function _M0TPB6Hasher(param0) {
  this.acc = param0;
}
const _M0FPB19int__to__string__js = (x, radix) => {
  return x.toString(radix);
};
function _M0TPB4IterGUcRPB5ArrayGiEEE(param0, param1) {
  this.f = param0;
  this.size_hint = param1;
}
function _M0TPB4IterGcE(param0, param1) {
  this.f = param0;
  this.size_hint = param1;
}
function _M0TPB4IterGiE(param0, param1) {
  this.f = param0;
  this.size_hint = param1;
}
function $makebytes(a, b) {
  const arr = new Uint8Array(a);
  if (b !== 0) {
    arr.fill(b);
  }
  return arr;
}
function _M0TPB5ArrayGcE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TPB5ArrayGRPC14json4JsonE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TPB5ArrayGiE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TPB8MutLocalGiE(param0) {
  this.val = param0;
}
function _M0TPB4IterGRPC14json4JsonE(param0, param1) {
  this.f = param0;
  this.size_hint = param1;
}
function $make_array_len_and_init(a, b) {
  const arr = new Array(a);
  arr.fill(b);
  return arr;
}
function _M0TPB3MapGiiE(param0, param1, param2, param3, param4, param5, param6) {
  this.entries = param0;
  this.size = param1;
  this.capacity = param2;
  this.capacity_mask = param3;
  this.grow_at = param4;
  this.head = param5;
  this.tail = param6;
}
function _M0TPB3MapGsRPC14json4JsonE(param0, param1, param2, param3, param4, param5, param6) {
  this.entries = param0;
  this.size = param1;
  this.capacity = param2;
  this.capacity_mask = param3;
  this.grow_at = param4;
  this.head = param5;
  this.tail = param6;
}
function _M0TPB3MapGcRPB5ArrayGiEE(param0, param1, param2, param3, param4, param5, param6) {
  this.entries = param0;
  this.size = param1;
  this.capacity = param2;
  this.capacity_mask = param3;
  this.grow_at = param4;
  this.head = param5;
  this.tail = param6;
}
function _M0TPB3MapGciE(param0, param1, param2, param3, param4, param5, param6) {
  this.entries = param0;
  this.size = param1;
  this.capacity = param2;
  this.capacity_mask = param3;
  this.grow_at = param4;
  this.head = param5;
  this.tail = param6;
}
function _M0TPB3MapGcuE(param0, param1, param2, param3, param4, param5, param6) {
  this.entries = param0;
  this.size = param1;
  this.capacity = param2;
  this.capacity_mask = param3;
  this.grow_at = param4;
  this.head = param5;
  this.tail = param6;
}
function _M0TPB3MapGzuE(param0, param1, param2, param3, param4, param5, param6) {
  this.entries = param0;
  this.size = param1;
  this.capacity = param2;
  this.capacity_mask = param3;
  this.grow_at = param4;
  this.head = param5;
  this.tail = param6;
}
function _M0TPB5EntryGiiE(param0, param1, param2, param3, param4, param5) {
  this.prev = param0;
  this.next = param1;
  this.psl = param2;
  this.hash = param3;
  this.key = param4;
  this.value = param5;
}
function _M0TPB5EntryGsRPC14json4JsonE(param0, param1, param2, param3, param4, param5) {
  this.prev = param0;
  this.next = param1;
  this.psl = param2;
  this.hash = param3;
  this.key = param4;
  this.value = param5;
}
function _M0TPB5EntryGcRPB5ArrayGiEE(param0, param1, param2, param3, param4, param5) {
  this.prev = param0;
  this.next = param1;
  this.psl = param2;
  this.hash = param3;
  this.key = param4;
  this.value = param5;
}
function _M0TPB5EntryGciE(param0, param1, param2, param3, param4, param5) {
  this.prev = param0;
  this.next = param1;
  this.psl = param2;
  this.hash = param3;
  this.key = param4;
  this.value = param5;
}
function _M0TPB5EntryGcuE(param0, param1, param2, param3, param4, param5) {
  this.prev = param0;
  this.next = param1;
  this.psl = param2;
  this.hash = param3;
  this.key = param4;
  this.value = param5;
}
function _M0TPB5EntryGzuE(param0, param1, param2, param3, param4, param5) {
  this.prev = param0;
  this.next = param1;
  this.psl = param2;
  this.hash = param3;
  this.key = param4;
  this.value = param5;
}
function $bytes_equal(a, b) {
    if (a.length !== b.length) return false;
  for (let i = 0; i < a.length; i++) {
    if (a[i] !== b[i]) return false;
  }
  return true;
}
function _M0TPB8MutLocalGORPB5EntryGsRPC14json4JsonEE(param0) {
  this.val = param0;
}
function _M0TPB8MutLocalGORPB5EntryGcRPB5ArrayGiEEE(param0) {
  this.val = param0;
}
function _M0TPB8MutLocalGORPB5EntryGciEE(param0) {
  this.val = param0;
}
function _M0TPB8MutLocalGORPB5EntryGcuEE(param0) {
  this.val = param0;
}
function _M0TPC15bytes9BytesView(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
function _M0TPB12MutArrayViewGUciEE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
function _M0TPB12MutArrayViewGiE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
function _M0DTPC16result6ResultGuRPB7FailureE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGuRPB7FailureE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGuRPB7FailureE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGuRPB7FailureE2Ok.prototype.$tag = 1;
function _M0DTPC15error5Error46moonbitstack_2fmoonjson_2eRefused_2eUnexpected(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTPC15error5Error46moonbitstack_2fmoonjson_2eRefused_2eUnexpected.prototype.$tag = 33;
function _M0DTPC15error5Error45moonbitstack_2fmoonjson_2eRefused_2eTruncated(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error45moonbitstack_2fmoonjson_2eRefused_2eTruncated.prototype.$tag = 32;
function _M0DTPC15error5Error45moonbitstack_2fmoonjson_2eRefused_2eBadEscape(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error45moonbitstack_2fmoonjson_2eRefused_2eBadEscape.prototype.$tag = 31;
function _M0DTPC15error5Error45moonbitstack_2fmoonjson_2eRefused_2eBadNumber(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error45moonbitstack_2fmoonjson_2eRefused_2eBadNumber.prototype.$tag = 30;
function _M0DTPC15error5Error44moonbitstack_2fmoonjson_2eRefused_2eTrailing(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error44moonbitstack_2fmoonjson_2eRefused_2eTrailing.prototype.$tag = 29;
function _M0DTPC15error5Error43moonbitstack_2fmoonjson_2eRefused_2eTooDeep(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error43moonbitstack_2fmoonjson_2eRefused_2eTooDeep.prototype.$tag = 28;
function _M0DTPC15error5Error43moonbitstack_2fmoonjson_2eRefused_2eBadUtf8(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error43moonbitstack_2fmoonjson_2eRefused_2eBadUtf8.prototype.$tag = 27;
function _M0DTPC15error5Error44moonbitstack_2fmoonjson_2eRefused_2eRepeated(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTPC15error5Error44moonbitstack_2fmoonjson_2eRefused_2eRepeated.prototype.$tag = 26;
function _M0DTPC15error5Error41moonbitstack_2fmoonjson_2eRefused_2eShort(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error41moonbitstack_2fmoonjson_2eRefused_2eShort.prototype.$tag = 25;
function _M0DTPC15error5Error41moonbitstack_2fmoonjson_2eRefused_2eExtra(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error41moonbitstack_2fmoonjson_2eRefused_2eExtra.prototype.$tag = 24;
function _M0DTPC15error5Error39moonbitstack_2fmoonjson_2eRefused_2eBad(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTPC15error5Error39moonbitstack_2fmoonjson_2eRefused_2eBad.prototype.$tag = 23;
function _M0DTPC15error5Error46moonbitstack_2fmoonjson_2eRefused_2eUnwritable(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error46moonbitstack_2fmoonjson_2eRefused_2eUnwritable.prototype.$tag = 22;
function _M0DTPC15error5Error42moonbitstack_2fmoonjson_2eRefused_2eSyntax(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTPC15error5Error42moonbitstack_2fmoonjson_2eRefused_2eSyntax.prototype.$tag = 21;
function _M0DTPC15error5Error43moonbitstack_2fmoonjson_2eRefused_2eMissing(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTPC15error5Error43moonbitstack_2fmoonjson_2eRefused_2eMissing.prototype.$tag = 20;
function _M0DTPC15error5Error48moonbitstack_2fmoonjson_2eRefused_2eNotContainer(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTPC15error5Error48moonbitstack_2fmoonjson_2eRefused_2eNotContainer.prototype.$tag = 19;
function _M0DTPC15error5Error44moonbitstack_2fmoonjson_2eRefused_2eBadIndex(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTPC15error5Error44moonbitstack_2fmoonjson_2eRefused_2eBadIndex.prototype.$tag = 18;
function _M0DTPC15error5Error44moonbitstack_2fmoonjson_2eRefused_2eDocument(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error44moonbitstack_2fmoonjson_2eRefused_2eDocument.prototype.$tag = 17;
function _M0DTPC15error5Error45moonbitstack_2fmoonjson_2eRefused_2eOperation(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTPC15error5Error45moonbitstack_2fmoonjson_2eRefused_2eOperation.prototype.$tag = 16;
function _M0DTPC15error5Error46moonbitstack_2fmoonjson_2eRefused_2eTestFailed(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error46moonbitstack_2fmoonjson_2eRefused_2eTestFailed.prototype.$tag = 15;
function _M0DTPC15error5Error45moonbitstack_2fmoonjson_2eRefused_2eIntoChild(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTPC15error5Error45moonbitstack_2fmoonjson_2eRefused_2eIntoChild.prototype.$tag = 14;
function _M0DTPC15error5Error40moonbitstack_2fmoonjson_2eRefused_2eRoot(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error40moonbitstack_2fmoonjson_2eRefused_2eRoot.prototype.$tag = 13;
function _M0DTPC15error5Error50moonbitstack_2fmoonstl_2fspec_2eRefused_2eCapacity(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error50moonbitstack_2fmoonstl_2fspec_2eRefused_2eCapacity.prototype.$tag = 12;
function _M0DTPC15error5Error53moonbitstack_2fmoonstl_2fspec_2eRefused_2eProbability(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error53moonbitstack_2fmoonstl_2fspec_2eRefused_2eProbability.prototype.$tag = 11;
function _M0DTPC15error5Error47moonbitstack_2fmoonstl_2fspec_2eRefused_2eArity(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error47moonbitstack_2fmoonstl_2fspec_2eRefused_2eArity.prototype.$tag = 10;
function _M0DTPC15error5Error51moonbitstack_2fmoonstl_2fspec_2eRefused_2ePrecision(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error51moonbitstack_2fmoonstl_2fspec_2eRefused_2ePrecision.prototype.$tag = 9;
function _M0DTPC15error5Error56moonbitstack_2fmoonstl_2fspec_2eRefused_2eDuplicateValue() {}
_M0DTPC15error5Error56moonbitstack_2fmoonstl_2fspec_2eRefused_2eDuplicateValue.prototype.$tag = 8;
const _M0DTPC15error5Error56moonbitstack_2fmoonstl_2fspec_2eRefused_2eDuplicateValue__ = new _M0DTPC15error5Error56moonbitstack_2fmoonstl_2fspec_2eRefused_2eDuplicateValue();
function _M0DTPC15error5Error53moonbitstack_2fmoonstl_2fspec_2eRefused_2eNonMonotone(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTPC15error5Error53moonbitstack_2fmoonstl_2fspec_2eRefused_2eNonMonotone.prototype.$tag = 7;
function _M0DTPC15error5Error49moonbitstack_2fmoonstl_2fspec_2eRefused_2eTooMany(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error49moonbitstack_2fmoonstl_2fspec_2eRefused_2eTooMany.prototype.$tag = 6;
function _M0DTPC15error5Error54moonbitstack_2fmoonstl_2fspec_2eRefused_2eIncompatible() {}
_M0DTPC15error5Error54moonbitstack_2fmoonstl_2fspec_2eRefused_2eIncompatible.prototype.$tag = 5;
const _M0DTPC15error5Error54moonbitstack_2fmoonstl_2fspec_2eRefused_2eIncompatible__ = new _M0DTPC15error5Error54moonbitstack_2fmoonstl_2fspec_2eRefused_2eIncompatible();
function _M0DTPC15error5Error49moonbitstack_2fmoonstl_2fspec_2eRefused_2eOverlap() {}
_M0DTPC15error5Error49moonbitstack_2fmoonstl_2fspec_2eRefused_2eOverlap.prototype.$tag = 4;
function _M0DTPC15error5Error48moonbitstack_2fmoonseed_2eUnavailable_2ePlatform() {}
_M0DTPC15error5Error48moonbitstack_2fmoonseed_2eUnavailable_2ePlatform.prototype.$tag = 3;
const _M0DTPC15error5Error48moonbitstack_2fmoonseed_2eUnavailable_2ePlatform__ = new _M0DTPC15error5Error48moonbitstack_2fmoonseed_2eUnavailable_2ePlatform();
function _M0DTPC15error5Error49moonbitstack_2fmoonseed_2eUnavailable_2eExhausted() {}
_M0DTPC15error5Error49moonbitstack_2fmoonseed_2eUnavailable_2eExhausted.prototype.$tag = 2;
function _M0DTPC15error5Error46moonbitstack_2fmoonseed_2eUnavailable_2eFailed(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error46moonbitstack_2fmoonseed_2eUnavailable_2eFailed.prototype.$tag = 1;
function _M0DTPC15error5Error48moonbitlang_2fcore_2fbuiltin_2eFailure_2eFailure(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error48moonbitlang_2fcore_2fbuiltin_2eFailure_2eFailure.prototype.$tag = 0;
function _M0DTPC16result6ResultGRPC16string10StringViewRPB7FailureE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPC16string10StringViewRPB7FailureE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRPC16string10StringViewRPB7FailureE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPC16string10StringViewRPB7FailureE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGORPC28internal7strconv6NumberRPB7FailureE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGORPC28internal7strconv6NumberRPB7FailureE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGORPC28internal7strconv6NumberRPB7FailureE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGORPC28internal7strconv6NumberRPB7FailureE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGdRPB7FailureE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGdRPB7FailureE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGdRPB7FailureE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGdRPB7FailureE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGORPC28internal7strconv6NumberRPC15error5ErrorE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGORPC28internal7strconv6NumberRPC15error5ErrorE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGORPC28internal7strconv6NumberRPC15error5ErrorE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGORPC28internal7strconv6NumberRPC15error5ErrorE2Ok.prototype.$tag = 1;
function _M0TPC28internal7strconv6Number(param0, param1, param2, param3) {
  this.exponent = param0;
  this.mantissa = param1;
  this.negative = param2;
  this.many_digits = param3;
}
function _M0DTPC16result6ResultGdRPC15error5ErrorE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGdRPC15error5ErrorE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGdRPC15error5ErrorE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGdRPC15error5ErrorE2Ok.prototype.$tag = 1;
function $i64_clz(a) {
  a = BigInt.asUintN(64, a);
  if (a === 0n) return 64;
  const hi = Number(a >> 32n);
  if (hi !== 0) {
    return Math.clz32(hi);
  }
  return 32 + Math.clz32(Number(a & 0xffffffffn));
}
function _M0TPC28internal7strconv12EiselProduct(param0, param1) {
  this.lo = param0;
  this.hi = param1;
}
function _M0TPC28internal7strconv7Decimal(param0, param1, param2, param3, param4, param5) {
  this.digits = param0;
  this.digits_num = param1;
  this.decimal_point = param2;
  this.negative = param3;
  this.truncated = param4;
  this.overflowed = param5;
}
function _M0DTPC16result6ResultGRPC28internal7strconv7DecimalRPC15error5ErrorE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPC28internal7strconv7DecimalRPC15error5ErrorE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRPC28internal7strconv7DecimalRPC15error5ErrorE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPC28internal7strconv7DecimalRPC15error5ErrorE2Ok.prototype.$tag = 1;
function $f64_convert_i64_u(a) {
  return Number(a);
}
function _M0DTPC16option6OptionGdE4None() {}
_M0DTPC16option6OptionGdE4None.prototype.$tag = 0;
const _M0DTPC16option6OptionGdE4None__ = new _M0DTPC16option6OptionGdE4None();
function _M0DTPC16option6OptionGdE4Some(param0) {
  this._0 = param0;
}
_M0DTPC16option6OptionGdE4Some.prototype.$tag = 1;
const _M0FPC28encoding4utf816encode__utf8__js = (() => {
   const encoder = new TextEncoder();
   return function(src, start, len, bom) {
     const end = start + len;
     const encoded = encoder.encode(src.slice(start, end));
     if (!bom) {
       return encoded;
     }
     const result = new Uint8Array(encoded.length + 3);
     result[0] = 0xEF;
     result[1] = 0xBB;
     result[2] = 0xBF;
     result.set(encoded, 3);
     return result;
   };
 })();
function _M0TPB5ArrayGsE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TP212moonbitstack8moonjson2At(param0, param1, param2) {
  this.at = param0;
  this.line = param1;
  this.column = param2;
}
function _M0DTPC16result6ResultGuRP212moonbitstack8moonjson7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGuRP212moonbitstack8moonjson7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGuRP212moonbitstack8moonjson7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGuRP212moonbitstack8moonjson7RefusedE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE2Ok.prototype.$tag = 1;
function _M0DTPC14json4Json4Null() {}
_M0DTPC14json4Json4Null.prototype.$tag = 0;
const _M0DTPC14json4Json4Null__ = new _M0DTPC14json4Json4Null();
function _M0DTPC14json4Json4True() {}
_M0DTPC14json4Json4True.prototype.$tag = 1;
const _M0DTPC14json4Json4True__ = new _M0DTPC14json4Json4True();
function _M0DTPC14json4Json5False() {}
_M0DTPC14json4Json5False.prototype.$tag = 2;
const _M0DTPC14json4Json5False__ = new _M0DTPC14json4Json5False();
function _M0DTPC14json4Json6Number(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTPC14json4Json6Number.prototype.$tag = 3;
function _M0DTPC14json4Json6String(param0) {
  this._0 = param0;
}
_M0DTPC14json4Json6String.prototype.$tag = 4;
function _M0DTPC14json4Json5Array(param0) {
  this._0 = param0;
}
_M0DTPC14json4Json5Array.prototype.$tag = 5;
function _M0DTPC14json4Json6Object(param0) {
  this._0 = param0;
}
_M0DTPC14json4Json6Object.prototype.$tag = 6;
function _M0DTPC16result6ResultGiRP212moonbitstack8moonjson7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGiRP212moonbitstack8moonjson7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGiRP212moonbitstack8moonjson7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGiRP212moonbitstack8moonjson7RefusedE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGsRP212moonbitstack8moonjson7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGsRP212moonbitstack8moonjson7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGsRP212moonbitstack8moonjson7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGsRP212moonbitstack8moonjson7RefusedE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGcRP212moonbitstack8moonjson7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGcRP212moonbitstack8moonjson7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGcRP212moonbitstack8moonjson7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGcRP212moonbitstack8moonjson7RefusedE2Ok.prototype.$tag = 1;
function _M0TPB9ArrayViewGUsRPC14json4JsonEE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
function _M0TP212moonbitstack8moonjson6Reader(param0, param1, param2) {
  this.src = param0;
  this.flavor = param1;
  this.i = param2;
}
function _M0DTPC16result6ResultGzRP212moonbitstack8moonseed11UnavailableE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGzRP212moonbitstack8moonseed11UnavailableE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGzRP212moonbitstack8moonseed11UnavailableE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGzRP212moonbitstack8moonseed11UnavailableE2Ok.prototype.$tag = 1;
function _M0TPB9ArrayViewGyE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
const _M0FPC13env23get__random__values__js = function(toBeFilled) {
   const cryptoObj = globalThis.crypto;
   if (cryptoObj === undefined || typeof cryptoObj.getRandomValues !== "function") {
     return false;
   }
   try {
     for (let offset = 0; offset < toBeFilled.length; offset += 65536) {
       cryptoObj.getRandomValues(toBeFilled.subarray(offset, offset + 65536));
     }
     return true;
   } catch (_) {
     return false;
   }
 };
function _M0DTPC16result6ResultGuRP212moonbitstack8moonseed11UnavailableE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGuRP212moonbitstack8moonseed11UnavailableE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGuRP212moonbitstack8moonseed11UnavailableE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGuRP212moonbitstack8moonseed11UnavailableE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGiRPC15error5ErrorE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGiRPC15error5ErrorE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGiRPC15error5ErrorE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGiRPC15error5ErrorE2Ok.prototype.$tag = 1;
function _M0DTPB6ResultGiuE3Err(param0) {
  this._0 = param0;
}
_M0DTPB6ResultGiuE3Err.prototype.$tag = 0;
function _M0DTPB6ResultGiuE2Ok(param0) {
  this._0 = param0;
}
_M0DTPB6ResultGiuE2Ok.prototype.$tag = 1;
function _M0TP312moonbitstack7moonstl4algo12PermutationsGiE(param0, param1, param2, param3, param4, param5) {
  this.pool = param0;
  this.indices = param1;
  this.cycles = param2;
  this.size = param3;
  this.started = param4;
  this.done = param5;
}
function _M0TP312moonbitstack7moonstl4algo12CombinationsGiE(param0, param1, param2, param3) {
  this.pool = param0;
  this.indices = param1;
  this.started = param2;
  this.done = param3;
}
function _M0TP312moonbitstack7moonstl3map4TrieGiE(param0, param1, param2) {
  this.children = param0;
  this.values = param1;
  this.entries = param2;
}
function _M0TPB5ArrayGRPB3MapGciEE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TPB9ArrayViewGUciEE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
function _M0TPB5ArrayGOiE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TPB5ArrayGUciEE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function $compare_int(a, b) {
  return (a >= b) - (a <= b);
}
function _M0TPB5ArrayGUsiEE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TP312moonbitstack7moonstl3map8IndexMapGiiE(param0, param1, param2, param3, param4, param5, param6) {
  this.entries = param0;
  this.hashes = param1;
  this.slots = param2;
  this.slot_of = param3;
  this.live = param4;
  this.graves = param5;
  this.seed = param6;
}
function _M0TPB5ArrayGUiiEE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0DTPC16result6ResultGRP312moonbitstack7moonstl5cache8LruCacheGiiERP312moonbitstack7moonstl4spec7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP312moonbitstack7moonstl5cache8LruCacheGiiERP312moonbitstack7moonstl4spec7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRP312moonbitstack7moonstl5cache8LruCacheGiiERP312moonbitstack7moonstl4spec7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP312moonbitstack7moonstl5cache8LruCacheGiiERP312moonbitstack7moonstl4spec7RefusedE2Ok.prototype.$tag = 1;
function _M0TP312moonbitstack7moonstl5cache8LruCacheGiiE(param0, param1, param2, param3, param4, param5, param6, param7, param8, param9) {
  this.index = param0;
  this.slots = param1;
  this.free = param2;
  this.capacity = param3;
  this.head = param4;
  this.tail = param5;
  this.hits = param6;
  this.misses = param7;
  this.evictions = param8;
  this.on_evict = param9;
}
function _M0TPB5ArrayGORP312moonbitstack7moonstl5cache7LruNodeGiiEE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TP312moonbitstack7moonstl5cache7LruNodeGiiE(param0, param1, param2, param3) {
  this.key = param0;
  this.value = param1;
  this.prev = param2;
  this.next = param3;
}
function _M0TP312moonbitstack7moonstl4heap8DaryHeapGiE(param0, param1, param2) {
  this.arity = param0;
  this.cmp = param1;
  this.items = param2;
}
function $i64_popcnt(a) {
  a = BigInt.asUintN(64, a);
  let lo = Number(a & 0xffffffffn);
  let hi = Number(a >> 32n);
  lo = lo - ((lo >>> 1) & 0x55555555);
  lo = (lo & 0x33333333) + ((lo >>> 2) & 0x33333333);
  lo = (lo + (lo >>> 4)) & 0x0f0f0f0f;
  lo = lo + (lo >>> 8);
  lo = lo + (lo >>> 16);
  hi = hi - ((hi >>> 1) & 0x55555555);
  hi = (hi & 0x33333333) + ((hi >>> 2) & 0x33333333);
  hi = (hi + (hi >>> 4)) & 0x0f0f0f0f;
  hi = hi + (hi >>> 8);
  hi = hi + (hi >>> 16);
  return (lo & 0x3f) + (hi & 0x3f);
}
function _M0TP312moonbitstack7moonstl3phf7PhfRank(param0, param1, param2) {
  this.words = param0;
  this.prefixes = param1;
  this.dense = param2;
}
function _M0DTP312moonbitstack7moonstl3phf8PhfIndex6Direct(param0) {
  this._0 = param0;
}
_M0DTP312moonbitstack7moonstl3phf8PhfIndex6Direct.prototype.$tag = 0;
function _M0DTP312moonbitstack7moonstl3phf8PhfIndex6Ranked(param0) {
  this._0 = param0;
}
_M0DTP312moonbitstack7moonstl3phf8PhfIndex6Ranked.prototype.$tag = 1;
function _M0DTPC16result6ResultGRP312moonbitstack7moonstl3phf8PhfIndexRP312moonbitstack7moonstl4spec7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP312moonbitstack7moonstl3phf8PhfIndexRP312moonbitstack7moonstl4spec7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRP312moonbitstack7moonstl3phf8PhfIndexRP312moonbitstack7moonstl4spec7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP312moonbitstack7moonstl3phf8PhfIndexRP312moonbitstack7moonstl4spec7RefusedE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGRP312moonbitstack7moonstl3phf6PhfMapGsiERP312moonbitstack7moonstl4spec7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP312moonbitstack7moonstl3phf6PhfMapGsiERP312moonbitstack7moonstl4spec7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRP312moonbitstack7moonstl3phf6PhfMapGsiERP312moonbitstack7moonstl4spec7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP312moonbitstack7moonstl3phf6PhfMapGsiERP312moonbitstack7moonstl4spec7RefusedE2Ok.prototype.$tag = 1;
function _M0TP312moonbitstack7moonstl3phf6PhfMapGsiE(param0, param1, param2, param3) {
  this.layout = param0;
  this.keys = param1;
  this.values = param2;
  this.index = param3;
}
function _M0TP312moonbitstack7moonstl3phf10PhfBuilderGsiE(param0, param1, param2, param3) {
  this.options = param0;
  this.keys = param1;
  this.values = param2;
  this.seen = param3;
}
function _M0TPB9ArrayViewGUzuEE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
function _M0DTPC16result6ResultGuRP312moonbitstack7moonstl4spec7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGuRP312moonbitstack7moonstl4spec7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGuRP312moonbitstack7moonstl4spec7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGuRP312moonbitstack7moonstl4spec7RefusedE2Ok.prototype.$tag = 1;
function _M0TP312moonbitstack7moonstl3phf9PhfLayout(param0, param1, param2, param3, param4, param5) {
  this.build = param0;
  this.salt = param1;
  this.buckets = param2;
  this.table_len = param3;
  this.length = param4;
  this.disps = param5;
}
function _M0TPB5ArrayGzE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0DTPC16result6ResultGRP312moonbitstack7moonstl3seq10RingBufferGiERP312moonbitstack7moonstl4spec7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP312moonbitstack7moonstl3seq10RingBufferGiERP312moonbitstack7moonstl4spec7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRP312moonbitstack7moonstl3seq10RingBufferGiERP312moonbitstack7moonstl4spec7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP312moonbitstack7moonstl3seq10RingBufferGiERP312moonbitstack7moonstl4spec7RefusedE2Ok.prototype.$tag = 1;
function _M0TP312moonbitstack7moonstl3seq10RingBufferGiE(param0, param1, param2, param3, param4) {
  this.slots = param0;
  this.head = param1;
  this.len = param2;
  this.capacity = param3;
  this.overflow = param4;
}
function _M0TPB5ArrayGmE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TP312moonbitstack7moonstl3seq6BitSet(param0) {
  this.words = param0;
}
function _M0DTPC16result6ResultGRP312moonbitstack7moonstl6sketch14CountMinSketchGiERP312moonbitstack7moonstl4spec7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP312moonbitstack7moonstl6sketch14CountMinSketchGiERP312moonbitstack7moonstl4spec7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRP312moonbitstack7moonstl6sketch14CountMinSketchGiERP312moonbitstack7moonstl4spec7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP312moonbitstack7moonstl6sketch14CountMinSketchGiERP312moonbitstack7moonstl4spec7RefusedE2Ok.prototype.$tag = 1;
function _M0TP312moonbitstack7moonstl6sketch14CountMinSketchGiE(param0, param1, param2, param3, param4) {
  this.seed = param0;
  this.width = param1;
  this.depth = param2;
  this.counters = param3;
  this.total = param4;
}
function _M0TP312moonbitstack7moonstl6sketch10BloomLayer(param0, param1, param2, param3, param4) {
  this.words = param0;
  this.bit_count = param1;
  this.capacity = param2;
  this.items = param3;
  this.rate = param4;
}
function _M0DTPC16result6ResultGRP312moonbitstack7moonstl6sketch11BloomFilterGiERP312moonbitstack7moonstl4spec7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP312moonbitstack7moonstl6sketch11BloomFilterGiERP312moonbitstack7moonstl4spec7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRP312moonbitstack7moonstl6sketch11BloomFilterGiERP312moonbitstack7moonstl4spec7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP312moonbitstack7moonstl6sketch11BloomFilterGiERP312moonbitstack7moonstl4spec7RefusedE2Ok.prototype.$tag = 1;
function _M0TP312moonbitstack7moonstl6sketch11BloomFilterGiE(param0, param1, param2, param3, param4, param5, param6) {
  this.hash_seed = param0;
  this.hashes = param1;
  this.expected_items = param2;
  this.false_positive_rate = param3;
  this.growth = param4;
  this.layers = param5;
  this.items = param6;
}
function _M0TPB5ArrayGRP312moonbitstack7moonstl6sketch10BloomLayerE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function $f64_convert_i64(a) {
  return Number(BigInt.asIntN(64, a));
}
function _M0TP312moonbitstack7moonstl4text3Kmp(param0, param1) {
  this.pattern = param0;
  this.fail = param1;
}
function _M0TP312moonbitstack7moonstl4text9EmptyScan(param0, param1) {
  this.pos = param0;
  this.end = param1;
}
function _M0TP312moonbitstack7moonstl4text7KmpScan(param0, param1, param2, param3, param4) {
  this.pattern = param0;
  this.fail = param1;
  this.text = param2;
  this.pos = param3;
  this.matched = param4;
}
function _M0TP312moonbitstack7moonstl4text22SequenceMatcherOptionsGcE(param0, param1) {
  this.autojunk = param0;
  this.junk = param1;
}
function _M0TPB5ArrayGbE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TPB9ArrayViewGUcRPB5ArrayGiEEE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
function _M0TPB9ArrayViewGUcuEE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
function _M0TP312moonbitstack7moonstl4text15SequenceMatcherGcE(param0, param1, param2, param3, param4, param5) {
  this.a = param0;
  this.b = param1;
  this.options = param2;
  this.b2j = param3;
  this.bjunk = param4;
  this.bpopular = param5;
}
function _M0TPB9ArrayViewGUiiEE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
function _M0TP312moonbitstack7moonstl4text5Match(param0, param1, param2) {
  this.a_start = param0;
  this.b_start = param1;
  this.size = param2;
}
function _M0TPB5ArrayGRP312moonbitstack7moonstl4text5MatchE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TPB5ArrayGUiiiiEE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TPB5ArrayGRP312moonbitstack7moonstl4text6OpcodeE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0DTP312moonbitstack7moonstl4text6Opcode5Equal(param0, param1, param2, param3) {
  this._0 = param0;
  this._1 = param1;
  this._2 = param2;
  this._3 = param3;
}
_M0DTP312moonbitstack7moonstl4text6Opcode5Equal.prototype.$tag = 0;
function _M0DTP312moonbitstack7moonstl4text6Opcode7Replace(param0, param1, param2, param3) {
  this._0 = param0;
  this._1 = param1;
  this._2 = param2;
  this._3 = param3;
}
_M0DTP312moonbitstack7moonstl4text6Opcode7Replace.prototype.$tag = 1;
function _M0DTP312moonbitstack7moonstl4text6Opcode6Delete(param0, param1, param2, param3) {
  this._0 = param0;
  this._1 = param1;
  this._2 = param2;
  this._3 = param3;
}
_M0DTP312moonbitstack7moonstl4text6Opcode6Delete.prototype.$tag = 2;
function _M0DTP312moonbitstack7moonstl4text6Opcode6Insert(param0, param1, param2, param3) {
  this._0 = param0;
  this._1 = param1;
  this._2 = param2;
  this._3 = param3;
}
_M0DTP312moonbitstack7moonstl4text6Opcode6Insert.prototype.$tag = 3;
function _M0TP312moonbitstack7moonstl4tree11SegmentTreeGiE(param0, param1, param2, param3) {
  this.op = param0;
  this.identity = param1;
  this.size = param2;
  this.nodes = param3;
}
function _M0TP312moonbitstack7moonstl4tree11DisjointSet(param0, param1, param2) {
  this.parents = param0;
  this.sizes = param1;
  this.sets = param2;
}
function _M0TPB5ArrayGRPB5ArrayGiEE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
const _M0FP223moonstl_2dsite_2dbridge4main6expose = function(run, names){ globalThis.moonstl = { run: run, names: names }; };
function _M0DTPC16result6ResultGsRPC15error5ErrorE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGsRPC15error5ErrorE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGsRPC15error5ErrorE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGsRPC15error5ErrorE2Ok.prototype.$tag = 1;
function _M0TPB9ArrayViewGiE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
function _M0TPB9ArrayViewGcE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
const _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger = { method_0: _M0IPB13StringBuilderPB6Logger13write__string, method_1: _M0IP016_24default__implPB6Logger16write__substringGRPB13StringBuilderE, method_2: _M0IPB13StringBuilderPB6Logger11write__view, method_3: _M0IPB13StringBuilderPB6Logger11write__char, method_4: _M0IP016_24default__implPB6Logger28write__string__interpolationGRPB13StringBuilderE, method_5: _M0IP016_24default__implPB6Logger5writeGRPB13StringBuilderE };
function _M0FP15Error10to__string(_e) {
  const _f = _M0FP15Error10_2amethods[_e.$tag]._1;
  return _f(_e);
}
const _M0FP15Error13_2amethods__0 = { _0: "", _1: (_e) => _M0IP016_24default__implPB4Show10to__stringGRPB7FailureE(_e) };
const _M0FP15Error13_2amethods__1 = { _0: "", _1: (_e) => _M0IP016_24default__implPB4Show10to__stringGRP212moonbitstack8moonseed11UnavailableE(_e) };
const _M0FP15Error13_2amethods__2 = { _0: "", _1: (_e) => _M0IP016_24default__implPB4Show10to__stringGRP212moonbitstack8moonseed11UnavailableE(_e) };
const _M0FP15Error13_2amethods__3 = { _0: "", _1: (_e) => _M0IP016_24default__implPB4Show10to__stringGRP212moonbitstack8moonseed11UnavailableE(_e) };
const _M0FP15Error13_2amethods__4 = { _0: "", _1: (_e) => _M0IP016_24default__implPB4Show10to__stringGRP312moonbitstack7moonstl4spec7RefusedE(_e) };
const _M0FP15Error13_2amethods__5 = { _0: "", _1: (_e) => _M0IP016_24default__implPB4Show10to__stringGRP312moonbitstack7moonstl4spec7RefusedE(_e) };
const _M0FP15Error13_2amethods__6 = { _0: "", _1: (_e) => _M0IP016_24default__implPB4Show10to__stringGRP312moonbitstack7moonstl4spec7RefusedE(_e) };
const _M0FP15Error13_2amethods__7 = { _0: "", _1: (_e) => _M0IP016_24default__implPB4Show10to__stringGRP312moonbitstack7moonstl4spec7RefusedE(_e) };
const _M0FP15Error13_2amethods__8 = { _0: "", _1: (_e) => _M0IP016_24default__implPB4Show10to__stringGRP312moonbitstack7moonstl4spec7RefusedE(_e) };
const _M0FP15Error13_2amethods__9 = { _0: "", _1: (_e) => _M0IP016_24default__implPB4Show10to__stringGRP312moonbitstack7moonstl4spec7RefusedE(_e) };
const _M0FP15Error14_2amethods__10 = { _0: "", _1: (_e) => _M0IP016_24default__implPB4Show10to__stringGRP312moonbitstack7moonstl4spec7RefusedE(_e) };
const _M0FP15Error14_2amethods__11 = { _0: "", _1: (_e) => _M0IP016_24default__implPB4Show10to__stringGRP312moonbitstack7moonstl4spec7RefusedE(_e) };
const _M0FP15Error14_2amethods__12 = { _0: "", _1: (_e) => _M0IP016_24default__implPB4Show10to__stringGRP312moonbitstack7moonstl4spec7RefusedE(_e) };
const _M0FP15Error14_2amethods__13 = { _0: "moonbitstack/moonjson.Refused.Root", _1: (_e) => _M0FP15Error10_2amethods[_e.$tag]._0 };
const _M0FP15Error14_2amethods__14 = { _0: "moonbitstack/moonjson.Refused.IntoChild", _1: (_e) => _M0FP15Error10_2amethods[_e.$tag]._0 };
const _M0FP15Error14_2amethods__15 = { _0: "moonbitstack/moonjson.Refused.TestFailed", _1: (_e) => _M0FP15Error10_2amethods[_e.$tag]._0 };
const _M0FP15Error14_2amethods__16 = { _0: "moonbitstack/moonjson.Refused.Operation", _1: (_e) => _M0FP15Error10_2amethods[_e.$tag]._0 };
const _M0FP15Error14_2amethods__17 = { _0: "moonbitstack/moonjson.Refused.Document", _1: (_e) => _M0FP15Error10_2amethods[_e.$tag]._0 };
const _M0FP15Error14_2amethods__18 = { _0: "moonbitstack/moonjson.Refused.BadIndex", _1: (_e) => _M0FP15Error10_2amethods[_e.$tag]._0 };
const _M0FP15Error14_2amethods__19 = { _0: "moonbitstack/moonjson.Refused.NotContainer", _1: (_e) => _M0FP15Error10_2amethods[_e.$tag]._0 };
const _M0FP15Error14_2amethods__20 = { _0: "moonbitstack/moonjson.Refused.Missing", _1: (_e) => _M0FP15Error10_2amethods[_e.$tag]._0 };
const _M0FP15Error14_2amethods__21 = { _0: "moonbitstack/moonjson.Refused.Syntax", _1: (_e) => _M0FP15Error10_2amethods[_e.$tag]._0 };
const _M0FP15Error14_2amethods__22 = { _0: "moonbitstack/moonjson.Refused.Unwritable", _1: (_e) => _M0FP15Error10_2amethods[_e.$tag]._0 };
const _M0FP15Error14_2amethods__23 = { _0: "moonbitstack/moonjson.Refused.Bad", _1: (_e) => _M0FP15Error10_2amethods[_e.$tag]._0 };
const _M0FP15Error14_2amethods__24 = { _0: "moonbitstack/moonjson.Refused.Extra", _1: (_e) => _M0FP15Error10_2amethods[_e.$tag]._0 };
const _M0FP15Error14_2amethods__25 = { _0: "moonbitstack/moonjson.Refused.Short", _1: (_e) => _M0FP15Error10_2amethods[_e.$tag]._0 };
const _M0FP15Error14_2amethods__26 = { _0: "moonbitstack/moonjson.Refused.Repeated", _1: (_e) => _M0FP15Error10_2amethods[_e.$tag]._0 };
const _M0FP15Error14_2amethods__27 = { _0: "moonbitstack/moonjson.Refused.BadUtf8", _1: (_e) => _M0FP15Error10_2amethods[_e.$tag]._0 };
const _M0FP15Error14_2amethods__28 = { _0: "moonbitstack/moonjson.Refused.TooDeep", _1: (_e) => _M0FP15Error10_2amethods[_e.$tag]._0 };
const _M0FP15Error14_2amethods__29 = { _0: "moonbitstack/moonjson.Refused.Trailing", _1: (_e) => _M0FP15Error10_2amethods[_e.$tag]._0 };
const _M0FP15Error14_2amethods__30 = { _0: "moonbitstack/moonjson.Refused.BadNumber", _1: (_e) => _M0FP15Error10_2amethods[_e.$tag]._0 };
const _M0FP15Error14_2amethods__31 = { _0: "moonbitstack/moonjson.Refused.BadEscape", _1: (_e) => _M0FP15Error10_2amethods[_e.$tag]._0 };
const _M0FP15Error14_2amethods__32 = { _0: "moonbitstack/moonjson.Refused.Truncated", _1: (_e) => _M0FP15Error10_2amethods[_e.$tag]._0 };
const _M0FP15Error14_2amethods__33 = { _0: "moonbitstack/moonjson.Refused.Unexpected", _1: (_e) => _M0FP15Error10_2amethods[_e.$tag]._0 };
const _M0FP15Error10_2amethods = [_M0FP15Error13_2amethods__0, _M0FP15Error13_2amethods__1, _M0FP15Error13_2amethods__2, _M0FP15Error13_2amethods__3, _M0FP15Error13_2amethods__4, _M0FP15Error13_2amethods__5, _M0FP15Error13_2amethods__6, _M0FP15Error13_2amethods__7, _M0FP15Error13_2amethods__8, _M0FP15Error13_2amethods__9, _M0FP15Error14_2amethods__10, _M0FP15Error14_2amethods__11, _M0FP15Error14_2amethods__12, _M0FP15Error14_2amethods__13, _M0FP15Error14_2amethods__14, _M0FP15Error14_2amethods__15, _M0FP15Error14_2amethods__16, _M0FP15Error14_2amethods__17, _M0FP15Error14_2amethods__18, _M0FP15Error14_2amethods__19, _M0FP15Error14_2amethods__20, _M0FP15Error14_2amethods__21, _M0FP15Error14_2amethods__22, _M0FP15Error14_2amethods__23, _M0FP15Error14_2amethods__24, _M0FP15Error14_2amethods__25, _M0FP15Error14_2amethods__26, _M0FP15Error14_2amethods__27, _M0FP15Error14_2amethods__28, _M0FP15Error14_2amethods__29, _M0FP15Error14_2amethods__30, _M0FP15Error14_2amethods__31, _M0FP15Error14_2amethods__32, _M0FP15Error14_2amethods__33];
const _M0FPB18double__max__value = $i64_reinterpret_f64(9218868437227405311n);
const _M0FPB18double__min__value = $i64_reinterpret_f64(18442240474082181119n);
const _M0MPB4Iter4nextN6constrS661GUcRPB5ArrayGiEEE = 0;
const _M0MPB4Iter4nextN6constrS662GUcRPB5ArrayGiEEE = 0;
const _M0MPB4Iter4nextN6constrS693GcE = 0;
const _M0MPB4Iter4nextN6constrS694GcE = 0;
const _M0MPB4Iter4nextN6constrS717GiE = 0;
const _M0MPB4Iter4nextN6constrS718GiE = 0;
const _M0MPB4Iter3newN6constrS735GUcRPB5ArrayGiEEE = 0;
const _M0MPB4Iter3newN6constrS759GcE = 0;
const _M0MPB4Iter3newN6constrS771GiE = 0;
const _M0FPC16double14not__a__number = $i64_reinterpret_f64(9221120237041090561n);
const _M0FPC16double8infinity = $i64_reinterpret_f64(9218868437227405312n);
const _M0FPC16double13neg__infinity = $i64_reinterpret_f64(18442240474082181120n);
const _M0FPC28internal7strconv15range__err__str = "value out of range";
const _M0FPC28internal7strconv16syntax__err__str = "invalid syntax";
const _M0FPC28internal7strconv17min__19digit__int = 1000000000000000000n;
const _M0FPC28internal7strconv27eisel__lemire__pow10__table = [18054884314459144840n, 1671618768450675795n, 11284302696536965525n, 1044761730281672372n, 14105378370671206906n, 5917638181279478369n, 17631722963339008632n, 16620419763454123769n, 11019826852086880395n, 10387762352158827356n, 13774783565108600494n, 8373016921771146291n, 17218479456385750618n, 1242899115359157055n, 10761549660241094136n, 5388497965526861063n, 13451937075301367670n, 6735622456908576329n, 16814921344126709587n, 17642900107990496220n, 10509325840079193492n, 8720969558280366185n, 13136657300098991865n, 10901211947850457732n, 16420821625123739831n, 18238200953240460069n, 10263013515702337394n, 18316404623416369399n, 12828766894627921743n, 13672133742415685941n, 16035958618284902179n, 12478481159592219522n, 10022474136428063862n, 5493207715531443249n, 12528092670535079827n, 16089881681269079869n, 15660115838168849784n, 15500666083158961933n, 9787572398855531115n, 9687916301974351208n, 12234465498569413894n, 7498209359040551106n, 15293081873211767368n, 149389661945913074n, 9558176170757354605n, 93368538716195671n, 11947720213446693256n, 4728396691822632493n, 14934650266808366570n, 5910495864778290617n, 9334156416755229106n, 8305745933913819539n, 11667695520944036383n, 1158810380537498616n, 14584619401180045478n, 15283571030954036982n, 18230774251475056848n, 9881091751837770420n, 11394233907171910530n, 6175682344898606512n, 14242792383964888162n, 16942974967978033949n, 17803490479956110203n, 11955346673117766628n, 11127181549972568877n, 5166248661484910190n, 13908976937465711096n, 11069496845283525642n, 17386221171832138870n, 13836871056604407053n, 10866388232395086794n, 4036358391950366504n, 13582985290493858492n, 14268820026792733938n, 16978731613117323115n, 17836025033490917422n, 10611707258198326947n, 8841672636718129437n, 13264634072747908684n, 6440404777470273892n, 16580792590934885855n, 8050505971837842365n, 10362995369334303659n, 11949095260039733334n, 12953744211667879574n, 10324683056622278764n, 16192180264584849468n, 3682481783923072647n, 10120112665365530917n, 11524923151806696212n, 12650140831706913647n, 571095884476206553n, 15812676039633642058n, 14548927910877421904n, 9882922524771026286n, 13704765962725776594n, 12353653155963782858n, 7907585416552444934n, 15442066444954728573n, 661109733835780360n, 9651291528096705358n, 2719036592861056677n, 12064114410120881697n, 12622167777931096654n, 15080143012651102122n, 1942651667131707105n, 9425089382906938826n, 5825843310384704845n, 11781361728633673532n, 16505676174835656864n, 14726702160792091916n, 2185351144835019464n, 18408377700990114895n, 2731688931043774330n, 11505236063118821809n, 8624834609543440812n, 14381545078898527261n, 15392729280356688919n, 17976931348623159077n, 5405853545163697437n, 11235582092889474423n, 5684501474941004850n, 14044477616111843029n, 2493940825248868159n, 17555597020139803786n, 7729112049988473103n, 10972248137587377366n, 9442381049670183593n, 13715310171984221708n, 2579604275232953683n, 17144137714980277135n, 3224505344041192104n, 10715086071862673209n, 8932844867666826921n, 13393857589828341511n, 15777742103010921555n, 16742321987285426889n, 15110491610336264040n, 10463951242053391806n, 2526528228819083169n, 13079939052566739757n, 12381532322878629770n, 16349923815708424697n, 1641857348316123500n, 10218702384817765435n, 12555375888766046947n, 12773377981022206794n, 11082533842530170780n, 15966722476277758493n, 4629795266307937667n, 9979201547673599058n, 5199465050656154994n, 12474001934591998822n, 15722703350174969551n, 15592502418239998528n, 10430007150863936130n, 9745314011399999080n, 6518754469289960081n, 12181642514249998850n, 8148443086612450102n, 15227053142812498563n, 962181821410786819n, 9516908214257811601n, 16742264702877599426n, 11896135267822264502n, 7092772823314835570n, 14870169084777830627n, 18089338065998320271n, 9293855677986144142n, 8999993282035256217n, 11617319597482680178n, 2026619565689294464n, 14521649496853350222n, 11756646493966393888n, 18152061871066687778n, 5472436080603216552n, 11345038669416679861n, 8031958568804398249n, 14181298336770849826n, 14651634229432885715n, 17726622920963562283n, 9091170749936331336n, 11079139325602226427n, 3376138709496513133n, 13848924157002783033n, 18055231442152805128n, 17311155196253478792n, 8733981247408842698n, 10819471997658424245n, 5458738279630526686n, 13524339997073030306n, 11435108867965546262n, 16905424996341287883n, 5070514048102157020n, 10565890622713304927n, 863228270850154185n, 13207363278391631158n, 14914093393844856443n, 16509204097989538948n, 9419244705451294746n, 10318252561243461842n, 15110399977761835024n, 12897815701554327303n, 9664627935347517973n, 16122269626942909129n, 7469098900757009562n, 10076418516839318205n, 16197401859041600736n, 12595523146049147757n, 6411694268519837208n, 15744403932561434696n, 12626303854077184414n, 9840252457850896685n, 7891439908798240259n, 12300315572313620856n, 14475985904425188227n, 15375394465392026070n, 18094982380531485284n, 9609621540870016294n, 6697677969404790399n, 12012026926087520367n, 17595469498610763806n, 15015033657609400459n, 17382650854836066854n, 9384396036005875287n, 8558313775058847832n, 11730495045007344109n, 6086206200396171886n, 14663118806259180136n, 12219443768922602761n, 18328898507823975170n, 15274304711153253452n, 11455561567389984481n, 14158126462898171311n, 14319451959237480602n, 3862600023340550427n, 17899314949046850752n, 14051622066030463842n, 11187071843154281720n, 8782263791269039901n, 13983839803942852150n, 10977829739086299876n, 17479799754928565188n, 4498915137003099037n, 10924874846830353242n, 12035193997481712706n, 13656093558537941553n, 5820620459997365075n, 17070116948172426941n, 11887461593424094248n, 10668823092607766838n, 9735506505103752857n, 13336028865759708548n, 2946011094524915263n, 16670036082199635685n, 3682513868156144079n, 10418772551374772303n, 4607414176811284001n, 13023465689218465379n, 1147581702586717097n, 16279332111523081723n, 15269535183515560084n, 10174582569701926077n, 7237616480483531100n, 12718228212127407596n, 13658706619031801779n, 15897785265159259495n, 17073383273789752224n, 9936115790724537184n, 17588393573759676996n, 12420144738405671481n, 3538747893490044629n, 15525180923007089351n, 9035120885289943691n, 9703238076879430844n, 12564479580947296663n, 12129047596099288555n, 15705599476184120828n, 15161309495124110694n, 15020313326802763131n, 9475818434452569184n, 4776009810824339053n, 11844773043065711480n, 5970012263530423816n, 14805966303832139350n, 7462515329413029771n, 9253728939895087094n, 52386062455755702n, 11567161174868858867n, 9288854614924470436n, 14458951468586073584n, 6999382250228200141n, 18073689335732591980n, 8749227812785250177n, 11296055834832869987n, 14691639419845557168n, 14120069793541087484n, 13752863256379558556n, 17650087241926359355n, 17191079070474448196n, 11031304526203974597n, 8438581409832836170n, 13789130657754968246n, 15159912780718433117n, 17236413322193710308n, 9726518939043265588n, 10772758326371068942n, 15302446373756816800n, 13465947907963836178n, 9904685930341245193n, 16832434884954795223n, 3157485376071780683n, 10520271803096747014n, 8890957387685944783n, 13150339753870933768n, 1890324697752655170n, 16437924692338667210n, 2362905872190818963n, 10273702932711667006n, 6088502188546649756n, 12842128665889583757n, 16833999772538088003n, 16052660832361979697n, 7207441660390446292n, 10032913020226237310n, 16033866083812498692n, 12541141275282796638n, 10818960567910847557n, 15676426594103495798n, 4300328673033783639n, 9797766621314684873n, 16522763475928278486n, 12247208276643356092n, 6818396289628184396n, 15309010345804195115n, 8522995362035230495n, 9568131466127621947n, 3021029092058325107n, 11960164332659527433n, 17611344420355070096n, 14950205415824409292n, 8179122470161673908n, 9343878384890255807n, 14335323580705822000n, 11679847981112819759n, 13307468457454889596n, 14599809976391024699n, 12022649553391224092n, 18249762470488780874n, 10416625923311642211n, 11406101544055488046n, 11122077220497164286n, 14257626930069360058n, 4679224488766679549n, 17822033662586700072n, 15072402647813125244n, 11138771039116687545n, 9420251654883203278n, 13923463798895859431n, 16387000587031392001n, 17404329748619824289n, 15872064715361852097n, 10877706092887390181n, 3002511419460075705n, 13597132616109237726n, 8364825292752482535n, 16996415770136547158n, 1232659579085827361n, 10622759856335341973n, 14605470292210805812n, 13278449820419177467n, 4421779809981343554n, 16598062275523971834n, 915538744049291538n, 10373788922202482396n, 5183897733458195115n, 12967236152753102995n, 6479872166822743894n, 16209045190941378744n, 3488154190101041964n, 10130653244338361715n, 2180096368813151227n, 12663316555422952143n, 16560178516298602746n, 15829145694278690179n, 16088537126945865529n, 9893216058924181362n, 7749492695127472003n, 12366520073655226703n, 463493832054564196n, 15458150092069033378n, 14414425345350368957n, 9661343807543145861n, 13620701859271368502n, 12076679759428932327n, 3190819268807046916n, 15095849699286165408n, 17823582141290972357n, 9434906062053853380n, 11139738838306857723n, 11793632577567316725n, 13924673547883572154n, 14742040721959145907n, 3570783879572301480n, 18427550902448932383n, 18298537904747540562n, 11517219314030582739n, 18354115218108294707n, 14396524142538228424n, 18330958004207980480n, 17995655178172785531n, 4466953431550423984n, 11247284486357990957n, 486002885505321038n, 14059105607947488696n, 5219189625309039202n, 17573882009934360870n, 6523987031636299002n, 10983676256208975543n, 17912549950054850588n, 13729595320261219429n, 17779001419141175331n, 17161994150326524287n, 8388693718644305452n, 10726246343954077679n, 12160462601793772764n, 13407807929942597099n, 10588892233814828051n, 16759759912428246374n, 8624429273841147159n, 10474849945267653984n, 778582277723329070n, 13093562431584567480n, 973227847154161338n, 16366953039480709350n, 1216534808942701673n, 10229345649675443343n, 14595392310871352257n, 12786682062094304179n, 13632554370161802418n, 15983352577617880224n, 12429006944274865118n, 9989595361011175140n, 7768129340171790699n, 12486994201263968925n, 9710161675214738374n, 15608742751579961156n, 16749388112445810871n, 9755464219737475723n, 1244995533423855986n, 12194330274671844653n, 15391302472061983695n, 15242912843339805817n, 5404070034795315907n, 9526820527087378635n, 14906758817815542202n, 11908525658859223294n, 14021762503842039848n, 14885657073574029118n, 8303831092947774002n, 9303535670983768199n, 578208414664970847n, 11629419588729710248n, 14557818573613377271n, 14536774485912137810n, 18197273217016721589n, 18170968107390172263n, 13523219484416126178n, 11356855067118857664n, 15369541205401160717n, 14196068833898572081n, 765182433041899281n, 17745086042373215101n, 5568164059729762005n, 11090678776483259438n, 5785945546544795205n, 13863348470604074297n, 16455803970035769814n, 17329185588255092872n, 6734696907262548556n, 10830740992659433045n, 4209185567039092847n, 13538426240824291306n, 9873167977226253963n, 16923032801030364133n, 3118087934678041646n, 10576895500643977583n, 4254647968387469981n, 13221119375804971979n, 706623942056949572n, 16526399219756214973n, 14718337982853350677n, 10328999512347634358n, 11504804248497038125n, 12911249390434542948n, 5157633273766521849n, 16139061738043178685n, 6447041592208152311n, 10086913586276986678n, 6335244004343789146n, 12608641982846233347n, 17142427042284512241n, 15760802478557791684n, 16816347784428252397n, 9850501549098619803n, 1286845328412881940n, 12313126936373274753n, 15443614715798266137n, 15391408670466593442n, 5469460339465668959n, 9619630419041620901n, 8030098730593431003n, 12024538023802026126n, 14649309431669176658n, 15030672529752532658n, 9088264752731695015n, 9394170331095332911n, 10291851488884697288n, 11742712913869166139n, 8253128342678483706n, 14678391142336457674n, 5704724409920716729n, 18347988927920572092n, 16354277549255671720n, 11467493079950357558n, 998051431430019017n, 14334366349937946947n, 10470936326142299579n, 17917957937422433684n, 8476984389250486570n, 11198723710889021052n, 14521487280136329914n, 13998404638611276315n, 18151859100170412392n, 17498005798264095394n, 18078137856785627587n, 10936253623915059621n, 15910522178918405146n, 13670317029893824527n, 6053094668365842720n, 17087896287367280659n, 2954682317029915496n, 10679935179604550411n, 17987577512639554849n, 13349918974505688014n, 17872785872372055657n, 16687398718132110018n, 13117610303610293764n, 10429624198832568761n, 12810192458183821506n, 13037030248540710952n, 2177682517447613171n, 16296287810675888690n, 2722103146809516464n, 10185179881672430431n, 6313000485183335694n, 12731474852090538039n, 3279564588051781713n, 15914343565113172548n, 17934513790346890853n, 9946464728195732843n, 1985699082112030975n, 12433080910244666053n, 16317181907922202431n, 15541351137805832567n, 6561419329620589327n, 9713344461128645354n, 11018416108653950185n, 12141680576410806693n, 4549648098962661924n, 15177100720513508366n, 10298746142130715309n, 9485687950320942729n, 1825030320404309164n, 11857109937901178411n, 6892973918932774359n, 14821387422376473014n, 4004531380238580045n, 9263367138985295633n, 16337890167931276240n, 11579208923731619542n, 6587304654631931588n, 14474011154664524427n, 17457502855144690293n, 18092513943330655534n, 17210192550503474962n, 11307821214581659709n, 6144684325637283947n, 14134776518227074636n, 12292541425473992838n, 17668470647783843295n, 15365676781842491048n, 11042794154864902059n, 16521077016292638761n, 13803492693581127574n, 16039660251938410547n, 17254365866976409468n, 10826203278068237376n, 10783978666860255917n, 15989749085647424168n, 13479973333575319897n, 6152128301777116498n, 16849966666969149871n, 12301846395648783526n, 10531229166855718669n, 14606183024921571560n, 13164036458569648337n, 4422670725869800738n, 16455045573212060421n, 10140024425764638826n, 10284403483257537763n, 8643358275316593218n, 12855504354071922204n, 6192511825718353619n, 16069380442589902755n, 7740639782147942024n, 10043362776618689222n, 2532056854628769813n, 12554203470773361527n, 12388443105140738074n, 15692754338466701909n, 10873867862998534689n, 9807971461541688693n, 9102010423587778132n, 12259964326927110866n, 15989199047912110569n, 15324955408658888583n, 10763126773035362404n, 9578097130411805364n, 13644483260788183358n, 11972621413014756705n, 17055604075985229198n, 14965776766268445882n, 7484447039699372786n, 9353610478917778676n, 9289465418239495895n, 11692013098647223345n, 11611831772799369869n, 14615016373309029182n, 679731660717048624n, 18268770466636286477n, 10073036612751086588n, 11417981541647679048n, 8601490892183123069n, 14272476927059598810n, 10751863615228903837n, 17840596158824498513n, 4216457482181353988n, 11150372599265311570n, 14164500972431816002n, 13937965749081639463n, 8482254178684994195n, 17422457186352049329n, 5991131704928854840n, 10889035741470030830n, 15273672361649004035n, 13611294676837538538n, 9868718415206479236n, 17014118346046923173n, 3112525982153323237n, 10633823966279326983n, 4251171748059520975n, 13292279957849158729n, 702278666647013314n, 16615349947311448411n, 5489534351736154547n, 10384593717069655257n, 1125115960621402640n, 12980742146337069071n, 6018080969204141204n, 16225927682921336339n, 2910915193077788601n, 10141204801825835211n, 17960223060169475539n, 12676506002282294014n, 17838592806784456520n, 15845632502852867518n, 13074868971625794843n, 9903520314283042199n, 3560107088838733872n, 12379400392853802748n, 18285191916330581053n, 15474250491067253436n, 4409745821703674700n, 9671406556917033397n, 11979463175419572495n, 12089258196146291747n, 1139270913992301907n, 15111572745182864683n, 15259146697772541096n, 9444732965739290427n, 7231123676894144233n, 11805916207174113034n, 4427218577690292387n, 14757395258967641292n, 14757395258967641292n, 9223372036854775808n, 0n, 11529215046068469760n, 0n, 14411518807585587200n, 0n, 18014398509481984000n, 0n, 11258999068426240000n, 0n, 14073748835532800000n, 0n, 17592186044416000000n, 0n, 10995116277760000000n, 0n, 13743895347200000000n, 0n, 17179869184000000000n, 0n, 10737418240000000000n, 0n, 13421772800000000000n, 0n, 16777216000000000000n, 0n, 10485760000000000000n, 0n, 13107200000000000000n, 0n, 16384000000000000000n, 0n, 10240000000000000000n, 0n, 12800000000000000000n, 0n, 16000000000000000000n, 0n, 10000000000000000000n, 0n, 12500000000000000000n, 0n, 15625000000000000000n, 0n, 9765625000000000000n, 0n, 12207031250000000000n, 0n, 15258789062500000000n, 0n, 9536743164062500000n, 0n, 11920928955078125000n, 0n, 14901161193847656250n, 0n, 9313225746154785156n, 4611686018427387904n, 11641532182693481445n, 5764607523034234880n, 14551915228366851806n, 11817445422220181504n, 18189894035458564758n, 5548434740920451072n, 11368683772161602973n, 17302829768357445632n, 14210854715202003717n, 7793479155164643328n, 17763568394002504646n, 14353534962383192064n, 11102230246251565404n, 4359273333062107136n, 13877787807814456755n, 5449091666327633920n, 17347234759768070944n, 2199678564482154496n, 10842021724855044340n, 1374799102801346560n, 13552527156068805425n, 1718498878501683200n, 16940658945086006781n, 6759809616554491904n, 10587911840678754238n, 6530724019560251392n, 13234889800848442797n, 17386777061305090048n, 16543612251060553497n, 7898413271349198848n, 10339757656912845935n, 16465723340661719040n, 12924697071141057419n, 15970468157399760896n, 16155871338926321774n, 15351399178322313216n, 10097419586828951109n, 4982938468024057856n, 12621774483536188886n, 10840359103457460224n, 15777218104420236108n, 4327076842467049472n, 9860761315262647567n, 11927795063396681728n, 12325951644078309459n, 10298057810818464256n, 15407439555097886824n, 8260886245095692416n, 9629649721936179265n, 5163053903184807760n, 12037062152420224081n, 11065503397408397604n, 15046327690525280101n, 18443565265187884909n, 9403954806578300063n, 13833071299956122020n, 11754943508222875079n, 12679653106517764621n, 14693679385278593849n, 11237880364719817872n, 18367099231598242312n, 212292400617608628n, 11479437019748901445n, 132682750386005392n, 14349296274686126806n, 4777539456409894645n, 17936620343357658507n, 15195296357367144114n, 11210387714598536567n, 7191217214140771119n, 14012984643248170709n, 4377335499248575995n, 17516230804060213386n, 10083355392488107898n, 10947644252537633366n, 10913783138732455340n, 13684555315672041708n, 4418856886560793367n, 17105694144590052135n, 5523571108200991709n, 10691058840368782584n, 10369760970266701674n, 13363823550460978230n, 12962201212833377092n, 16704779438076222788n, 6979379479186945558n, 10440487148797639242n, 13585484211346616781n, 13050608935997049053n, 7758483227328495169n, 16313261169996311316n, 14309790052588006865n, 10195788231247694572n, 18166990819722280098n, 12744735289059618216n, 4261994450943298507n, 15930919111324522770n, 5327493063679123134n, 9956824444577826731n, 7941369183226839863n, 12446030555722283414n, 5315025460606161924n, 15557538194652854267n, 15867153862612478214n, 9723461371658033917n, 7611128154919104931n, 12154326714572542396n, 14125596212076269068n, 15192908393215677995n, 17656995265095336336n, 9495567745759798747n, 8729779031470891258n, 11869459682199748434n, 6300537770911226168n, 14836824602749685542n, 17099044250493808518n, 9273015376718553464n, 6075216638131242420n, 11591269220898191830n, 7594020797664053025n, 14489086526122739788n, 269153960225290473n, 18111358157653424735n, 336442450281613091n, 11319598848533390459n, 7127805559067090038n, 14149498560666738074n, 4298070930406474644n, 17686873200833422592n, 14595960699862869113n, 11054295750520889120n, 9122475437414293195n, 13817869688151111400n, 11403094296767866494n, 17272337110188889250n, 14253867870959833118n, 10795210693868055781n, 13520353437777283602n, 13494013367335069727n, 3065383741939440791n, 16867516709168837158n, 17666787732706464701n, 10542197943230523224n, 6430056314514152534n, 13177747429038154030n, 8037570393142690668n, 16472184286297692538n, 823590954573587527n, 10295115178936057836n, 5126430365035880108n, 12868893973670072295n, 6408037956294850135n, 16086117467087590369n, 3398361426941174765n, 10053823416929743980n, 13653190937906703988n, 12567279271162179975n, 17066488672383379985n, 15709099088952724969n, 16721424822051837077n, 9818186930595453106n, 3533361486141316317n, 12272733663244316382n, 13640073894531421205n, 15340917079055395478n, 7826720331309500698n, 9588073174409622174n, 280014188641050032n, 11985091468012027717n, 9573389772656088348n, 14981364335015034646n, 16578423234247498339n, 9363352709384396654n, 5749828502977298558n, 11704190886730495817n, 16410657665576399005n, 14630238608413119772n, 6678264026688335045n, 18287798260516399715n, 8347830033360418806n, 11429873912822749822n, 2911550761636567802n, 14287342391028437277n, 12862810488900485560n, 17859177988785546597n, 2243455055843443238n, 11161986242990966623n, 3708002419115845976n, 13952482803738708279n, 23317005467419566n, 17440603504673385348n, 13864204312116438170n, 10900377190420865842n, 17888499731927549664n, 13625471488026082303n, 13137252628054661272n, 17031839360032602879n, 11809879766640938686n, 10644899600020376799n, 14298703881791668535n, 13306124500025470999n, 13261693833812197764n, 16632655625031838749n, 11965431273837859301n, 10395409765644899218n, 9784237555362356015n, 12994262207056124023n, 3006924907348169211n, 16242827758820155028n, 17593714189467375226n, 10151767349262596893n, 1772699331562333708n, 12689709186578246116n, 6827560182880305039n, 15862136483222807645n, 8534450228600381299n, 9913835302014254778n, 7639874402088932264n, 12392294127517818473n, 326470965756389522n, 15490367659397273091n, 5019774725622874806n, 9681479787123295682n, 831516194300602802n, 12101849733904119602n, 10262767279730529310n, 15127312167380149503n, 3605087062808385830n, 9454570104612593439n, 9170708441896323000n, 11818212630765741799n, 6851699533943015846n, 14772765788457177249n, 3952938399001381903n, 9232978617785735780n, 13999801545444333449n, 11541223272232169725n, 17499751931805416812n, 14426529090290212157n, 8039631859474607303n, 18033161362862765196n, 14661225842770647033n, 11270725851789228247n, 18386638188586430203n, 14088407314736535309n, 18371611717305649850n, 17610509143420669137n, 9129456591349898601n, 11006568214637918210n, 17235125415662156385n, 13758210268297397763n, 12320534732722919674n, 17197762835371747204n, 10788982397476261688n, 10748601772107342002n, 15966486035277439363n, 13435752215134177503n, 10734735507242023396n, 16794690268917721879n, 8806733365625141341n, 10496681418073576174n, 12421737381156795194n, 13120851772591970218n, 6303799689591218185n, 16401064715739962772n, 17103121648843798539n, 10250665447337476733n, 1466078993672598279n, 12813331809171845916n, 6444284760518135752n, 16016664761464807395n, 8055355950647669691n, 10010415475915504622n, 2728754459941099604n, 12513019344894380777n, 12634315111781150314n, 15641274181117975972n, 1957835834444274180n, 9775796363198734982n, 10447019433382447170n, 12219745453998418728n, 3835402254873283155n, 15274681817498023410n, 4794252818591603944n, 9546676135936264631n, 7608094030047140369n, 11933345169920330789n, 4898431519131537557n, 14916681462400413486n, 10734725417341809851n, 9322925914000258429n, 2097517367411243253n, 11653657392500323036n, 7233582727691441970n, 14567071740625403795n, 9041978409614302462n, 18208839675781754744n, 6690786993590490174n, 11380524797363596715n, 4181741870994056359n, 14225655996704495894n, 615491320315182544n, 17782069995880619867n, 9992736187248753989n, 11113793747425387417n, 3939617107816777291n, 13892242184281734271n, 9536207403198359517n, 17365302730352167839n, 7308573235570561493n, 10853314206470104899n, 11485387299872682789n, 13566642758087631124n, 9745048106413465582n, 16958303447609538905n, 12181310133016831978n, 10598939654755961816n, 695789805494438130n, 13248674568444952270n, 869737256868047663n, 16560843210556190337n, 10310543607939835386n, 10350527006597618960n, 17973304801030866876n, 12938158758247023701n, 4019886927579031980n, 16172698447808779626n, 9636544677901177879n, 10107936529880487266n, 10634526442115624078n, 12634920662350609083n, 4069786015789754290n, 15793650827938261354n, 475546501309804958n, 9871031767461413346n, 4908902581746016003n, 12338789709326766682n, 15359500264037295811n, 15423487136658458353n, 9976003293191843956n, 9639679460411536470n, 17764217104313372233n, 12049599325514420588n, 12981899343536939483n, 15061999156893025735n, 16227374179421174354n, 9413749473058141084n, 17059637889779315827n, 11767186841322676356n, 2877803288514593168n, 14708983551653345445n, 3597254110643241460n, 18386229439566681806n, 9108253656731439729n, 11491393399729176129n, 1080972517029761926n, 14364241749661470161n, 5962901664714590312n, 17955302187076837701n, 12065313099320625794n, 11222063866923023563n, 9846663696289085073n, 14027579833653779454n, 7696643601933968437n, 17534474792067224318n, 397432465562684739n, 10959046745042015198n, 14083453346258841674n, 13698808431302518998n, 8380944645968776284n, 17123510539128148748n, 1252808770606194547n, 10702194086955092967n, 10006377518483647400n, 13377742608693866209n, 7896285879677171346n, 16722178260867332761n, 14482043368023852087n, 10451361413042082976n, 2133748077373825698n, 13064201766302603720n, 2667185096717282123n, 16330252207878254650n, 3333981370896602653n, 10206407629923909156n, 6695424375237764562n, 12758009537404886445n, 8369280469047205703n, 15947511921756108056n, 15073286604736395033n, 9967194951097567535n, 9420804127960246895n, 12458993688871959419n, 7164319141522920715n, 15573742111089949274n, 4343712908476262990n, 9733588819431218296n, 7326506586225052273n, 12166986024289022870n, 9158133232781315341n, 15208732530361278588n, 2224294504121868368n, 9505457831475799117n, 10613556101930943538n, 11881822289344748896n, 17878631145841067327n, 14852277861680936121n, 3901544858591782542n, 9282673663550585075n, 13967680582688333849n, 11603342079438231344n, 12847914709933029407n, 14504177599297789180n, 16059893387416286759n, 18130221999122236476n, 1628122660560806833n, 11331388749451397797n, 10240948699705280078n, 14164235936814247246n, 17412871893058988002n, 17705294921017809058n, 12542717829468959195n, 11065809325636130661n, 12450884661845487401n, 13832261657045163327n, 1728547772024695539n, 17290327071306454158n, 15995742770313033136n, 10806454419566533849n, 5385653213018257806n, 13508068024458167311n, 11343752534700210161n, 16885085030572709139n, 9568004649947874797n, 10553178144107943212n, 3674159897003727796n, 13191472680134929015n, 4592699871254659745n, 16489340850168661269n, 1129188820640936778n, 10305838031355413293n, 3011586022114279438n, 12882297539194266616n, 8376168546070237202n, 16102871923992833270n, 10470210682587796502n, 10064294952495520794n, 1932195658189984910n, 12580368690619400992n, 11638616609592256945n, 15725460863274251240n, 14548270761990321182n, 9828413039546407025n, 9092669226243950738n, 12285516299433008781n, 15977522551232326327n, 15356895374291260977n, 6136845133758244197n, 9598059608932038110n, 15364743254667372383n, 11997574511165047638n, 9982557031479439671n, 14996968138956309548n, 3254824252494523781n, 9373105086847693467n, 11257637194663853171n, 11716381358559616834n, 9460360474902428559n, 14645476698199521043n, 2602078556773259891n, 18306845872749401303n, 17087656251248738576n, 11441778670468375814n, 17597314184671543466n, 14302223338085469768n, 12773270693984653525n, 17877779172606837210n, 15966588367480816906n, 11173611982879273256n, 14590803748102898470n, 13967014978599091570n, 18238504685128623088n, 17458768723248864463n, 13574758819556003052n, 10911730452030540289n, 15401753289863583763n, 13639663065038175362n, 5417133557047315992n, 17049578831297719202n, 15994788983163920798n, 10655986769561074501n, 14608429132904838403n, 13319983461951343127n, 4425478360848884291n, 16649979327439178909n, 920161932633717460n, 10406237079649486818n, 2880944217109767365n, 13007796349561858522n, 12824552308241985014n, 16259745436952323153n, 6807318348447705459n, 10162340898095201970n, 15783789013848285672n, 12702926122619002463n, 10506364230455581282n, 15878657653273753079n, 8521269269642088699n, 9924161033296095674n, 12243322321167387293n, 12405201291620119593n, 6080780864604458308n, 15506501614525149491n, 12212662099182960789n, 9691563509078218432n, 5327070802775656541n, 12114454386347773040n, 6658838503469570676n, 15143067982934716300n, 8323548129336963345n, 9464417489334197687n, 14425589617690377899n, 11830521861667747109n, 13420301003685584469n, 14788152327084683887n, 2940318199324816875n, 9242595204427927429n, 8755227902219092403n, 11553244005534909286n, 15555720896201253407n, 14441555006918636608n, 10221279083396790951n, 18051943758648295760n, 12776598854245988689n, 11282464849155184850n, 7985374283903742931n, 14103081061443981063n, 758345818024902856n, 17628851326804976328n, 14782990327813292282n, 11018032079253110205n, 9239368954883307676n, 13772540099066387756n, 16160897212031522499n, 17215675123832984696n, 1754377441329851508n, 10759796952395615435n, 1096485900831157192n, 13449746190494519293n, 15205665431321110202n, 16812182738118149117n, 5172023733869224041n, 10507614211323843198n, 5538357842881958977n, 13134517764154803997n, 16146319340457224530n, 16418147205193504997n, 6347841120289366950n, 10261342003245940623n, 6273243709394548296n, 12826677504057425779n, 3229868618315797466n, 16033346880071782223n, 17872393828176910545n, 10020841800044863889n, 18087775170251650946n, 12526052250056079862n, 8774660907532399971n, 15657565312570099828n, 1744954097560724156n, 9785978320356312392n, 10313968347830228405n, 12232472900445390490n, 12892460434787785506n, 15290591125556738113n, 6892203506629956075n, 9556619453472961320n, 15836842237712192307n, 11945774316841201651n, 1349308723430688768n, 14932217896051502063n, 15521693959570524672n, 9332636185032188789n, 16618587752372659776n, 11665795231290235987n, 6938176635183661008n, 14582244039112794984n, 4061034775552188356n, 18227805048890993730n, 5076293469440235445n, 11392378155556871081n, 7784369436827535057n, 14240472694446088851n, 14342147814461806725n, 17800590868057611064n, 13315998749649870503n, 11125369292536006915n, 8322499218531169064n, 13906711615670008644n, 5791438004736573426n, 17383389519587510805n, 7239297505920716783n, 10864618449742194253n, 6830403950414141941n, 13580773062177742816n, 13149690956445065330n, 16975966327722178520n, 16437113695556331663n, 10609978954826361575n, 10273196059722707289n, 13262473693532951969n, 8229809056225996208n, 16578092116916189961n, 14898947338709883164n, 10361307573072618726n, 2394313059052595121n, 12951634466340773407n, 12216263360670519709n, 16189543082925966759n, 10658643182410761733n, 10118464426828729224n, 13579181016647807939n, 12648080533535911530n, 16973976270809759924n, 15810100666919889413n, 11994098301657424097n, 9881312916824930883n, 9802154447749584012n, 12351641146031163604n, 7641007041259592112n, 15439551432538954505n, 9551258801574490140n, 9649719645336846565n, 17498751797052526097n, 12062149556671058207n, 8038381691033493909n, 15077686945838822759n, 5436291095364479483n];
const _M0FPC28internal7strconv12double__info = new _M0TPC28internal7strconv9FloatInfo(52, 11, -1023);
const _M0FPC28internal7strconv25min__exponent__fast__path = 18446744073709551594n;
const _M0FPC28internal7strconv25max__exponent__fast__path = 22n;
const _M0FPC28internal7strconv36max__exponent__disguised__fast__path = 37n;
const _M0FPC28internal7strconv25max__mantissa__fast__path = 9007199254740992n;
const _M0FPC28internal7strconv6powtab = [1, 3, 6, 9, 13, 16, 19, 23, 26, 29, 33, 36, 39, 43, 46, 49, 53, 56, 59];
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2446 = { _0: 0, _1: "" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2447 = { _0: 1, _1: "5" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2448 = { _0: 1, _1: "25" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2449 = { _0: 1, _1: "125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2450 = { _0: 2, _1: "625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2451 = { _0: 2, _1: "3125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2452 = { _0: 2, _1: "15625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2453 = { _0: 3, _1: "78125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2454 = { _0: 3, _1: "390625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2455 = { _0: 3, _1: "1953125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2456 = { _0: 4, _1: "9765625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2457 = { _0: 4, _1: "48828125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2458 = { _0: 4, _1: "244140625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2459 = { _0: 4, _1: "1220703125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2460 = { _0: 5, _1: "6103515625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2461 = { _0: 5, _1: "30517578125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2462 = { _0: 5, _1: "152587890625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2463 = { _0: 6, _1: "762939453125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2464 = { _0: 6, _1: "3814697265625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2465 = { _0: 6, _1: "19073486328125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2466 = { _0: 7, _1: "95367431640625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2467 = { _0: 7, _1: "476837158203125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2468 = { _0: 7, _1: "2384185791015625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2469 = { _0: 7, _1: "11920928955078125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2470 = { _0: 8, _1: "59604644775390625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2471 = { _0: 8, _1: "298023223876953125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2472 = { _0: 8, _1: "1490116119384765625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2473 = { _0: 9, _1: "7450580596923828125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2474 = { _0: 9, _1: "37252902984619140625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2475 = { _0: 9, _1: "186264514923095703125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2476 = { _0: 10, _1: "931322574615478515625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2477 = { _0: 10, _1: "4656612873077392578125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2478 = { _0: 10, _1: "23283064365386962890625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2479 = { _0: 10, _1: "116415321826934814453125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2480 = { _0: 11, _1: "582076609134674072265625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2481 = { _0: 11, _1: "2910383045673370361328125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2482 = { _0: 11, _1: "14551915228366851806640625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2483 = { _0: 12, _1: "72759576141834259033203125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2484 = { _0: 12, _1: "363797880709171295166015625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2485 = { _0: 12, _1: "1818989403545856475830078125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2486 = { _0: 13, _1: "9094947017729282379150390625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2487 = { _0: 13, _1: "45474735088646411895751953125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2488 = { _0: 13, _1: "227373675443232059478759765625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2489 = { _0: 13, _1: "1136868377216160297393798828125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2490 = { _0: 14, _1: "5684341886080801486968994140625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2491 = { _0: 14, _1: "28421709430404007434844970703125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2492 = { _0: 14, _1: "142108547152020037174224853515625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2493 = { _0: 15, _1: "710542735760100185871124267578125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2494 = { _0: 15, _1: "3552713678800500929355621337890625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2495 = { _0: 15, _1: "17763568394002504646778106689453125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2496 = { _0: 16, _1: "88817841970012523233890533447265625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2497 = { _0: 16, _1: "444089209850062616169452667236328125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2498 = { _0: 16, _1: "2220446049250313080847263336181640625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2499 = { _0: 16, _1: "11102230246251565404236316680908203125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2500 = { _0: 17, _1: "55511151231257827021181583404541015625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2501 = { _0: 17, _1: "277555756156289135105907917022705078125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2502 = { _0: 17, _1: "1387778780781445675529539585113525390625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2503 = { _0: 18, _1: "6938893903907228377647697925567626953125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2504 = { _0: 18, _1: "34694469519536141888238489627838134765625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2505 = { _0: 18, _1: "173472347597680709441192448139190673828125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2506 = { _0: 19, _1: "867361737988403547205962240695953369140625" };
const _M0FPC28internal7strconv19left__shift__cheats = [_M0FPC28internal7strconv19left__shift__cheatsN5tupleS2446, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2447, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2448, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2449, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2450, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2451, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2452, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2453, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2454, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2455, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2456, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2457, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2458, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2459, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2460, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2461, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2462, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2463, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2464, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2465, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2466, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2467, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2468, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2469, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2470, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2471, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2472, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2473, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2474, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2475, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2476, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2477, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2478, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2479, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2480, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2481, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2482, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2483, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2484, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2485, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2486, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2487, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2488, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2489, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2490, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2491, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2492, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2493, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2494, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2495, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2496, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2497, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2498, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2499, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2500, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2501, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2502, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2503, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2504, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2505, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2506];
const _M0FPC28internal7strconv10int__pow10 = [1n, 10n, 100n, 1000n, 10000n, 100000n, 1000000n, 10000000n, 100000000n, 1000000000n, 10000000000n, 100000000000n, 1000000000000n, 10000000000000n, 100000000000000n, 1000000000000000n];
const _M0FPC28internal7strconv5table = [1, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000, 10000000000, 100000000000, 1e+012, 1e+013, 1e+014, 1e+015, 1e+016, 1e+017, 1e+018, 1e+019, 1e+020, 1e+021, 1e+022, 0, 0, 0, 0, 0, 0, 0, 0, 0];
const _M0FPC28internal7strconv12checked__mulN6constrS2672 = 0n;
const _M0FP212moonbitstack8moonjson6strict = new _M0TP212moonbitstack8moonjson6Flavor(false, false, false, false, false, false, false, 500, false, 0);
const _M0FP312moonbitstack8moonseed6system6source = undefined;
const _M0FP312moonbitstack7moonstl4spec11seed__state = new _M0TP312moonbitstack7moonstl4spec9SeedState(undefined, false);
const _M0FP312moonbitstack7moonstl3phf12phf__options = new _M0TP312moonbitstack7moonstl3phf10PhfOptions(0, 0);
const _M0FP312moonbitstack7moonstl3phf17rank__from__ownerN3bitS3584 = 1n;
const _M0FP312moonbitstack7moonstl3phf13build__paramsN6recordS3653 = new _M0TP312moonbitstack7moonstl3phf11BuildParams(4, 10, 9, 65536);
const _M0FP312moonbitstack7moonstl3phf13build__paramsN6recordS3654 = new _M0TP312moonbitstack7moonstl3phf11BuildParams(4, 2, 1, 8);
const _M0FP312moonbitstack7moonstl3phf13build__paramsN6recordS3655 = new _M0TP312moonbitstack7moonstl3phf11BuildParams(8, 16, 15, 65536);
const _M0FP312moonbitstack7moonstl3seq9bit__maskN3oneS3810 = 1n;
const _M0FP312moonbitstack7moonstl6sketch14bloom__options = new _M0TP312moonbitstack7moonstl6sketch12BloomOptions(0.01, 0);
const _M0FPB4seed = _M0FPB12random__seed();
const _M0FPC28internal7strconv17parse__scientificN8exp__numS2544 = 0n;
const _M0FP212moonbitstack8moonjson11hex__escapeN6digitsS2928 = "0123456789abcdef";
const _M0FPC13env4randN6constrS3126 = $bytes_literal$0;
const _M0FP312moonbitstack7moonstl4spec10hash__seedN6constrS3149 = 0;
const _M0FP223moonstl_2dsite_2dbridge4main5bloomN6constrS4442 = 0;
function _M0MPB6Logger13write__objectGsE(self, obj) {
  _M0IP016_24default__implPB4Show6outputGsE(obj, self);
}
function _M0IPB7FailurePB4Show6output(_x_5867, _x_5868) {
  const _Failure = _x_5867;
  const _$42$arg_5869 = _Failure._0;
  _x_5868.method_table.method_0(_x_5868.self, "Failure(");
  _M0MPB6Logger13write__objectGsE(_x_5868, _$42$arg_5869);
  _x_5868.method_table.method_0(_x_5868.self, ")");
}
function _M0MPC16uint646UInt6418to__string_2einner(self, radix) {
  return _M0FPB22uint64__to__string__js(self, radix);
}
function _M0MPC16string10StringView12unsafe__view(self, start, end) {
  return new _M0TPC16string10StringView(self.str, self.start + start | 0, self.start + end | 0);
}
function _M0FPB13consume4__acc(acc, input) {
  const _p = (acc >>> 0) + ((Math.imul(input, -1028477379) | 0) >>> 0) | 0;
  return Math.imul(_p << 17 | (_p >>> 15 | 0), 668265263) | 0;
}
function _M0MPB6Hasher8consume4(self, input) {
  self.acc = _M0FPB13consume4__acc(self.acc, input);
}
function _M0MPB6Hasher13combine__uint(self, value) {
  self.acc = (self.acc >>> 0) + (4 >>> 0) | 0;
  _M0MPB6Hasher8consume4(self, value);
}
function _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGUiiiiEEE(dst, dst_offset, src, src_offset, len) {
  if (dst === src && dst_offset < src_offset) {
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < len) {
        const _tmp$2 = dst_offset + i | 0;
        const _tmp$3 = src_offset + i | 0;
        if (_tmp$2 >>> 0 < dst.length) {
          dst[_tmp$2] = _tmp$3 >>> 0 < src.length ? src[_tmp$3] : $oob();
        } else {
          $oob();
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  } else {
    let _tmp = len - 1 | 0;
    let _tmp$2 = len > 0;
    while (true) {
      const i = _tmp;
      const _more = _tmp$2;
      if (_more) {
        const _tmp$3 = dst_offset + i | 0;
        const _tmp$4 = src_offset + i | 0;
        if (_tmp$3 >>> 0 < dst.length) {
          dst[_tmp$3] = _tmp$4 >>> 0 < src.length ? src[_tmp$4] : $oob();
        } else {
          $oob();
        }
        _tmp = i - 1 | 0;
        _tmp$2 = i > 0;
        continue;
      } else {
        return;
      }
    }
  }
}
function _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGcEE(dst, dst_offset, src, src_offset, len) {
  if (dst === src && dst_offset < src_offset) {
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < len) {
        const _tmp$2 = dst_offset + i | 0;
        const _tmp$3 = src_offset + i | 0;
        if (_tmp$2 >>> 0 < dst.length) {
          dst[_tmp$2] = _tmp$3 >>> 0 < src.length ? src[_tmp$3] : $oob();
        } else {
          $oob();
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  } else {
    let _tmp = len - 1 | 0;
    let _tmp$2 = len > 0;
    while (true) {
      const i = _tmp;
      const _more = _tmp$2;
      if (_more) {
        const _tmp$3 = dst_offset + i | 0;
        const _tmp$4 = src_offset + i | 0;
        if (_tmp$3 >>> 0 < dst.length) {
          dst[_tmp$3] = _tmp$4 >>> 0 < src.length ? src[_tmp$4] : $oob();
        } else {
          $oob();
        }
        _tmp = i - 1 | 0;
        _tmp$2 = i > 0;
        continue;
      } else {
        return;
      }
    }
  }
}
function _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGORP312moonbitstack7moonstl5cache7LruNodeGiiEEE(dst, dst_offset, src, src_offset, len) {
  if (dst === src && dst_offset < src_offset) {
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < len) {
        const _tmp$2 = dst_offset + i | 0;
        const _tmp$3 = src_offset + i | 0;
        if (_tmp$2 >>> 0 < dst.length) {
          dst[_tmp$2] = _tmp$3 >>> 0 < src.length ? src[_tmp$3] : $oob();
        } else {
          $oob();
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  } else {
    let _tmp = len - 1 | 0;
    let _tmp$2 = len > 0;
    while (true) {
      const i = _tmp;
      const _more = _tmp$2;
      if (_more) {
        const _tmp$3 = dst_offset + i | 0;
        const _tmp$4 = src_offset + i | 0;
        if (_tmp$3 >>> 0 < dst.length) {
          dst[_tmp$3] = _tmp$4 >>> 0 < src.length ? src[_tmp$4] : $oob();
        } else {
          $oob();
        }
        _tmp = i - 1 | 0;
        _tmp$2 = i > 0;
        continue;
      } else {
        return;
      }
    }
  }
}
function _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGiEE(dst, dst_offset, src, src_offset, len) {
  if (dst === src && dst_offset < src_offset) {
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < len) {
        const _tmp$2 = dst_offset + i | 0;
        const _tmp$3 = src_offset + i | 0;
        if (_tmp$2 >>> 0 < dst.length) {
          dst[_tmp$2] = _tmp$3 >>> 0 < src.length ? src[_tmp$3] : $oob();
        } else {
          $oob();
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  } else {
    let _tmp = len - 1 | 0;
    let _tmp$2 = len > 0;
    while (true) {
      const i = _tmp;
      const _more = _tmp$2;
      if (_more) {
        const _tmp$3 = dst_offset + i | 0;
        const _tmp$4 = src_offset + i | 0;
        if (_tmp$3 >>> 0 < dst.length) {
          dst[_tmp$3] = _tmp$4 >>> 0 < src.length ? src[_tmp$4] : $oob();
        } else {
          $oob();
        }
        _tmp = i - 1 | 0;
        _tmp$2 = i > 0;
        continue;
      } else {
        return;
      }
    }
  }
}
function _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGbEE(dst, dst_offset, src, src_offset, len) {
  if (dst === src && dst_offset < src_offset) {
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < len) {
        const _tmp$2 = dst_offset + i | 0;
        const _tmp$3 = src_offset + i | 0;
        if (_tmp$2 >>> 0 < dst.length) {
          dst[_tmp$2] = _tmp$3 >>> 0 < src.length ? src[_tmp$3] : $oob();
        } else {
          $oob();
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  } else {
    let _tmp = len - 1 | 0;
    let _tmp$2 = len > 0;
    while (true) {
      const i = _tmp;
      const _more = _tmp$2;
      if (_more) {
        const _tmp$3 = dst_offset + i | 0;
        const _tmp$4 = src_offset + i | 0;
        if (_tmp$3 >>> 0 < dst.length) {
          dst[_tmp$3] = _tmp$4 >>> 0 < src.length ? src[_tmp$4] : $oob();
        } else {
          $oob();
        }
        _tmp = i - 1 | 0;
        _tmp$2 = i > 0;
        continue;
      } else {
        return;
      }
    }
  }
}
function _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGOiEE(dst, dst_offset, src, src_offset, len) {
  if (dst === src && dst_offset < src_offset) {
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < len) {
        const _tmp$2 = dst_offset + i | 0;
        const _tmp$3 = src_offset + i | 0;
        if (_tmp$2 >>> 0 < dst.length) {
          dst[_tmp$2] = _tmp$3 >>> 0 < src.length ? src[_tmp$3] : $oob();
        } else {
          $oob();
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  } else {
    let _tmp = len - 1 | 0;
    let _tmp$2 = len > 0;
    while (true) {
      const i = _tmp;
      const _more = _tmp$2;
      if (_more) {
        const _tmp$3 = dst_offset + i | 0;
        const _tmp$4 = src_offset + i | 0;
        if (_tmp$3 >>> 0 < dst.length) {
          dst[_tmp$3] = _tmp$4 >>> 0 < src.length ? src[_tmp$4] : $oob();
        } else {
          $oob();
        }
        _tmp = i - 1 | 0;
        _tmp$2 = i > 0;
        continue;
      } else {
        return;
      }
    }
  }
}
function _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGyEE(dst, dst_offset, src, src_offset, len) {
  if (dst === src && dst_offset < src_offset) {
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < len) {
        const _tmp$2 = dst_offset + i | 0;
        const _tmp$3 = src_offset + i | 0;
        if (_tmp$2 >>> 0 < dst.length) {
          dst[_tmp$2] = _tmp$3 >>> 0 < src.length ? src[_tmp$3] : $oob();
        } else {
          $oob();
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  } else {
    let _tmp = len - 1 | 0;
    let _tmp$2 = len > 0;
    while (true) {
      const i = _tmp;
      const _more = _tmp$2;
      if (_more) {
        const _tmp$3 = dst_offset + i | 0;
        const _tmp$4 = src_offset + i | 0;
        if (_tmp$3 >>> 0 < dst.length) {
          dst[_tmp$3] = _tmp$4 >>> 0 < src.length ? src[_tmp$4] : $oob();
        } else {
          $oob();
        }
        _tmp = i - 1 | 0;
        _tmp$2 = i > 0;
        continue;
      } else {
        return;
      }
    }
  }
}
function _M0MPB18UninitializedArray12unsafe__blitGyE(dst, dst_offset, src, src_offset, len) {
  _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGyEE(dst, dst_offset, src, src_offset, len);
}
function _M0MPB18UninitializedArray12unsafe__blitGRP312moonbitstack7moonstl4text6OpcodeE(dst, dst_offset, src, src_offset, len) {
  _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGUiiiiEEE(dst, dst_offset, src, src_offset, len);
}
function _M0MPB18UninitializedArray12unsafe__blitGOiE(dst, dst_offset, src, src_offset, len) {
  _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGOiEE(dst, dst_offset, src, src_offset, len);
}
function _M0MPB18UninitializedArray12unsafe__blitGcE(dst, dst_offset, src, src_offset, len) {
  _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGcEE(dst, dst_offset, src, src_offset, len);
}
function _M0MPB18UninitializedArray12unsafe__blitGiE(dst, dst_offset, src, src_offset, len) {
  _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGiEE(dst, dst_offset, src, src_offset, len);
}
function _M0MPB18UninitializedArray12unsafe__blitGbE(dst, dst_offset, src, src_offset, len) {
  _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGbEE(dst, dst_offset, src, src_offset, len);
}
function _M0MPB18UninitializedArray12unsafe__blitGORP312moonbitstack7moonstl5cache7LruNodeGiiEE(dst, dst_offset, src, src_offset, len) {
  _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGORP312moonbitstack7moonstl5cache7LruNodeGiiEEE(dst, dst_offset, src, src_offset, len);
}
function _M0MPB18UninitializedArray23unsafe__make__and__blitGyE(src, allocate_len, src_offset, dst_offset, blit_len) {
  const dst = new Uint8Array(allocate_len);
  _M0MPB18UninitializedArray12unsafe__blitGyE(dst, dst_offset, src, src_offset, blit_len);
  return dst;
}
function _M0MPB18UninitializedArray23unsafe__make__and__blitGRP312moonbitstack7moonstl4text6OpcodeE(src, allocate_len, src_offset, dst_offset, blit_len) {
  const dst = new Array(allocate_len);
  _M0MPB18UninitializedArray12unsafe__blitGRP312moonbitstack7moonstl4text6OpcodeE(dst, dst_offset, src, src_offset, blit_len);
  return dst;
}
function _M0MPB18UninitializedArray23unsafe__make__and__blitGOiE(src, allocate_len, src_offset, dst_offset, blit_len) {
  const dst = new Array(allocate_len);
  _M0MPB18UninitializedArray12unsafe__blitGOiE(dst, dst_offset, src, src_offset, blit_len);
  return dst;
}
function _M0MPB18UninitializedArray23unsafe__make__and__blitGcE(src, allocate_len, src_offset, dst_offset, blit_len) {
  const dst = new Array(allocate_len);
  _M0MPB18UninitializedArray12unsafe__blitGcE(dst, dst_offset, src, src_offset, blit_len);
  return dst;
}
function _M0MPB18UninitializedArray23unsafe__make__and__blitGiE(src, allocate_len, src_offset, dst_offset, blit_len) {
  const dst = new Array(allocate_len);
  _M0MPB18UninitializedArray12unsafe__blitGiE(dst, dst_offset, src, src_offset, blit_len);
  return dst;
}
function _M0MPB18UninitializedArray23unsafe__make__and__blitGbE(src, allocate_len, src_offset, dst_offset, blit_len) {
  const dst = new Array(allocate_len);
  _M0MPB18UninitializedArray12unsafe__blitGbE(dst, dst_offset, src, src_offset, blit_len);
  return dst;
}
function _M0MPB18UninitializedArray23unsafe__make__and__blitGORP312moonbitstack7moonstl5cache7LruNodeGiiEE(src, allocate_len, src_offset, dst_offset, blit_len) {
  const dst = new Array(allocate_len);
  _M0MPB18UninitializedArray12unsafe__blitGORP312moonbitstack7moonstl5cache7LruNodeGiiEE(dst, dst_offset, src, src_offset, blit_len);
  return dst;
}
function _M0MPB13StringBuilder13write__objectGiE(self, obj) {
  _M0IP016_24default__implPB4Show6outputGiE(obj, { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
}
function _M0MPB13StringBuilder13write__objectGmE(self, obj) {
  _M0IP016_24default__implPB4Show6outputGmE(obj, { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
}
function _M0MPB13StringBuilder13write__objectGdE(self, obj) {
  _M0IP016_24default__implPB4Show6outputGdE(obj, { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
}
function _M0MPB18UninitializedArray23make__and__blit_2einnerGRP312moonbitstack7moonstl4text6OpcodeE(src, allocate_len, len, src_offset, dst_offset) {
  let _tmp;
  if (allocate_len >= 0) {
    let _tmp$2;
    if (len >= 0) {
      let _tmp$3;
      const _p = src.length;
      if (src_offset >= 0 && src_offset <= (_p - len | 0)) {
        _tmp$3 = dst_offset >= 0 && dst_offset <= (allocate_len - len | 0);
      } else {
        _tmp$3 = false;
      }
      _tmp$2 = _tmp$3;
    } else {
      _tmp$2 = false;
    }
    _tmp = _tmp$2;
  } else {
    _tmp = false;
  }
  if (_tmp) {
    return _M0MPB18UninitializedArray23unsafe__make__and__blitGRP312moonbitstack7moonstl4text6OpcodeE(src, allocate_len, src_offset, dst_offset, len);
  } else {
    const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(89);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "bounds check failed: allocate_len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, allocate_len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, src_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", dst_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, dst_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src.length = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, src.length);
    return $panic(_string_builder.val);
  }
}
function _M0MPB18UninitializedArray23make__and__blit_2einnerGOiE(src, allocate_len, len, src_offset, dst_offset) {
  let _tmp;
  if (allocate_len >= 0) {
    let _tmp$2;
    if (len >= 0) {
      let _tmp$3;
      const _p = src.length;
      if (src_offset >= 0 && src_offset <= (_p - len | 0)) {
        _tmp$3 = dst_offset >= 0 && dst_offset <= (allocate_len - len | 0);
      } else {
        _tmp$3 = false;
      }
      _tmp$2 = _tmp$3;
    } else {
      _tmp$2 = false;
    }
    _tmp = _tmp$2;
  } else {
    _tmp = false;
  }
  if (_tmp) {
    return _M0MPB18UninitializedArray23unsafe__make__and__blitGOiE(src, allocate_len, src_offset, dst_offset, len);
  } else {
    const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(89);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "bounds check failed: allocate_len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, allocate_len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, src_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", dst_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, dst_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src.length = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, src.length);
    return $panic(_string_builder.val);
  }
}
function _M0MPB18UninitializedArray23make__and__blit_2einnerGcE(src, allocate_len, len, src_offset, dst_offset) {
  let _tmp;
  if (allocate_len >= 0) {
    let _tmp$2;
    if (len >= 0) {
      let _tmp$3;
      const _p = src.length;
      if (src_offset >= 0 && src_offset <= (_p - len | 0)) {
        _tmp$3 = dst_offset >= 0 && dst_offset <= (allocate_len - len | 0);
      } else {
        _tmp$3 = false;
      }
      _tmp$2 = _tmp$3;
    } else {
      _tmp$2 = false;
    }
    _tmp = _tmp$2;
  } else {
    _tmp = false;
  }
  if (_tmp) {
    return _M0MPB18UninitializedArray23unsafe__make__and__blitGcE(src, allocate_len, src_offset, dst_offset, len);
  } else {
    const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(89);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "bounds check failed: allocate_len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, allocate_len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, src_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", dst_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, dst_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src.length = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, src.length);
    return $panic(_string_builder.val);
  }
}
function _M0MPB18UninitializedArray23make__and__blit_2einnerGiE(src, allocate_len, len, src_offset, dst_offset) {
  let _tmp;
  if (allocate_len >= 0) {
    let _tmp$2;
    if (len >= 0) {
      let _tmp$3;
      const _p = src.length;
      if (src_offset >= 0 && src_offset <= (_p - len | 0)) {
        _tmp$3 = dst_offset >= 0 && dst_offset <= (allocate_len - len | 0);
      } else {
        _tmp$3 = false;
      }
      _tmp$2 = _tmp$3;
    } else {
      _tmp$2 = false;
    }
    _tmp = _tmp$2;
  } else {
    _tmp = false;
  }
  if (_tmp) {
    return _M0MPB18UninitializedArray23unsafe__make__and__blitGiE(src, allocate_len, src_offset, dst_offset, len);
  } else {
    const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(89);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "bounds check failed: allocate_len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, allocate_len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, src_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", dst_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, dst_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src.length = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, src.length);
    return $panic(_string_builder.val);
  }
}
function _M0MPB18UninitializedArray23make__and__blit_2einnerGbE(src, allocate_len, len, src_offset, dst_offset) {
  let _tmp;
  if (allocate_len >= 0) {
    let _tmp$2;
    if (len >= 0) {
      let _tmp$3;
      const _p = src.length;
      if (src_offset >= 0 && src_offset <= (_p - len | 0)) {
        _tmp$3 = dst_offset >= 0 && dst_offset <= (allocate_len - len | 0);
      } else {
        _tmp$3 = false;
      }
      _tmp$2 = _tmp$3;
    } else {
      _tmp$2 = false;
    }
    _tmp = _tmp$2;
  } else {
    _tmp = false;
  }
  if (_tmp) {
    return _M0MPB18UninitializedArray23unsafe__make__and__blitGbE(src, allocate_len, src_offset, dst_offset, len);
  } else {
    const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(89);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "bounds check failed: allocate_len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, allocate_len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, src_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", dst_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, dst_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src.length = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, src.length);
    return $panic(_string_builder.val);
  }
}
function _M0MPB18UninitializedArray23make__and__blit_2einnerGORP312moonbitstack7moonstl5cache7LruNodeGiiEE(src, allocate_len, len, src_offset, dst_offset) {
  let _tmp;
  if (allocate_len >= 0) {
    let _tmp$2;
    if (len >= 0) {
      let _tmp$3;
      const _p = src.length;
      if (src_offset >= 0 && src_offset <= (_p - len | 0)) {
        _tmp$3 = dst_offset >= 0 && dst_offset <= (allocate_len - len | 0);
      } else {
        _tmp$3 = false;
      }
      _tmp$2 = _tmp$3;
    } else {
      _tmp$2 = false;
    }
    _tmp = _tmp$2;
  } else {
    _tmp = false;
  }
  if (_tmp) {
    return _M0MPB18UninitializedArray23unsafe__make__and__blitGORP312moonbitstack7moonstl5cache7LruNodeGiiEE(src, allocate_len, src_offset, dst_offset, len);
  } else {
    const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(89);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "bounds check failed: allocate_len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, allocate_len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, src_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", dst_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, dst_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src.length = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, src.length);
    return $panic(_string_builder.val);
  }
}
function _M0MPB13StringBuilder21StringBuilder_2einner(size_hint) {
  return size_hint >= 0 ? new _M0TPB13StringBuilder("") : $panic("size_hint must be non-negative");
}
function _M0IPB13StringBuilderPB6Logger11write__char(self, ch) {
  self.val = `${self.val}${String.fromCodePoint(ch)}`;
}
function _M0IPB13StringBuilderPB6Logger13write__string(self, str) {
  self.val = `${self.val}${str}`;
}
function _M0FPB32code__point__of__surrogate__pair(leading, trailing) {
  return (((Math.imul(leading - 55296 | 0, 1024) | 0) + trailing | 0) - 56320 | 0) + 65536 | 0;
}
function _M0MPC16string10StringView21clamped__view_2einner(self, start, end) {
  const len = self.end - self.start | 0;
  const str = self.str;
  const base = self.start;
  let lo;
  if (start <= 0) {
    lo = 0;
  } else {
    if (start >= len) {
      lo = len;
    } else {
      let _tmp;
      const _p = str.charCodeAt(base + start | 0);
      if (_p >= 56320 && _p <= 57343) {
        const _p$2 = str.charCodeAt((base + start | 0) - 1 | 0);
        _tmp = _p$2 >= 55296 && _p$2 <= 56319;
      } else {
        _tmp = false;
      }
      if (_tmp) {
        lo = start + 1 | 0;
      } else {
        lo = start;
      }
    }
  }
  let hi;
  if (end === undefined) {
    hi = len;
  } else {
    const _Some = end;
    const _e = _Some;
    if (_e <= 0) {
      hi = 0;
    } else {
      if (_e >= len) {
        hi = len;
      } else {
        let _tmp;
        const _p = str.charCodeAt(base + _e | 0);
        if (_p >= 56320 && _p <= 57343) {
          const _p$2 = str.charCodeAt((base + _e | 0) - 1 | 0);
          _tmp = _p$2 >= 55296 && _p$2 <= 56319;
        } else {
          _tmp = false;
        }
        if (_tmp) {
          hi = _e - 1 | 0;
        } else {
          hi = _e;
        }
      }
    }
  }
  return lo >= hi ? new _M0TPC16string10StringView(str, base + lo | 0, base + lo | 0) : new _M0TPC16string10StringView(str, base + lo | 0, base + hi | 0);
}
function _M0MPB6Hasher12combine__int(self, value) {
  _M0MPB6Hasher13combine__uint(self, value);
}
function _M0MPB6Hasher7combineGzE(self, value) {
  _M0IPC15bytes5BytesPB4Hash13hash__combine(value, self);
}
function _M0MPB6Hasher7combineGiE(self, value) {
  _M0IPC13int3IntPB4Hash13hash__combine(value, self);
}
function _M0MPB6Hasher7combineGRPC15bytes9BytesViewE(self, value) {
  _M0IPC15bytes9BytesViewPB4Hash13hash__combine(value, self);
}
function _M0IP016_24default__implPB2Eq10not__equalGOsE(x, y) {
  return !_M0IPC16option6OptionPB2Eq5equalGsE(x, y);
}
function _M0IP016_24default__implPB2Eq10not__equalGOiE(x, y) {
  return !_M0IPC16option6OptionPB2Eq5equalGiE(x, y);
}
function _M0MPB6Hasher14Hasher_2einner(seed) {
  return new _M0TPB6Hasher((seed >>> 0) + (374761393 >>> 0) | 0);
}
function _M0MPB6Hasher6Hasher(seed$46$opt) {
  let seed;
  if (seed$46$opt === undefined) {
    seed = _M0FPB4seed;
  } else {
    const _Some = seed$46$opt;
    seed = _Some;
  }
  return _M0MPB6Hasher14Hasher_2einner(seed);
}
function _M0FPB14avalanche__acc(acc) {
  let acc$2 = acc;
  acc$2 = acc$2 ^ (acc$2 >>> 15 | 0);
  acc$2 = Math.imul(acc$2, -2048144777) | 0;
  acc$2 = acc$2 ^ (acc$2 >>> 13 | 0);
  acc$2 = Math.imul(acc$2, -1028477379) | 0;
  acc$2 = acc$2 ^ (acc$2 >>> 16 | 0);
  return acc$2;
}
function _M0FPB13finalize__acc(acc) {
  return _M0FPB14avalanche__acc(acc);
}
function _M0MPB6Hasher8finalize(self) {
  return _M0FPB13finalize__acc(self.acc);
}
function _M0IP016_24default__implPB4Hash4hashGzE(self) {
  const h = _M0MPB6Hasher6Hasher(undefined);
  _M0MPB6Hasher7combineGzE(h, self);
  return _M0MPB6Hasher8finalize(h);
}
function _M0IP016_24default__implPB6Logger28write__string__interpolationGRPB13StringBuilderE(self, show) {
  show.method_table.method_0(show.self, { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
}
function _M0IP016_24default__implPB6Logger5writeGRPB13StringBuilderE(self, show) {
  show.method_table.method_0(show.self, { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
}
function _M0MPC16string6String21clamped__view_2einner(self, start, end) {
  const len = self.length;
  let lo;
  if (start <= 0) {
    lo = 0;
  } else {
    if (start >= len) {
      lo = len;
    } else {
      let _tmp;
      const _p = self.charCodeAt(start);
      if (_p >= 56320 && _p <= 57343) {
        const _p$2 = self.charCodeAt(start - 1 | 0);
        _tmp = _p$2 >= 55296 && _p$2 <= 56319;
      } else {
        _tmp = false;
      }
      if (_tmp) {
        lo = start + 1 | 0;
      } else {
        lo = start;
      }
    }
  }
  let hi;
  if (end === undefined) {
    hi = len;
  } else {
    const _Some = end;
    const _e = _Some;
    if (_e <= 0) {
      hi = 0;
    } else {
      if (_e >= len) {
        hi = len;
      } else {
        let _tmp;
        const _p = self.charCodeAt(_e);
        if (_p >= 56320 && _p <= 57343) {
          const _p$2 = self.charCodeAt(_e - 1 | 0);
          _tmp = _p$2 >= 55296 && _p$2 <= 56319;
        } else {
          _tmp = false;
        }
        if (_tmp) {
          hi = _e - 1 | 0;
        } else {
          hi = _e;
        }
      }
    }
  }
  return lo >= hi ? new _M0TPC16string10StringView(self, lo, lo) : new _M0TPC16string10StringView(self, lo, hi);
}
function _M0IP016_24default__implPB6Logger16write__substringGRPB13StringBuilderE(self, value, start, len) {
  _M0IPB13StringBuilderPB6Logger11write__view(self, _M0MPC16string6String21clamped__view_2einner(value, start, start + len | 0));
}
function _M0IP016_24default__implPB4Show6outputGsE(self, logger) {
  logger.method_table.method_0(logger.self, self);
}
function _M0IP016_24default__implPB4Show6outputGiE(self, logger) {
  logger.method_table.method_0(logger.self, _M0IPC13int3IntPB4Show10to__string(self));
}
function _M0IP016_24default__implPB4Show6outputGmE(self, logger) {
  logger.method_table.method_0(logger.self, _M0IPC16uint646UInt64PB4Show10to__string(self));
}
function _M0IP016_24default__implPB4Show6outputGdE(self, logger) {
  logger.method_table.method_0(logger.self, _M0IPC16double6DoublePB4Show10to__string(self));
}
function _M0IP016_24default__implPB4Show10to__stringGRP212moonbitstack8moonseed11UnavailableE(self) {
  const logger = _M0MPB13StringBuilder21StringBuilder_2einner(8);
  _M0IP212moonbitstack8moonseed11UnavailablePB4Show6output(self, { self: logger, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
  return logger.val;
}
function _M0IP016_24default__implPB4Show10to__stringGRP312moonbitstack7moonstl4spec7RefusedE(self) {
  const logger = _M0MPB13StringBuilder21StringBuilder_2einner(8);
  _M0IP312moonbitstack7moonstl4spec7RefusedPB4Show6output(self, { self: logger, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
  return logger.val;
}
function _M0IP016_24default__implPB4Show10to__stringGRPB7FailureE(self) {
  const logger = _M0MPB13StringBuilder21StringBuilder_2einner(8);
  _M0IPB7FailurePB4Show6output(self, { self: logger, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
  return logger.val;
}
function _M0MPB4Iter4nextGUcRPB5ArrayGiEEE(self) {
  const _func = self.f;
  const result = _func();
  const _bind = self.size_hint;
  if (result === undefined) {
    self.size_hint = _M0MPB4Iter4nextN6constrS662GUcRPB5ArrayGiEEE;
  } else {
    if (_bind === undefined) {
    } else {
      const _Some = _bind;
      const _n = _Some;
      self.size_hint = _n > 0 ? _n - 1 | 0 : _M0MPB4Iter4nextN6constrS661GUcRPB5ArrayGiEEE;
    }
  }
  return result;
}
function _M0MPB4Iter4nextGcE(self) {
  const _func = self.f;
  const result = _func();
  const _bind = self.size_hint;
  if (result === -1) {
    self.size_hint = _M0MPB4Iter4nextN6constrS694GcE;
  } else {
    if (_bind === undefined) {
    } else {
      const _Some = _bind;
      const _n = _Some;
      self.size_hint = _n > 0 ? _n - 1 | 0 : _M0MPB4Iter4nextN6constrS693GcE;
    }
  }
  return result;
}
function _M0MPB4Iter4nextGiE(self) {
  const _func = self.f;
  const result = _func();
  const _bind = self.size_hint;
  if (result === undefined) {
    self.size_hint = _M0MPB4Iter4nextN6constrS718GiE;
  } else {
    if (_bind === undefined) {
    } else {
      const _Some = _bind;
      const _n = _Some;
      self.size_hint = _n > 0 ? _n - 1 | 0 : _M0MPB4Iter4nextN6constrS717GiE;
    }
  }
  return result;
}
function _M0MPC13int3Int18to__string_2einner(self, radix) {
  return _M0FPB19int__to__string__js(self, radix);
}
function _M0MPB4Iter3newGUcRPB5ArrayGiEEE(f, size_hint) {
  let size_hint$2;
  if (size_hint === undefined) {
    size_hint$2 = undefined;
  } else {
    const _Some = size_hint;
    const _n = _Some;
    size_hint$2 = _n > 0 ? _n : _M0MPB4Iter3newN6constrS735GUcRPB5ArrayGiEEE;
  }
  return new _M0TPB4IterGUcRPB5ArrayGiEEE(f, size_hint$2);
}
function _M0MPB4Iter3newGcE(f, size_hint) {
  let size_hint$2;
  if (size_hint === undefined) {
    size_hint$2 = undefined;
  } else {
    const _Some = size_hint;
    const _n = _Some;
    size_hint$2 = _n > 0 ? _n : _M0MPB4Iter3newN6constrS759GcE;
  }
  return new _M0TPB4IterGcE(f, size_hint$2);
}
function _M0MPB4Iter3newGiE(f, size_hint) {
  let size_hint$2;
  if (size_hint === undefined) {
    size_hint$2 = undefined;
  } else {
    const _Some = size_hint;
    const _n = _Some;
    size_hint$2 = _n > 0 ? _n : _M0MPB4Iter3newN6constrS771GiE;
  }
  return new _M0TPB4IterGiE(f, size_hint$2);
}
function _M0MPC16string10StringView9to__owned(self) {
  return self.str.substring(self.start, self.end);
}
function _M0MPC16string6String24char__length__ge_2einner(self, len, start, end) {
  let end$2;
  if (end === undefined) {
    end$2 = self.length;
  } else {
    const _Some = end;
    end$2 = _Some;
  }
  let _tmp = start;
  let _tmp$2 = 0;
  while (true) {
    const index = _tmp;
    const count = _tmp$2;
    if (index < end$2 && count < len) {
      const c1 = self.charCodeAt(index);
      if (c1 >= 55296 && c1 <= 56319 && (index + 1 | 0) < end$2) {
        const c2 = self.charCodeAt(index + 1 | 0);
        if (c2 >= 56320 && c2 <= 57343) {
          _tmp = index + 2 | 0;
          _tmp$2 = count + 1 | 0;
          continue;
        } else {
          $panic("invalid surrogate pair");
        }
      }
      _tmp = index + 1 | 0;
      _tmp$2 = count + 1 | 0;
      continue;
    } else {
      return count >= len;
    }
  }
}
function _M0MPC16string6String31offset__of__nth__char__backward(self, n, start_offset, end_offset) {
  let _tmp = end_offset;
  let _tmp$2 = 0;
  while (true) {
    const utf16_offset = _tmp;
    const char_count = _tmp$2;
    if ((utf16_offset - 1 | 0) >= start_offset && char_count < n) {
      const c = self.charCodeAt(utf16_offset - 1 | 0);
      if (c >= 56320 && c <= 57343) {
        _tmp = utf16_offset - 2 | 0;
        _tmp$2 = char_count + 1 | 0;
        continue;
      } else {
        _tmp = utf16_offset - 1 | 0;
        _tmp$2 = char_count + 1 | 0;
        continue;
      }
    } else {
      return char_count < n || utf16_offset < start_offset ? undefined : utf16_offset;
    }
  }
}
function _M0MPC16string6String30offset__of__nth__char__forward(self, n, start_offset, end_offset) {
  if (start_offset >= 0 && start_offset <= end_offset) {
    let _tmp = start_offset;
    let _tmp$2 = 0;
    while (true) {
      const utf16_offset = _tmp;
      const char_count = _tmp$2;
      if (utf16_offset < end_offset && char_count < n) {
        const c = self.charCodeAt(utf16_offset);
        if (c >= 55296 && c <= 56319) {
          _tmp = utf16_offset + 2 | 0;
          _tmp$2 = char_count + 1 | 0;
          continue;
        } else {
          _tmp = utf16_offset + 1 | 0;
          _tmp$2 = char_count + 1 | 0;
          continue;
        }
      } else {
        return char_count < n || utf16_offset >= end_offset ? undefined : utf16_offset;
      }
    }
  } else {
    return $panic("Invalid start index");
  }
}
function _M0MPC16string6String29offset__of__nth__char_2einner(self, i, start, end) {
  let end$2;
  if (end === undefined) {
    end$2 = self.length;
  } else {
    const _Some = end;
    end$2 = _Some;
  }
  return i >= 0 ? _M0MPC16string6String30offset__of__nth__char__forward(self, i, start, end$2) : _M0MPC16string6String31offset__of__nth__char__backward(self, -i | 0, start, end$2);
}
function _M0IPB13StringBuilderPB6Logger11write__view(self, str) {
  self.val = `${self.val}${_M0MPC16string10StringView9to__owned(str)}`;
}
function _M0MPC15array5Array13Array_2einnerGcE(capacity) {
  return capacity === 0 ? new _M0TPB5ArrayGcE([], 0) : new _M0TPB5ArrayGcE(new Array(capacity), 0);
}
function _M0MPC15array5Array13Array_2einnerGRPC14json4JsonE(capacity) {
  return capacity === 0 ? new _M0TPB5ArrayGRPC14json4JsonE([], 0) : new _M0TPB5ArrayGRPC14json4JsonE(new Array(capacity), 0);
}
function _M0MPC15array5Array13Array_2einnerGiE(capacity) {
  return capacity === 0 ? new _M0TPB5ArrayGiE([], 0) : new _M0TPB5ArrayGiE(new Array(capacity), 0);
}
function _M0FPB23array__growth__capacity(current, len, required) {
  if (required < len) {
    $panic("Array capacity overflow");
  }
  const start = current === 0 ? 8 : current;
  let _tmp = start;
  while (true) {
    const space = _tmp;
    if (space < required) {
      const next = Math.imul(space, 2) | 0;
      if (next <= space) {
        return required;
      }
      _tmp = next;
      continue;
    } else {
      return space;
    }
  }
}
function _M0MPC15array5Array8capacityGRP312moonbitstack7moonstl4text6OpcodeE(self) {
  return self.buf.length;
}
function _M0MPC15array5Array8capacityGOiE(self) {
  return self.buf.length;
}
function _M0MPC15array5Array8capacityGcE(self) {
  return self.buf.length;
}
function _M0MPC15array5Array8capacityGiE(self) {
  return self.buf.length;
}
function _M0MPC15array5Array8capacityGbE(self) {
  return self.buf.length;
}
function _M0MPC15array5Array8capacityGORP312moonbitstack7moonstl5cache7LruNodeGiiEE(self) {
  return self.buf.length;
}
function _M0MPC15array5Array14resize__bufferGRP312moonbitstack7moonstl4text6OpcodeE(self, new_capacity) {
  const old_buf = self.buf;
  self.buf = [];
  const len = self.len;
  const copy_len = len < new_capacity ? len : new_capacity;
  const new_buf = _M0MPB18UninitializedArray23make__and__blit_2einnerGRP312moonbitstack7moonstl4text6OpcodeE(old_buf, new_capacity, copy_len, 0, 0);
  self.buf = new_buf;
}
function _M0MPC15array5Array14resize__bufferGOiE(self, new_capacity) {
  const old_buf = self.buf;
  self.buf = [];
  const len = self.len;
  const copy_len = len < new_capacity ? len : new_capacity;
  const new_buf = _M0MPB18UninitializedArray23make__and__blit_2einnerGOiE(old_buf, new_capacity, copy_len, 0, 0);
  self.buf = new_buf;
}
function _M0MPC15array5Array14resize__bufferGcE(self, new_capacity) {
  const old_buf = self.buf;
  self.buf = [];
  const len = self.len;
  const copy_len = len < new_capacity ? len : new_capacity;
  const new_buf = _M0MPB18UninitializedArray23make__and__blit_2einnerGcE(old_buf, new_capacity, copy_len, 0, 0);
  self.buf = new_buf;
}
function _M0MPC15array5Array14resize__bufferGiE(self, new_capacity) {
  const old_buf = self.buf;
  self.buf = [];
  const len = self.len;
  const copy_len = len < new_capacity ? len : new_capacity;
  const new_buf = _M0MPB18UninitializedArray23make__and__blit_2einnerGiE(old_buf, new_capacity, copy_len, 0, 0);
  self.buf = new_buf;
}
function _M0MPC15array5Array14resize__bufferGbE(self, new_capacity) {
  const old_buf = self.buf;
  self.buf = [];
  const len = self.len;
  const copy_len = len < new_capacity ? len : new_capacity;
  const new_buf = _M0MPB18UninitializedArray23make__and__blit_2einnerGbE(old_buf, new_capacity, copy_len, 0, 0);
  self.buf = new_buf;
}
function _M0MPC15array5Array14resize__bufferGORP312moonbitstack7moonstl5cache7LruNodeGiiEE(self, new_capacity) {
  const old_buf = self.buf;
  self.buf = [];
  const len = self.len;
  const copy_len = len < new_capacity ? len : new_capacity;
  const new_buf = _M0MPB18UninitializedArray23make__and__blit_2einnerGORP312moonbitstack7moonstl5cache7LruNodeGiiEE(old_buf, new_capacity, copy_len, 0, 0);
  self.buf = new_buf;
}
function _M0MPC15array5Array7reallocGRP312moonbitstack7moonstl4text6OpcodeE(self, required) {
  const old_cap = _M0MPC15array5Array8capacityGRP312moonbitstack7moonstl4text6OpcodeE(self);
  const new_cap = _M0FPB23array__growth__capacity(old_cap, self.len, required);
  _M0MPC15array5Array14resize__bufferGRP312moonbitstack7moonstl4text6OpcodeE(self, new_cap);
}
function _M0MPC15array5Array7reallocGOiE(self, required) {
  const old_cap = _M0MPC15array5Array8capacityGOiE(self);
  const new_cap = _M0FPB23array__growth__capacity(old_cap, self.len, required);
  _M0MPC15array5Array14resize__bufferGOiE(self, new_cap);
}
function _M0MPC15array5Array7reallocGcE(self, required) {
  const old_cap = _M0MPC15array5Array8capacityGcE(self);
  const new_cap = _M0FPB23array__growth__capacity(old_cap, self.len, required);
  _M0MPC15array5Array14resize__bufferGcE(self, new_cap);
}
function _M0MPC15array5Array7reallocGiE(self, required) {
  const old_cap = _M0MPC15array5Array8capacityGiE(self);
  const new_cap = _M0FPB23array__growth__capacity(old_cap, self.len, required);
  _M0MPC15array5Array14resize__bufferGiE(self, new_cap);
}
function _M0MPC15array5Array7reallocGbE(self, required) {
  const old_cap = _M0MPC15array5Array8capacityGbE(self);
  const new_cap = _M0FPB23array__growth__capacity(old_cap, self.len, required);
  _M0MPC15array5Array14resize__bufferGbE(self, new_cap);
}
function _M0MPC15array5Array7reallocGORP312moonbitstack7moonstl5cache7LruNodeGiiEE(self, required) {
  const old_cap = _M0MPC15array5Array8capacityGORP312moonbitstack7moonstl5cache7LruNodeGiiEE(self);
  const new_cap = _M0FPB23array__growth__capacity(old_cap, self.len, required);
  _M0MPC15array5Array14resize__bufferGORP312moonbitstack7moonstl5cache7LruNodeGiiEE(self, new_cap);
}
function _M0MPC15array5Array4pushGRP312moonbitstack7moonstl4text6OpcodeE(self, value) {
  if (self.len === self.buf.length) {
    _M0MPC15array5Array7reallocGRP312moonbitstack7moonstl4text6OpcodeE(self, self.len + 1 | 0);
  }
  const length = self.len;
  self.buf[length] = value;
  self.len = length + 1 | 0;
}
function _M0MPC15array5Array4pushGOiE(self, value) {
  if (self.len === self.buf.length) {
    _M0MPC15array5Array7reallocGOiE(self, self.len + 1 | 0);
  }
  const length = self.len;
  self.buf[length] = value;
  self.len = length + 1 | 0;
}
function _M0MPC15array5Array4pushGcE(self, value) {
  if (self.len === self.buf.length) {
    _M0MPC15array5Array7reallocGcE(self, self.len + 1 | 0);
  }
  const length = self.len;
  self.buf[length] = value;
  self.len = length + 1 | 0;
}
function _M0MPC15array5Array4pushGiE(self, value) {
  if (self.len === self.buf.length) {
    _M0MPC15array5Array7reallocGiE(self, self.len + 1 | 0);
  }
  const length = self.len;
  self.buf[length] = value;
  self.len = length + 1 | 0;
}
function _M0MPC15array5Array4pushGbE(self, value) {
  if (self.len === self.buf.length) {
    _M0MPC15array5Array7reallocGbE(self, self.len + 1 | 0);
  }
  const length = self.len;
  self.buf[length] = value;
  self.len = length + 1 | 0;
}
function _M0MPC15array5Array4pushGORP312moonbitstack7moonstl5cache7LruNodeGiiEE(self, value) {
  if (self.len === self.buf.length) {
    _M0MPC15array5Array7reallocGORP312moonbitstack7moonstl5cache7LruNodeGiiEE(self, self.len + 1 | 0);
  }
  const length = self.len;
  self.buf[length] = value;
  self.len = length + 1 | 0;
}
function _M0FPB36string__contains__code__unit__scalar(str, start, end, code) {
  let _tmp = start;
  while (true) {
    const i = _tmp;
    if (i < end) {
      if (str.charCodeAt(i) === code) {
        return true;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return false;
}
function _M0FPB28string__contains__code__unit(str, start, end, code) {
  return _M0FPB36string__contains__code__unit__scalar(str, start, end, code);
}
function _M0MPC16string10StringView20contains__code__unit(self, code) {
  return _M0FPB28string__contains__code__unit(self.str, self.start, self.end, code);
}
function _M0MPC16string6String4iter(self) {
  const len = self.length;
  const index = new _M0TPB8MutLocalGiE(0);
  return _M0MPB4Iter3newGcE(() => {
    if (index.val < len) {
      const c1 = self.charCodeAt(index.val);
      if (c1 >= 55296 && c1 <= 56319 && (index.val + 1 | 0) < len) {
        const c2 = self.charCodeAt(index.val + 1 | 0);
        if (c2 >= 56320 && c2 <= 57343) {
          const c = _M0FPB32code__point__of__surrogate__pair(c1, c2);
          index.val = index.val + 2 | 0;
          return c;
        }
      }
      index.val = index.val + 1 | 0;
      return c1;
    } else {
      return -1;
    }
  }, undefined);
}
function _M0MPB4Iter3mapGUiiEiE(self, f) {
  return new _M0TPB4IterGiE(() => {
    const _bind = _M0MPB4Iter4nextGUcRPB5ArrayGiEEE(self);
    if (_bind === undefined) {
      return undefined;
    } else {
      const _Some = _bind;
      const _x = _Some;
      return f(_x);
    }
  }, self.size_hint);
}
function _M0MPB4Iter3mapGRPB5ArrayGiERPC14json4JsonE(self, f) {
  return new _M0TPB4IterGRPC14json4JsonE(() => {
    const _bind = _M0MPB4Iter4nextGUcRPB5ArrayGiEEE(self);
    if (_bind === undefined) {
      return undefined;
    } else {
      const _Some = _bind;
      const _x = _Some;
      return f(_x);
    }
  }, self.size_hint);
}
function _M0IPC14char4CharPB4Show10to__string(self) {
  return String.fromCodePoint(self);
}
function _M0MPB4Iter9to__arrayGcE(self) {
  const _bind = self.size_hint;
  let result;
  if (_bind === undefined) {
    result = new _M0TPB5ArrayGcE([], 0);
  } else {
    const _Some = _bind;
    const _n = _Some;
    result = _M0MPC15array5Array13Array_2einnerGcE(_n);
  }
  while (true) {
    const _bind$2 = _M0MPB4Iter4nextGcE(self);
    if (_bind$2 === -1) {
      break;
    } else {
      const _Some = _bind$2;
      const _x = _Some;
      _M0MPC15array5Array4pushGcE(result, _x);
      continue;
    }
  }
  return result;
}
function _M0MPB4Iter9to__arrayGRPC14json4JsonE(self) {
  const _bind = self.size_hint;
  let result;
  if (_bind === undefined) {
    result = new _M0TPB5ArrayGRPC14json4JsonE([], 0);
  } else {
    const _Some = _bind;
    const _n = _Some;
    result = _M0MPC15array5Array13Array_2einnerGRPC14json4JsonE(_n);
  }
  while (true) {
    const _bind$2 = _M0MPB4Iter4nextGUcRPB5ArrayGiEEE(self);
    if (_bind$2 === undefined) {
      break;
    } else {
      const _Some = _bind$2;
      const _x = _Some;
      _M0MPC15array5Array4pushGRP312moonbitstack7moonstl4text6OpcodeE(result, _x);
      continue;
    }
  }
  return result;
}
function _M0MPB4Iter9to__arrayGiE(self) {
  const _bind = self.size_hint;
  let result;
  if (_bind === undefined) {
    result = new _M0TPB5ArrayGiE([], 0);
  } else {
    const _Some = _bind;
    const _n = _Some;
    result = _M0MPC15array5Array13Array_2einnerGiE(_n);
  }
  while (true) {
    const _bind$2 = _M0MPB4Iter4nextGiE(self);
    if (_bind$2 === undefined) {
      break;
    } else {
      const _Some = _bind$2;
      const _x = _Some;
      _M0MPC15array5Array4pushGiE(result, _x);
      continue;
    }
  }
  return result;
}
function _M0MPC16string6String9get__char(self, idx) {
  if (idx >= 0 && idx < self.length) {
    const c = self.charCodeAt(idx);
    if (c >= 55296 && c <= 56319) {
      if ((idx + 1 | 0) < self.length) {
        const next = self.charCodeAt(idx + 1 | 0);
        return next >= 56320 && next <= 57343 ? _M0FPB32code__point__of__surrogate__pair(c, next) : -1;
      } else {
        return -1;
      }
    } else {
      return c >= 56320 && c <= 57343 ? -1 : c;
    }
  } else {
    return -1;
  }
}
function _M0MPC14byte4Byte10to__uint64(self) {
  const _p = self;
  return BigInt.asUintN(64, BigInt(_p >>> 0));
}
function _M0IPC13int3IntPB4Show10to__string(self) {
  return _M0MPC13int3Int18to__string_2einner(self, 10);
}
function _M0IPC16uint646UInt64PB4Show10to__string(self) {
  return _M0MPC16uint646UInt6418to__string_2einner(self, 10);
}
function _M0MPC15array5Array20unsafe__make__uninitGRPC14json4JsonE(len) {
  return new _M0TPB5ArrayGRPC14json4JsonE(new Array(len), len);
}
function _M0MPC15array5Array20unsafe__make__uninitGiE(len) {
  return new _M0TPB5ArrayGiE(new Array(len), len);
}
function _M0IPC16option6OptionPB2Eq5equalGsE(self, other) {
  if (self === undefined) {
    return other === undefined;
  } else {
    const _Some = self;
    const _x = _Some;
    if (other === undefined) {
      return false;
    } else {
      const _Some$2 = other;
      const _y = _Some$2;
      return _x === _y;
    }
  }
}
function _M0IPC16option6OptionPB2Eq5equalGiE(self, other) {
  if (self === undefined) {
    return other === undefined;
  } else {
    const _Some = self;
    const _x = _Some;
    if (other === undefined) {
      return false;
    } else {
      const _Some$2 = other;
      const _y = _Some$2;
      return _x === _y;
    }
  }
}
function _M0MPC16option6Option10unwrap__orGRPC14json4JsonE(self, default_) {
  if (self === undefined) {
    return default_;
  } else {
    const _Some = self;
    const _t = _Some;
    return _t;
  }
}
function _M0MPC16option6Option10unwrap__orGiE(self, default_) {
  if (self === undefined) {
    return default_;
  } else {
    const _Some = self;
    const _t = _Some;
    return _t;
  }
}
function _M0MPC15array5Array31unsafe__make__and__blit_2einnerGcE(src, allocate_len, len, src_offset, dst_offset) {
  return new _M0TPB5ArrayGcE(_M0MPB18UninitializedArray23make__and__blit_2einnerGcE(src, allocate_len, len, src_offset, dst_offset), allocate_len);
}
function _M0MPC15array5Array31unsafe__make__and__blit_2einnerGiE(src, allocate_len, len, src_offset, dst_offset) {
  return new _M0TPB5ArrayGiE(_M0MPB18UninitializedArray23make__and__blit_2einnerGiE(src, allocate_len, len, src_offset, dst_offset), allocate_len);
}
function _M0MPC15array9ArrayView9to__ownedGcE(self) {
  const len = self.end - self.start | 0;
  return len === 0 ? new _M0TPB5ArrayGcE([], 0) : _M0MPC15array5Array31unsafe__make__and__blit_2einnerGcE(self.buf, len, len, self.start, 0);
}
function _M0MPC15array9ArrayView9to__ownedGiE(self) {
  const len = self.end - self.start | 0;
  return len === 0 ? new _M0TPB5ArrayGiE([], 0) : _M0MPC15array5Array31unsafe__make__and__blit_2einnerGiE(self.buf, len, len, self.start, 0);
}
function _M0FPB21calc__grow__threshold(capacity) {
  return (Math.imul(capacity / 16 | 0, 13) | 0) + ((Math.imul(capacity % 16 | 0, 13) | 0) / 16 | 0) | 0;
}
function _M0MPC13int3Int20next__power__of__two(self) {
  if (self >= 0) {
    if (self <= 1) {
      return 1;
    }
    if (self > 1073741824) {
      return 1073741824;
    }
    return (2147483647 >> (Math.clz32(self - 1 | 0) - 1 | 0)) + 1 | 0;
  } else {
    return $panic();
  }
}
function _M0FPB8new__mapGiiE(capacity) {
  const capacity$2 = _M0MPC13int3Int20next__power__of__two(capacity);
  const _bind = capacity$2 - 1 | 0;
  const _bind$2 = _M0FPB21calc__grow__threshold(capacity$2);
  const _bind$3 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$4 = undefined;
  return new _M0TPB3MapGiiE(_bind$3, 0, capacity$2, _bind, _bind$2, _bind$4, -1);
}
function _M0FPB8new__mapGsRPC14json4JsonE(capacity) {
  const capacity$2 = _M0MPC13int3Int20next__power__of__two(capacity);
  const _bind = capacity$2 - 1 | 0;
  const _bind$2 = _M0FPB21calc__grow__threshold(capacity$2);
  const _bind$3 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$4 = undefined;
  return new _M0TPB3MapGsRPC14json4JsonE(_bind$3, 0, capacity$2, _bind, _bind$2, _bind$4, -1);
}
function _M0FPB8new__mapGcRPB5ArrayGiEE(capacity) {
  const capacity$2 = _M0MPC13int3Int20next__power__of__two(capacity);
  const _bind = capacity$2 - 1 | 0;
  const _bind$2 = _M0FPB21calc__grow__threshold(capacity$2);
  const _bind$3 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$4 = undefined;
  return new _M0TPB3MapGcRPB5ArrayGiEE(_bind$3, 0, capacity$2, _bind, _bind$2, _bind$4, -1);
}
function _M0FPB8new__mapGciE(capacity) {
  const capacity$2 = _M0MPC13int3Int20next__power__of__two(capacity);
  const _bind = capacity$2 - 1 | 0;
  const _bind$2 = _M0FPB21calc__grow__threshold(capacity$2);
  const _bind$3 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$4 = undefined;
  return new _M0TPB3MapGciE(_bind$3, 0, capacity$2, _bind, _bind$2, _bind$4, -1);
}
function _M0FPB8new__mapGcuE(capacity) {
  const capacity$2 = _M0MPC13int3Int20next__power__of__two(capacity);
  const _bind = capacity$2 - 1 | 0;
  const _bind$2 = _M0FPB21calc__grow__threshold(capacity$2);
  const _bind$3 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$4 = undefined;
  return new _M0TPB3MapGcuE(_bind$3, 0, capacity$2, _bind, _bind$2, _bind$4, -1);
}
function _M0FPB8new__mapGzuE(capacity) {
  const capacity$2 = _M0MPC13int3Int20next__power__of__two(capacity);
  const _bind = capacity$2 - 1 | 0;
  const _bind$2 = _M0FPB21calc__grow__threshold(capacity$2);
  const _bind$3 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$4 = undefined;
  return new _M0TPB3MapGzuE(_bind$3, 0, capacity$2, _bind, _bind$2, _bind$4, -1);
}
function _M0FPB21capacity__for__length(length) {
  if (length <= _M0FPB21calc__grow__threshold(1073741824)) {
    let capacity = _M0MPC13int3Int20next__power__of__two(length);
    if (length > _M0FPB21calc__grow__threshold(capacity)) {
      capacity = Math.imul(capacity, 2) | 0;
    }
    return capacity;
  } else {
    return $panic("Map capacity overflow");
  }
}
function _M0MPB3Map20add__entry__to__tailGiiE(self, idx, entry) {
  const _bind = self.tail;
  if (_bind === -1) {
    self.head = entry;
  } else {
    const _tmp = self.entries;
    const _p = _bind >>> 0 < _tmp.length ? _tmp[_bind] : $oob();
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    _tmp$2.next = entry;
  }
  self.tail = idx;
  self.entries[idx] = entry;
  self.size = self.size + 1 | 0;
}
function _M0MPB3Map20add__entry__to__tailGsRPC14json4JsonE(self, idx, entry) {
  const _bind = self.tail;
  if (_bind === -1) {
    self.head = entry;
  } else {
    const _tmp = self.entries;
    const _p = _bind >>> 0 < _tmp.length ? _tmp[_bind] : $oob();
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    _tmp$2.next = entry;
  }
  self.tail = idx;
  self.entries[idx] = entry;
  self.size = self.size + 1 | 0;
}
function _M0MPB3Map20add__entry__to__tailGcRPB5ArrayGiEE(self, idx, entry) {
  const _bind = self.tail;
  if (_bind === -1) {
    self.head = entry;
  } else {
    const _tmp = self.entries;
    const _p = _bind >>> 0 < _tmp.length ? _tmp[_bind] : $oob();
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    _tmp$2.next = entry;
  }
  self.tail = idx;
  self.entries[idx] = entry;
  self.size = self.size + 1 | 0;
}
function _M0MPB3Map20add__entry__to__tailGciE(self, idx, entry) {
  const _bind = self.tail;
  if (_bind === -1) {
    self.head = entry;
  } else {
    const _tmp = self.entries;
    const _p = _bind >>> 0 < _tmp.length ? _tmp[_bind] : $oob();
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    _tmp$2.next = entry;
  }
  self.tail = idx;
  self.entries[idx] = entry;
  self.size = self.size + 1 | 0;
}
function _M0MPB3Map20add__entry__to__tailGcuE(self, idx, entry) {
  const _bind = self.tail;
  if (_bind === -1) {
    self.head = entry;
  } else {
    const _tmp = self.entries;
    const _p = _bind >>> 0 < _tmp.length ? _tmp[_bind] : $oob();
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    _tmp$2.next = entry;
  }
  self.tail = idx;
  self.entries[idx] = entry;
  self.size = self.size + 1 | 0;
}
function _M0MPB3Map20add__entry__to__tailGzuE(self, idx, entry) {
  const _bind = self.tail;
  if (_bind === -1) {
    self.head = entry;
  } else {
    const _tmp = self.entries;
    const _p = _bind >>> 0 < _tmp.length ? _tmp[_bind] : $oob();
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    _tmp$2.next = entry;
  }
  self.tail = idx;
  self.entries[idx] = entry;
  self.size = self.size + 1 | 0;
}
function _M0MPB3Map10set__entryGiiE(self, entry, new_idx) {
  const _bind = entry.next;
  if (_bind === undefined) {
    self.tail = new_idx;
  } else {
    const _Some = _bind;
    const _next = _Some;
    _next.prev = new_idx;
  }
  self.entries[new_idx] = entry;
}
function _M0MPB3Map10set__entryGsRPC14json4JsonE(self, entry, new_idx) {
  const _bind = entry.next;
  if (_bind === undefined) {
    self.tail = new_idx;
  } else {
    const _Some = _bind;
    const _next = _Some;
    _next.prev = new_idx;
  }
  self.entries[new_idx] = entry;
}
function _M0MPB3Map10set__entryGcRPB5ArrayGiEE(self, entry, new_idx) {
  const _bind = entry.next;
  if (_bind === undefined) {
    self.tail = new_idx;
  } else {
    const _Some = _bind;
    const _next = _Some;
    _next.prev = new_idx;
  }
  self.entries[new_idx] = entry;
}
function _M0MPB3Map10set__entryGciE(self, entry, new_idx) {
  const _bind = entry.next;
  if (_bind === undefined) {
    self.tail = new_idx;
  } else {
    const _Some = _bind;
    const _next = _Some;
    _next.prev = new_idx;
  }
  self.entries[new_idx] = entry;
}
function _M0MPB3Map10set__entryGcuE(self, entry, new_idx) {
  const _bind = entry.next;
  if (_bind === undefined) {
    self.tail = new_idx;
  } else {
    const _Some = _bind;
    const _next = _Some;
    _next.prev = new_idx;
  }
  self.entries[new_idx] = entry;
}
function _M0MPB3Map10set__entryGzuE(self, entry, new_idx) {
  const _bind = entry.next;
  if (_bind === undefined) {
    self.tail = new_idx;
  } else {
    const _Some = _bind;
    const _next = _Some;
    _next.prev = new_idx;
  }
  self.entries[new_idx] = entry;
}
function _M0MPB3Map10push__awayGiiE(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _bind = self.entries[idx$2];
    if (_bind === undefined) {
      entry$2.psl = psl;
      _M0MPB3Map10set__entryGiiE(self, entry$2, idx$2);
      return;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        _M0MPB3Map10set__entryGiiE(self, entry$2, idx$2);
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPB3Map10push__awayGsRPC14json4JsonE(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _bind = self.entries[idx$2];
    if (_bind === undefined) {
      entry$2.psl = psl;
      _M0MPB3Map10set__entryGsRPC14json4JsonE(self, entry$2, idx$2);
      return;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        _M0MPB3Map10set__entryGsRPC14json4JsonE(self, entry$2, idx$2);
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPB3Map10push__awayGcRPB5ArrayGiEE(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _bind = self.entries[idx$2];
    if (_bind === undefined) {
      entry$2.psl = psl;
      _M0MPB3Map10set__entryGcRPB5ArrayGiEE(self, entry$2, idx$2);
      return;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        _M0MPB3Map10set__entryGcRPB5ArrayGiEE(self, entry$2, idx$2);
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPB3Map10push__awayGciE(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _bind = self.entries[idx$2];
    if (_bind === undefined) {
      entry$2.psl = psl;
      _M0MPB3Map10set__entryGciE(self, entry$2, idx$2);
      return;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        _M0MPB3Map10set__entryGciE(self, entry$2, idx$2);
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPB3Map10push__awayGcuE(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _bind = self.entries[idx$2];
    if (_bind === undefined) {
      entry$2.psl = psl;
      _M0MPB3Map10set__entryGcuE(self, entry$2, idx$2);
      return;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        _M0MPB3Map10set__entryGcuE(self, entry$2, idx$2);
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPB3Map10push__awayGzuE(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _bind = self.entries[idx$2];
    if (_bind === undefined) {
      entry$2.psl = psl;
      _M0MPB3Map10set__entryGzuE(self, entry$2, idx$2);
      return;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        _M0MPB3Map10set__entryGzuE(self, entry$2, idx$2);
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPB3Map20rehash__place__entryGiiE(self, outer) {
  const hash = outer.hash;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      outer.psl = psl;
      outer.prev = self.tail;
      _M0MPB3Map20add__entry__to__tailGiiE(self, idx, outer);
      return undefined;
    } else {
      const _Some = _bind;
      const _curr = _Some;
      if (psl > _curr.psl) {
        _M0MPB3Map10push__awayGiiE(self, idx, _curr);
        outer.psl = psl;
        outer.prev = self.tail;
        _M0MPB3Map20add__entry__to__tailGiiE(self, idx, outer);
        return undefined;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPB3Map20rehash__place__entryGsRPC14json4JsonE(self, outer) {
  const hash = outer.hash;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      outer.psl = psl;
      outer.prev = self.tail;
      _M0MPB3Map20add__entry__to__tailGsRPC14json4JsonE(self, idx, outer);
      return undefined;
    } else {
      const _Some = _bind;
      const _curr = _Some;
      if (psl > _curr.psl) {
        _M0MPB3Map10push__awayGsRPC14json4JsonE(self, idx, _curr);
        outer.psl = psl;
        outer.prev = self.tail;
        _M0MPB3Map20add__entry__to__tailGsRPC14json4JsonE(self, idx, outer);
        return undefined;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPB3Map20rehash__place__entryGcRPB5ArrayGiEE(self, outer) {
  const hash = outer.hash;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      outer.psl = psl;
      outer.prev = self.tail;
      _M0MPB3Map20add__entry__to__tailGcRPB5ArrayGiEE(self, idx, outer);
      return undefined;
    } else {
      const _Some = _bind;
      const _curr = _Some;
      if (psl > _curr.psl) {
        _M0MPB3Map10push__awayGcRPB5ArrayGiEE(self, idx, _curr);
        outer.psl = psl;
        outer.prev = self.tail;
        _M0MPB3Map20add__entry__to__tailGcRPB5ArrayGiEE(self, idx, outer);
        return undefined;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPB3Map20rehash__place__entryGciE(self, outer) {
  const hash = outer.hash;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      outer.psl = psl;
      outer.prev = self.tail;
      _M0MPB3Map20add__entry__to__tailGciE(self, idx, outer);
      return undefined;
    } else {
      const _Some = _bind;
      const _curr = _Some;
      if (psl > _curr.psl) {
        _M0MPB3Map10push__awayGciE(self, idx, _curr);
        outer.psl = psl;
        outer.prev = self.tail;
        _M0MPB3Map20add__entry__to__tailGciE(self, idx, outer);
        return undefined;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPB3Map20rehash__place__entryGcuE(self, outer) {
  const hash = outer.hash;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      outer.psl = psl;
      outer.prev = self.tail;
      _M0MPB3Map20add__entry__to__tailGcuE(self, idx, outer);
      return undefined;
    } else {
      const _Some = _bind;
      const _curr = _Some;
      if (psl > _curr.psl) {
        _M0MPB3Map10push__awayGcuE(self, idx, _curr);
        outer.psl = psl;
        outer.prev = self.tail;
        _M0MPB3Map20add__entry__to__tailGcuE(self, idx, outer);
        return undefined;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPB3Map20rehash__place__entryGzuE(self, outer) {
  const hash = outer.hash;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      outer.psl = psl;
      outer.prev = self.tail;
      _M0MPB3Map20add__entry__to__tailGzuE(self, idx, outer);
      return undefined;
    } else {
      const _Some = _bind;
      const _curr = _Some;
      if (psl > _curr.psl) {
        _M0MPB3Map10push__awayGzuE(self, idx, _curr);
        outer.psl = psl;
        outer.prev = self.tail;
        _M0MPB3Map20add__entry__to__tailGzuE(self, idx, outer);
        return undefined;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPB3Map4growGiiE(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  self.grow_at = _M0FPB21calc__grow__threshold(self.capacity);
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp = old_head;
  while (true) {
    const x = _tmp;
    if (x === undefined) {
      return;
    } else {
      const _Some = x;
      const _e = _Some;
      const next_in_chain = _e.next;
      _e.next = undefined;
      _M0MPB3Map20rehash__place__entryGiiE(self, _e);
      _tmp = next_in_chain;
      continue;
    }
  }
}
function _M0MPB3Map4growGsRPC14json4JsonE(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  self.grow_at = _M0FPB21calc__grow__threshold(self.capacity);
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp = old_head;
  while (true) {
    const x = _tmp;
    if (x === undefined) {
      return;
    } else {
      const _Some = x;
      const _e = _Some;
      const next_in_chain = _e.next;
      _e.next = undefined;
      _M0MPB3Map20rehash__place__entryGsRPC14json4JsonE(self, _e);
      _tmp = next_in_chain;
      continue;
    }
  }
}
function _M0MPB3Map4growGcRPB5ArrayGiEE(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  self.grow_at = _M0FPB21calc__grow__threshold(self.capacity);
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp = old_head;
  while (true) {
    const x = _tmp;
    if (x === undefined) {
      return;
    } else {
      const _Some = x;
      const _e = _Some;
      const next_in_chain = _e.next;
      _e.next = undefined;
      _M0MPB3Map20rehash__place__entryGcRPB5ArrayGiEE(self, _e);
      _tmp = next_in_chain;
      continue;
    }
  }
}
function _M0MPB3Map4growGciE(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  self.grow_at = _M0FPB21calc__grow__threshold(self.capacity);
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp = old_head;
  while (true) {
    const x = _tmp;
    if (x === undefined) {
      return;
    } else {
      const _Some = x;
      const _e = _Some;
      const next_in_chain = _e.next;
      _e.next = undefined;
      _M0MPB3Map20rehash__place__entryGciE(self, _e);
      _tmp = next_in_chain;
      continue;
    }
  }
}
function _M0MPB3Map4growGcuE(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  self.grow_at = _M0FPB21calc__grow__threshold(self.capacity);
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp = old_head;
  while (true) {
    const x = _tmp;
    if (x === undefined) {
      return;
    } else {
      const _Some = x;
      const _e = _Some;
      const next_in_chain = _e.next;
      _e.next = undefined;
      _M0MPB3Map20rehash__place__entryGcuE(self, _e);
      _tmp = next_in_chain;
      continue;
    }
  }
}
function _M0MPB3Map4growGzuE(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  self.grow_at = _M0FPB21calc__grow__threshold(self.capacity);
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp = old_head;
  while (true) {
    const x = _tmp;
    if (x === undefined) {
      return;
    } else {
      const _Some = x;
      const _e = _Some;
      const next_in_chain = _e.next;
      _e.next = undefined;
      _M0MPB3Map20rehash__place__entryGzuE(self, _e);
      _tmp = next_in_chain;
      continue;
    }
  }
}
function _M0MPB3Map15set__with__hashGiiE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      if (self.size >= self.grow_at) {
        _M0MPB3Map4growGiiE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const _bind$2 = self.tail;
      const _bind$3 = undefined;
      const entry = new _M0TPB5EntryGiiE(_bind$2, _bind$3, psl, hash, key, value);
      _M0MPB3Map20add__entry__to__tailGiiE(self, idx, entry);
      return undefined;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      if (_curr_entry.hash === hash && _curr_entry.key === key) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        if (self.size >= self.grow_at) {
          _M0MPB3Map4growGiiE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MPB3Map10push__awayGiiE(self, idx, _curr_entry);
        const _bind$2 = self.tail;
        const _bind$3 = undefined;
        const entry = new _M0TPB5EntryGiiE(_bind$2, _bind$3, psl, hash, key, value);
        _M0MPB3Map20add__entry__to__tailGiiE(self, idx, entry);
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPB3Map15set__with__hashGsRPC14json4JsonE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      if (self.size >= self.grow_at) {
        _M0MPB3Map4growGsRPC14json4JsonE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const _bind$2 = self.tail;
      const _bind$3 = undefined;
      const entry = new _M0TPB5EntryGsRPC14json4JsonE(_bind$2, _bind$3, psl, hash, key, value);
      _M0MPB3Map20add__entry__to__tailGsRPC14json4JsonE(self, idx, entry);
      return undefined;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      if (_curr_entry.hash === hash && _curr_entry.key === key) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        if (self.size >= self.grow_at) {
          _M0MPB3Map4growGsRPC14json4JsonE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MPB3Map10push__awayGsRPC14json4JsonE(self, idx, _curr_entry);
        const _bind$2 = self.tail;
        const _bind$3 = undefined;
        const entry = new _M0TPB5EntryGsRPC14json4JsonE(_bind$2, _bind$3, psl, hash, key, value);
        _M0MPB3Map20add__entry__to__tailGsRPC14json4JsonE(self, idx, entry);
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPB3Map15set__with__hashGcRPB5ArrayGiEE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      if (self.size >= self.grow_at) {
        _M0MPB3Map4growGcRPB5ArrayGiEE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const _bind$2 = self.tail;
      const _bind$3 = undefined;
      const entry = new _M0TPB5EntryGcRPB5ArrayGiEE(_bind$2, _bind$3, psl, hash, key, value);
      _M0MPB3Map20add__entry__to__tailGcRPB5ArrayGiEE(self, idx, entry);
      return undefined;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      if (_curr_entry.hash === hash && _curr_entry.key === key) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        if (self.size >= self.grow_at) {
          _M0MPB3Map4growGcRPB5ArrayGiEE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MPB3Map10push__awayGcRPB5ArrayGiEE(self, idx, _curr_entry);
        const _bind$2 = self.tail;
        const _bind$3 = undefined;
        const entry = new _M0TPB5EntryGcRPB5ArrayGiEE(_bind$2, _bind$3, psl, hash, key, value);
        _M0MPB3Map20add__entry__to__tailGcRPB5ArrayGiEE(self, idx, entry);
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPB3Map15set__with__hashGciE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      if (self.size >= self.grow_at) {
        _M0MPB3Map4growGciE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const _bind$2 = self.tail;
      const _bind$3 = undefined;
      const entry = new _M0TPB5EntryGciE(_bind$2, _bind$3, psl, hash, key, value);
      _M0MPB3Map20add__entry__to__tailGciE(self, idx, entry);
      return undefined;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      if (_curr_entry.hash === hash && _curr_entry.key === key) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        if (self.size >= self.grow_at) {
          _M0MPB3Map4growGciE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MPB3Map10push__awayGciE(self, idx, _curr_entry);
        const _bind$2 = self.tail;
        const _bind$3 = undefined;
        const entry = new _M0TPB5EntryGciE(_bind$2, _bind$3, psl, hash, key, value);
        _M0MPB3Map20add__entry__to__tailGciE(self, idx, entry);
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPB3Map15set__with__hashGcuE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      if (self.size >= self.grow_at) {
        _M0MPB3Map4growGcuE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const _bind$2 = self.tail;
      const _bind$3 = undefined;
      const entry = new _M0TPB5EntryGcuE(_bind$2, _bind$3, psl, hash, key, value);
      _M0MPB3Map20add__entry__to__tailGcuE(self, idx, entry);
      return undefined;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      if (_curr_entry.hash === hash && _curr_entry.key === key) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        if (self.size >= self.grow_at) {
          _M0MPB3Map4growGcuE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MPB3Map10push__awayGcuE(self, idx, _curr_entry);
        const _bind$2 = self.tail;
        const _bind$3 = undefined;
        const entry = new _M0TPB5EntryGcuE(_bind$2, _bind$3, psl, hash, key, value);
        _M0MPB3Map20add__entry__to__tailGcuE(self, idx, entry);
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPB3Map15set__with__hashGzuE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      if (self.size >= self.grow_at) {
        _M0MPB3Map4growGzuE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const _bind$2 = self.tail;
      const _bind$3 = undefined;
      const entry = new _M0TPB5EntryGzuE(_bind$2, _bind$3, psl, hash, key, value);
      _M0MPB3Map20add__entry__to__tailGzuE(self, idx, entry);
      return undefined;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      if (_curr_entry.hash === hash && $bytes_equal(_curr_entry.key, key)) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        if (self.size >= self.grow_at) {
          _M0MPB3Map4growGzuE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MPB3Map10push__awayGzuE(self, idx, _curr_entry);
        const _bind$2 = self.tail;
        const _bind$3 = undefined;
        const entry = new _M0TPB5EntryGzuE(_bind$2, _bind$3, psl, hash, key, value);
        _M0MPB3Map20add__entry__to__tailGzuE(self, idx, entry);
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPB3Map3setGiiE(self, key, value) {
  _M0MPB3Map15set__with__hashGiiE(self, key, value, _M0IPC13int3IntPB4Hash4hash(key));
}
function _M0MPB3Map3setGsRPC14json4JsonE(self, key, value) {
  _M0MPB3Map15set__with__hashGsRPC14json4JsonE(self, key, value, _M0IPC16string6StringPB4Hash4hash(key));
}
function _M0MPB3Map3setGcRPB5ArrayGiEE(self, key, value) {
  _M0MPB3Map15set__with__hashGcRPB5ArrayGiEE(self, key, value, _M0IPC14char4CharPB4Hash4hash(key));
}
function _M0MPB3Map3setGciE(self, key, value) {
  _M0MPB3Map15set__with__hashGciE(self, key, value, _M0IPC14char4CharPB4Hash4hash(key));
}
function _M0MPB3Map3setGcuE(self, key, value) {
  _M0MPB3Map15set__with__hashGcuE(self, key, value, _M0IPC14char4CharPB4Hash4hash(key));
}
function _M0MPB3Map3setGzuE(self, key, value) {
  _M0MPB3Map15set__with__hashGzuE(self, key, value, _M0IP016_24default__implPB4Hash4hashGzE(key));
}
function _M0MPB3Map3MapGiiE(arr, capacity) {
  const length = arr.end - arr.start | 0;
  let capacity$2;
  if (capacity === undefined) {
    capacity$2 = length === 0 ? 8 : _M0FPB21capacity__for__length(length);
  } else {
    const _Some = capacity;
    const _capacity = _Some;
    capacity$2 = _M0FPB21capacity__for__length(_capacity > length ? _capacity : length);
  }
  const m = _M0FPB8new__mapGiiE(capacity$2);
  const _bind = arr.end - arr.start | 0;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const e = arr.buf[arr.start + _ | 0];
      _M0MPB3Map3setGiiE(m, e._0, e._1);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return m;
}
function _M0MPB3Map3MapGsRPC14json4JsonE(arr, capacity) {
  const length = arr.end - arr.start | 0;
  let capacity$2;
  if (capacity === undefined) {
    capacity$2 = length === 0 ? 8 : _M0FPB21capacity__for__length(length);
  } else {
    const _Some = capacity;
    const _capacity = _Some;
    capacity$2 = _M0FPB21capacity__for__length(_capacity > length ? _capacity : length);
  }
  const m = _M0FPB8new__mapGsRPC14json4JsonE(capacity$2);
  const _bind = arr.end - arr.start | 0;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const e = arr.buf[arr.start + _ | 0];
      _M0MPB3Map3setGsRPC14json4JsonE(m, e._0, e._1);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return m;
}
function _M0MPB3Map3MapGcRPB5ArrayGiEE(arr, capacity) {
  const length = arr.end - arr.start | 0;
  let capacity$2;
  if (capacity === undefined) {
    capacity$2 = length === 0 ? 8 : _M0FPB21capacity__for__length(length);
  } else {
    const _Some = capacity;
    const _capacity = _Some;
    capacity$2 = _M0FPB21capacity__for__length(_capacity > length ? _capacity : length);
  }
  const m = _M0FPB8new__mapGcRPB5ArrayGiEE(capacity$2);
  const _bind = arr.end - arr.start | 0;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const e = arr.buf[arr.start + _ | 0];
      _M0MPB3Map3setGcRPB5ArrayGiEE(m, e._0, e._1);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return m;
}
function _M0MPB3Map3MapGciE(arr, capacity) {
  const length = arr.end - arr.start | 0;
  let capacity$2;
  if (capacity === undefined) {
    capacity$2 = length === 0 ? 8 : _M0FPB21capacity__for__length(length);
  } else {
    const _Some = capacity;
    const _capacity = _Some;
    capacity$2 = _M0FPB21capacity__for__length(_capacity > length ? _capacity : length);
  }
  const m = _M0FPB8new__mapGciE(capacity$2);
  const _bind = arr.end - arr.start | 0;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const e = arr.buf[arr.start + _ | 0];
      _M0MPB3Map3setGciE(m, e._0, e._1);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return m;
}
function _M0MPB3Map3MapGcuE(arr, capacity) {
  const length = arr.end - arr.start | 0;
  let capacity$2;
  if (capacity === undefined) {
    capacity$2 = length === 0 ? 8 : _M0FPB21capacity__for__length(length);
  } else {
    const _Some = capacity;
    const _capacity = _Some;
    capacity$2 = _M0FPB21capacity__for__length(_capacity > length ? _capacity : length);
  }
  const m = _M0FPB8new__mapGcuE(capacity$2);
  const _bind = arr.end - arr.start | 0;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const e = arr.buf[arr.start + _ | 0];
      _M0MPB3Map3setGcuE(m, e._0, e._1);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return m;
}
function _M0MPB3Map3MapGzuE(arr, capacity) {
  const length = arr.end - arr.start | 0;
  let capacity$2;
  if (capacity === undefined) {
    capacity$2 = length === 0 ? 8 : _M0FPB21capacity__for__length(length);
  } else {
    const _Some = capacity;
    const _capacity = _Some;
    capacity$2 = _M0FPB21capacity__for__length(_capacity > length ? _capacity : length);
  }
  const m = _M0FPB8new__mapGzuE(capacity$2);
  const _bind = arr.end - arr.start | 0;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const e = arr.buf[arr.start + _ | 0];
      _M0MPB3Map3setGzuE(m, e._0, e._1);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return m;
}
function _M0MPB3Map3getGiiE(self, key) {
  const hash = _M0IPC13int3IntPB4Hash4hash(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      return undefined;
    } else {
      const _Some = _bind;
      const _entry = _Some;
      if (_entry.hash === hash && _entry.key === key) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPB3Map3getGsRPC14json4JsonE(self, key) {
  const hash = _M0IPC16string6StringPB4Hash4hash(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      return undefined;
    } else {
      const _Some = _bind;
      const _entry = _Some;
      if (_entry.hash === hash && _entry.key === key) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPB3Map3getGcRPB5ArrayGiEE(self, key) {
  const hash = _M0IPC14char4CharPB4Hash4hash(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      return undefined;
    } else {
      const _Some = _bind;
      const _entry = _Some;
      if (_entry.hash === hash && _entry.key === key) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPB3Map3getGciE(self, key) {
  const hash = _M0IPC14char4CharPB4Hash4hash(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      return undefined;
    } else {
      const _Some = _bind;
      const _entry = _Some;
      if (_entry.hash === hash && _entry.key === key) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPB3Map8containsGcuE(self, key) {
  const hash = _M0IPC14char4CharPB4Hash4hash(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      return false;
    } else {
      const _Some = _bind;
      const _entry = _Some;
      if (_entry.hash === hash && _entry.key === key) {
        return true;
      }
      if (i > _entry.psl) {
        return false;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPB3Map8containsGzuE(self, key) {
  const hash = _M0IP016_24default__implPB4Hash4hashGzE(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      return false;
    } else {
      const _Some = _bind;
      const _entry = _Some;
      if (_entry.hash === hash && $bytes_equal(_entry.key, key)) {
        return true;
      }
      if (i > _entry.psl) {
        return false;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPB3Map13remove__entryGcRPB5ArrayGiEE(self, entry) {
  const _bind = entry.prev;
  if (_bind === -1) {
    self.head = entry.next;
  } else {
    const _tmp = self.entries;
    const _p = _bind >>> 0 < _tmp.length ? _tmp[_bind] : $oob();
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    _tmp$2.next = entry.next;
  }
  const _bind$2 = entry.next;
  if (_bind$2 === undefined) {
    self.tail = entry.prev;
    return;
  } else {
    const _Some = _bind$2;
    const _next = _Some;
    _next.prev = entry.prev;
    return;
  }
}
function _M0MPB3Map11shift__backGcRPB5ArrayGiEE(self, idx) {
  let _tmp = idx;
  while (true) {
    const cur = _tmp;
    const next = cur + 1 & self.capacity_mask;
    _L: {
      const _bind = self.entries[next];
      if (_bind === undefined) {
        break _L;
      } else {
        const _Some = _bind;
        const _x = _Some;
        const _x$2 = _x.psl;
        if (_x$2 === 0) {
          break _L;
        } else {
          _x.psl = _x.psl - 1 | 0;
          _M0MPB3Map10set__entryGcRPB5ArrayGiEE(self, _x, cur);
          _tmp = next;
          continue;
        }
      }
    }
    self.entries[cur] = undefined;
    return;
  }
}
function _M0MPB3Map18remove__with__hashGcRPB5ArrayGiEE(self, key, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      return;
    } else {
      const _Some = _bind;
      const _entry = _Some;
      if (_entry.hash === hash && _entry.key === key) {
        _M0MPB3Map13remove__entryGcRPB5ArrayGiEE(self, _entry);
        _M0MPB3Map11shift__backGcRPB5ArrayGiEE(self, idx);
        self.size = self.size - 1 | 0;
        return;
      }
      if (i > _entry.psl) {
        return;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPB3Map6removeGcRPB5ArrayGiEE(self, key) {
  _M0MPB3Map18remove__with__hashGcRPB5ArrayGiEE(self, key, _M0IPC14char4CharPB4Hash4hash(key));
}
function _M0MPB3Map4iterGsRPC14json4JsonE(self) {
  const curr_entry = new _M0TPB8MutLocalGORPB5EntryGsRPC14json4JsonEE(self.head);
  const len = self.size;
  const remaining = new _M0TPB8MutLocalGiE(len);
  return _M0MPB4Iter3newGUcRPB5ArrayGiEEE(() => {
    _L: {
      if (remaining.val > 0) {
        const _bind = curr_entry.val;
        if (_bind === undefined) {
          break _L;
        } else {
          const _Some = _bind;
          const _x = _Some;
          const _key = _x.key;
          const _value = _x.value;
          const _next = _x.next;
          curr_entry.val = _next;
          remaining.val = remaining.val - 1 | 0;
          return { _0: _key, _1: _value };
        }
      } else {
        break _L;
      }
    }
    return undefined;
  }, len);
}
function _M0MPB3Map4iterGcRPB5ArrayGiEE(self) {
  const curr_entry = new _M0TPB8MutLocalGORPB5EntryGcRPB5ArrayGiEEE(self.head);
  const len = self.size;
  const remaining = new _M0TPB8MutLocalGiE(len);
  return _M0MPB4Iter3newGUcRPB5ArrayGiEEE(() => {
    _L: {
      if (remaining.val > 0) {
        const _bind = curr_entry.val;
        if (_bind === undefined) {
          break _L;
        } else {
          const _Some = _bind;
          const _x = _Some;
          const _key = _x.key;
          const _value = _x.value;
          const _next = _x.next;
          curr_entry.val = _next;
          remaining.val = remaining.val - 1 | 0;
          return { _0: _key, _1: _value };
        }
      } else {
        break _L;
      }
    }
    return undefined;
  }, len);
}
function _M0MPB3Map4iterGciE(self) {
  const curr_entry = new _M0TPB8MutLocalGORPB5EntryGciEE(self.head);
  const len = self.size;
  const remaining = new _M0TPB8MutLocalGiE(len);
  return _M0MPB4Iter3newGUcRPB5ArrayGiEEE(() => {
    _L: {
      if (remaining.val > 0) {
        const _bind = curr_entry.val;
        if (_bind === undefined) {
          break _L;
        } else {
          const _Some = _bind;
          const _x = _Some;
          const _key = _x.key;
          const _value = _x.value;
          const _next = _x.next;
          curr_entry.val = _next;
          remaining.val = remaining.val - 1 | 0;
          return { _0: _key, _1: _value };
        }
      } else {
        break _L;
      }
    }
    return undefined;
  }, len);
}
function _M0MPB3Map5iter2GsRPC14json4JsonE(self) {
  return _M0MPB3Map4iterGsRPC14json4JsonE(self);
}
function _M0MPB3Map4keysGcuE(self) {
  const curr_entry = new _M0TPB8MutLocalGORPB5EntryGcuEE(self.head);
  const len = self.size;
  const remaining = new _M0TPB8MutLocalGiE(len);
  return _M0MPB4Iter3newGcE(() => {
    _L: {
      if (remaining.val > 0) {
        const _bind = curr_entry.val;
        if (_bind === undefined) {
          break _L;
        } else {
          const _Some = _bind;
          const _x = _Some;
          const _key = _x.key;
          const _next = _x.next;
          curr_entry.val = _next;
          remaining.val = remaining.val - 1 | 0;
          return _key;
        }
      } else {
        break _L;
      }
    }
    return -1;
  }, len);
}
function _M0MPB5Iter24nextGsRPC14json4JsonE(self) {
  return _M0MPB4Iter4nextGUcRPB5ArrayGiEEE(self);
}
function _M0MPB6Hasher8consume1(self, input) {
  const _p = (self.acc >>> 0) + ((Math.imul(input, 374761393) | 0) >>> 0) | 0;
  self.acc = Math.imul(_p << 11 | (_p >>> 21 | 0), -1640531535) | 0;
}
function _M0MPB6Hasher13combine__byte(self, value) {
  _M0MPB6Hasher8consume1(self, value);
}
function _M0IPC16string6StringPB4Hash4hash(self) {
  let acc = (_M0FPB4seed >>> 0) + (374761393 >>> 0) | 0;
  const _bind = self.length;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      acc = (acc >>> 0) + (4 >>> 0) | 0;
      const v = self.charCodeAt(i);
      acc = _M0FPB13consume4__acc(acc, v);
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return _M0FPB13finalize__acc(acc);
}
function _M0IPC13int3IntPB4Hash13hash__combine(self, hasher) {
  _M0MPB6Hasher12combine__int(hasher, self);
}
function _M0IPC13int3IntPB4Hash4hash(self) {
  const acc = (((_M0FPB4seed >>> 0) + (374761393 >>> 0) | 0) >>> 0) + (4 >>> 0) | 0;
  return _M0FPB13finalize__acc(_M0FPB13consume4__acc(acc, self));
}
function _M0IPC14uint4UIntPB4Hash4hash(self) {
  const acc = (((_M0FPB4seed >>> 0) + (374761393 >>> 0) | 0) >>> 0) + (4 >>> 0) | 0;
  return _M0FPB13finalize__acc(_M0FPB13consume4__acc(acc, self));
}
function _M0IPC15bytes9BytesViewPB4Hash13hash__combine(self, hasher) {
  const _bind = self.buf;
  const _bind$2 = self.start;
  const _bind$3 = self.end;
  let _tmp = _bind$2;
  while (true) {
    const data_start = _tmp;
    if ((_bind$3 - data_start | 0) >= 4) {
      const _x = _M0MPC15bytes5Bytes24unsafe__read__uint32__le(_bind, data_start);
      const _bind$4 = data_start + 4 | 0;
      _M0MPB6Hasher13combine__uint(hasher, _x);
      _tmp = _bind$4;
      continue;
    } else {
      if ((_bind$3 - data_start | 0) >= 1) {
        const _b0 = _bind[data_start];
        const _x_start = data_start + 1 | 0;
        _M0MPB6Hasher13combine__byte(hasher, _b0);
        if ((_bind$3 - _x_start | 0) >= 1) {
          const _b1 = _bind[_x_start];
          const _x_start$2 = _x_start + 1 | 0;
          _M0MPB6Hasher13combine__byte(hasher, _b1);
          if ((_bind$3 - _x_start$2 | 0) >= 1) {
            const _b2 = _bind[_x_start$2];
            _M0MPB6Hasher13combine__byte(hasher, _b2);
          }
        }
      }
      return;
    }
  }
}
function _M0MPC16double6Double7to__int(self) {
  return self !== self ? 0 : self >= 2147483647 ? 2147483647 : self <= -2147483648 ? -2147483648 : self | 0;
}
function _M0MPC16double6Double4ceil(_tmp) {
  return Math.ceil(_tmp);
}
function _M0MPC16double6Double5round(_tmp) {
  return Math.round(_tmp);
}
function _M0IPC16double6DoublePB4Show10to__string(self) {
  return String(self);
}
function _M0IPC14char4CharPB4Hash4hash(self) {
  return _M0IPC14uint4UIntPB4Hash4hash(self);
}
function _M0MPC15bytes5Bytes21clamped__view_2einner(self, start, end) {
  const len = self.length;
  const lo = start < 0 ? 0 : start > len ? len : start;
  let hi;
  if (end === undefined) {
    hi = len;
  } else {
    const _Some = end;
    const _end = _Some;
    hi = _end < 0 ? 0 : _end > len ? len : _end;
  }
  const hi$2 = hi > lo ? hi : lo;
  return new _M0TPC15bytes9BytesView(self, lo, hi$2);
}
function _M0MPC15bytes5Bytes24unsafe__read__uint32__le(bytes, index) {
  const _p = bytes[index];
  const _p$2 = bytes[index + 1 | 0];
  const _tmp = _p | _p$2 << 8;
  const _p$3 = bytes[index + 2 | 0];
  const _tmp$2 = _tmp | _p$3 << 16;
  const _p$4 = bytes[index + 3 | 0];
  return _tmp$2 | _p$4 << 24;
}
function _M0MPC15bytes5Bytes11from__array(arr) {
  const len = arr.end - arr.start | 0;
  if (len === 0) {
    return $bytes_literal$0;
  }
  const result = _M0MPB18UninitializedArray23unsafe__make__and__blitGyE(arr.buf, len, arr.start, 0, len);
  return result;
}
function _M0IPC15bytes5BytesPB4Hash13hash__combine(self, hasher) {
  _M0MPB6Hasher7combineGRPC15bytes9BytesViewE(hasher, new _M0TPC15bytes9BytesView(self, 0, self.length));
}
function _M0FPB23index__out__of__bounds2GuE(len, i, j) {
  const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(64);
  _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "index out of bounds: the len is from 0 to ");
  _M0MPB13StringBuilder13write__objectGiE(_string_builder, len);
  _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, " but the index is (");
  _M0MPB13StringBuilder13write__objectGiE(_string_builder, i);
  _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", ");
  _M0MPB13StringBuilder13write__objectGiE(_string_builder, j);
  _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ")");
  $panic(_string_builder.val);
}
function _M0MPC15array12MutArrayView4swapGUciEE(arr, i, j) {
  const temp = arr.buf[arr.start + i | 0];
  arr.buf[arr.start + i | 0] = arr.buf[arr.start + j | 0];
  arr.buf[arr.start + j | 0] = temp;
}
function _M0MPC15array12MutArrayView4swapGiE(arr, i, j) {
  const temp = arr.buf[arr.start + i | 0];
  arr.buf[arr.start + i | 0] = arr.buf[arr.start + j | 0];
  arr.buf[arr.start + j | 0] = temp;
}
function _M0MPC15array12MutArrayView5sliceGUciEE(arr, start, end) {
  const _bind = arr.end - arr.start | 0;
  if (start < 0 || (start > end || end > _bind)) {
    $panic();
  }
  return new _M0TPB12MutArrayViewGUciEE(arr.buf, start + arr.start | 0, end + arr.start | 0);
}
function _M0MPC15array12MutArrayView5sliceGiE(arr, start, end) {
  const _bind = arr.end - arr.start | 0;
  if (start < 0 || (start > end || end > _bind)) {
    $panic();
  }
  return new _M0TPB12MutArrayViewGiE(arr.buf, start + arr.start | 0, end + arr.start | 0);
}
function _M0MPC15array12MutArrayView14rev__in__placeGUciEE(arr) {
  const len = arr.end - arr.start | 0;
  const mid_len = len / 2 | 0;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < mid_len) {
      const j = (len - i | 0) - 1 | 0;
      const temp = arr.buf[arr.start + i | 0];
      arr.buf[arr.start + i | 0] = arr.buf[arr.start + j | 0];
      arr.buf[arr.start + j | 0] = temp;
      _tmp = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0MPC15array12MutArrayView14rev__in__placeGiE(arr) {
  const len = arr.end - arr.start | 0;
  const mid_len = len / 2 | 0;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < mid_len) {
      const j = (len - i | 0) - 1 | 0;
      const temp = arr.buf[arr.start + i | 0];
      arr.buf[arr.start + i | 0] = arr.buf[arr.start + j | 0];
      arr.buf[arr.start + j | 0] = temp;
      _tmp = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FPB17fixed__get__limit(len) {
  let _tmp = len;
  let _tmp$2 = 0;
  while (true) {
    const len$2 = _tmp;
    const limit = _tmp$2;
    if (len$2 > 0) {
      _tmp = len$2 / 2 | 0;
      _tmp$2 = limit + 1 | 0;
      continue;
    } else {
      return limit;
    }
  }
}
function _M0FPB23fixed__bubble__sort__byGUciEE(arr, cmp) {
  const _bind = arr.end - arr.start | 0;
  let _tmp = 1;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      let _tmp$2 = i;
      while (true) {
        const j = _tmp$2;
        if (j > 0 && cmp(arr.buf[arr.start + (j - 1 | 0) | 0], arr.buf[arr.start + j | 0]) > 0) {
          _M0MPC15array12MutArrayView4swapGUciEE(arr, j, j - 1 | 0);
          _tmp$2 = j - 1 | 0;
          continue;
        } else {
          break;
        }
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FPB23fixed__bubble__sort__byGiE(arr, cmp) {
  const _bind = arr.end - arr.start | 0;
  let _tmp = 1;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      let _tmp$2 = i;
      while (true) {
        const j = _tmp$2;
        if (j > 0 && cmp(arr.buf[arr.start + (j - 1 | 0) | 0], arr.buf[arr.start + j | 0]) > 0) {
          _M0MPC15array12MutArrayView4swapGiE(arr, j, j - 1 | 0);
          _tmp$2 = j - 1 | 0;
          continue;
        } else {
          break;
        }
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FPB24fixed__choose__pivot__byN7sort__2S1981GUciEE(_env, a, b) {
  const swaps = _env._2;
  const cmp = _env._1;
  const arr = _env._0;
  if (cmp(arr.buf[arr.start + a | 0], arr.buf[arr.start + b | 0]) > 0) {
    _M0MPC15array12MutArrayView4swapGUciEE(arr, a, b);
    swaps.val = swaps.val + 1 | 0;
    return;
  } else {
    return;
  }
}
function _M0FPB24fixed__choose__pivot__byN7sort__3S1982GUciEE(_env, a, b, c) {
  _M0FPB24fixed__choose__pivot__byN7sort__2S1981GUciEE(_env, a, b);
  _M0FPB24fixed__choose__pivot__byN7sort__2S1981GUciEE(_env, b, c);
  _M0FPB24fixed__choose__pivot__byN7sort__2S1981GUciEE(_env, a, b);
}
function _M0FPB24fixed__choose__pivot__byN7sort__2S2021GiE(_env, a, b) {
  const swaps = _env._2;
  const cmp = _env._1;
  const arr = _env._0;
  if (cmp(arr.buf[arr.start + a | 0], arr.buf[arr.start + b | 0]) > 0) {
    _M0MPC15array12MutArrayView4swapGiE(arr, a, b);
    swaps.val = swaps.val + 1 | 0;
    return;
  } else {
    return;
  }
}
function _M0FPB24fixed__choose__pivot__byN7sort__3S2022GiE(_env, a, b, c) {
  _M0FPB24fixed__choose__pivot__byN7sort__2S2021GiE(_env, a, b);
  _M0FPB24fixed__choose__pivot__byN7sort__2S2021GiE(_env, b, c);
  _M0FPB24fixed__choose__pivot__byN7sort__2S2021GiE(_env, a, b);
}
function _M0FPB24fixed__choose__pivot__byGUciEE(arr, cmp) {
  const len = arr.end - arr.start | 0;
  const swaps = new _M0TPB8MutLocalGiE(0);
  const b = Math.imul(len / 4 | 0, 2) | 0;
  if (len >= 8) {
    const a = Math.imul(len / 4 | 0, 1) | 0;
    const c = Math.imul(len / 4 | 0, 3) | 0;
    const _env = { _0: arr, _1: cmp, _2: swaps };
    if (len > 50) {
      _M0FPB24fixed__choose__pivot__byN7sort__3S1982GUciEE(_env, a - 1 | 0, a, a + 1 | 0);
      _M0FPB24fixed__choose__pivot__byN7sort__3S1982GUciEE(_env, b - 1 | 0, b, b + 1 | 0);
      _M0FPB24fixed__choose__pivot__byN7sort__3S1982GUciEE(_env, c - 1 | 0, c, c + 1 | 0);
    }
    _M0FPB24fixed__choose__pivot__byN7sort__3S1982GUciEE(_env, a, b, c);
  }
  if (swaps.val === 12) {
    _M0MPC15array12MutArrayView14rev__in__placeGUciEE(arr);
    return { _0: (len - b | 0) - 1 | 0, _1: true };
  } else {
    return { _0: b, _1: swaps.val === 0 };
  }
}
function _M0FPB24fixed__choose__pivot__byGiE(arr, cmp) {
  const len = arr.end - arr.start | 0;
  const swaps = new _M0TPB8MutLocalGiE(0);
  const b = Math.imul(len / 4 | 0, 2) | 0;
  if (len >= 8) {
    const a = Math.imul(len / 4 | 0, 1) | 0;
    const c = Math.imul(len / 4 | 0, 3) | 0;
    const _env = { _0: arr, _1: cmp, _2: swaps };
    if (len > 50) {
      _M0FPB24fixed__choose__pivot__byN7sort__3S2022GiE(_env, a - 1 | 0, a, a + 1 | 0);
      _M0FPB24fixed__choose__pivot__byN7sort__3S2022GiE(_env, b - 1 | 0, b, b + 1 | 0);
      _M0FPB24fixed__choose__pivot__byN7sort__3S2022GiE(_env, c - 1 | 0, c, c + 1 | 0);
    }
    _M0FPB24fixed__choose__pivot__byN7sort__3S2022GiE(_env, a, b, c);
  }
  if (swaps.val === 12) {
    _M0MPC15array12MutArrayView14rev__in__placeGiE(arr);
    return { _0: (len - b | 0) - 1 | 0, _1: true };
  } else {
    return { _0: b, _1: swaps.val === 0 };
  }
}
function _M0FPB21fixed__sift__down__byGUciEE(arr, index, cmp) {
  const len = arr.end - arr.start | 0;
  let _tmp = index;
  let _tmp$2 = (Math.imul(index, 2) | 0) + 1 | 0;
  while (true) {
    const index$2 = _tmp;
    const child = _tmp$2;
    if (child < len) {
      const child$2 = (child + 1 | 0) < len && cmp(arr.buf[arr.start + child | 0], arr.buf[arr.start + (child + 1 | 0) | 0]) < 0 ? child + 1 | 0 : child;
      if (cmp(arr.buf[arr.start + index$2 | 0], arr.buf[arr.start + child$2 | 0]) >= 0) {
        return undefined;
      }
      _M0MPC15array12MutArrayView4swapGUciEE(arr, index$2, child$2);
      _tmp = child$2;
      _tmp$2 = (Math.imul(child$2, 2) | 0) + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FPB21fixed__sift__down__byGiE(arr, index, cmp) {
  const len = arr.end - arr.start | 0;
  let _tmp = index;
  let _tmp$2 = (Math.imul(index, 2) | 0) + 1 | 0;
  while (true) {
    const index$2 = _tmp;
    const child = _tmp$2;
    if (child < len) {
      const child$2 = (child + 1 | 0) < len && cmp(arr.buf[arr.start + child | 0], arr.buf[arr.start + (child + 1 | 0) | 0]) < 0 ? child + 1 | 0 : child;
      if (cmp(arr.buf[arr.start + index$2 | 0], arr.buf[arr.start + child$2 | 0]) >= 0) {
        return undefined;
      }
      _M0MPC15array12MutArrayView4swapGiE(arr, index$2, child$2);
      _tmp = child$2;
      _tmp$2 = (Math.imul(child$2, 2) | 0) + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FPB21fixed__heap__sort__byGUciEE(arr, cmp) {
  const len = arr.end - arr.start | 0;
  const _bind = len / 2 | 0;
  let _tmp = _bind - 1 | 0;
  let _tmp$2 = _bind > 0;
  while (true) {
    const i = _tmp;
    const _more = _tmp$2;
    if (_more) {
      _M0FPB21fixed__sift__down__byGUciEE(arr, i, cmp);
      _tmp = i - 1 | 0;
      _tmp$2 = i > 0;
      continue;
    } else {
      break;
    }
  }
  let _tmp$3 = len - 1 | 0;
  let _tmp$4 = len > 1;
  while (true) {
    const i = _tmp$3;
    const _more = _tmp$4;
    if (_more) {
      _M0MPC15array12MutArrayView4swapGUciEE(arr, 0, i);
      _M0FPB21fixed__sift__down__byGUciEE(_M0MPC15array12MutArrayView5sliceGUciEE(arr, 0, i), 0, cmp);
      _tmp$3 = i - 1 | 0;
      _tmp$4 = i > 1;
      continue;
    } else {
      return;
    }
  }
}
function _M0FPB21fixed__heap__sort__byGiE(arr, cmp) {
  const len = arr.end - arr.start | 0;
  const _bind = len / 2 | 0;
  let _tmp = _bind - 1 | 0;
  let _tmp$2 = _bind > 0;
  while (true) {
    const i = _tmp;
    const _more = _tmp$2;
    if (_more) {
      _M0FPB21fixed__sift__down__byGiE(arr, i, cmp);
      _tmp = i - 1 | 0;
      _tmp$2 = i > 0;
      continue;
    } else {
      break;
    }
  }
  let _tmp$3 = len - 1 | 0;
  let _tmp$4 = len > 1;
  while (true) {
    const i = _tmp$3;
    const _more = _tmp$4;
    if (_more) {
      _M0MPC15array12MutArrayView4swapGiE(arr, 0, i);
      _M0FPB21fixed__sift__down__byGiE(_M0MPC15array12MutArrayView5sliceGiE(arr, 0, i), 0, cmp);
      _tmp$3 = i - 1 | 0;
      _tmp$4 = i > 1;
      continue;
    } else {
      return;
    }
  }
}
function _M0FPB20fixed__partition__byGUciEE(arr, cmp, pivot_index) {
  _M0MPC15array12MutArrayView4swapGUciEE(arr, pivot_index, (arr.end - arr.start | 0) - 1 | 0);
  const pivot = arr.buf[arr.start + ((arr.end - arr.start | 0) - 1 | 0) | 0];
  const _bind = (arr.end - arr.start | 0) - 1 | 0;
  let _tmp = 0;
  let _tmp$2 = 0;
  let _tmp$3 = true;
  while (true) {
    const j = _tmp;
    const i = _tmp$2;
    const partitioned = _tmp$3;
    if (j < _bind) {
      if (cmp(arr.buf[arr.start + j | 0], pivot) < 0) {
        if (i !== j) {
          _M0MPC15array12MutArrayView4swapGUciEE(arr, i, j);
          _tmp = j + 1 | 0;
          _tmp$2 = i + 1 | 0;
          _tmp$3 = false;
          continue;
        } else {
          _tmp = j + 1 | 0;
          _tmp$2 = i + 1 | 0;
          continue;
        }
      } else {
        _tmp = j + 1 | 0;
        continue;
      }
    } else {
      _M0MPC15array12MutArrayView4swapGUciEE(arr, i, (arr.end - arr.start | 0) - 1 | 0);
      return { _0: i, _1: partitioned };
    }
  }
}
function _M0FPB20fixed__partition__byGiE(arr, cmp, pivot_index) {
  _M0MPC15array12MutArrayView4swapGiE(arr, pivot_index, (arr.end - arr.start | 0) - 1 | 0);
  const pivot = arr.buf[arr.start + ((arr.end - arr.start | 0) - 1 | 0) | 0];
  const _bind = (arr.end - arr.start | 0) - 1 | 0;
  let _tmp = 0;
  let _tmp$2 = 0;
  let _tmp$3 = true;
  while (true) {
    const j = _tmp;
    const i = _tmp$2;
    const partitioned = _tmp$3;
    if (j < _bind) {
      if (cmp(arr.buf[arr.start + j | 0], pivot) < 0) {
        if (i !== j) {
          _M0MPC15array12MutArrayView4swapGiE(arr, i, j);
          _tmp = j + 1 | 0;
          _tmp$2 = i + 1 | 0;
          _tmp$3 = false;
          continue;
        } else {
          _tmp = j + 1 | 0;
          _tmp$2 = i + 1 | 0;
          continue;
        }
      } else {
        _tmp = j + 1 | 0;
        continue;
      }
    } else {
      _M0MPC15array12MutArrayView4swapGiE(arr, i, (arr.end - arr.start | 0) - 1 | 0);
      return { _0: i, _1: partitioned };
    }
  }
}
function _M0FPB28fixed__try__bubble__sort__byGUciEE(arr, cmp) {
  const _bind = arr.end - arr.start | 0;
  let _tmp = 1;
  let _tmp$2 = 0;
  while (true) {
    const i = _tmp;
    const tries = _tmp$2;
    if (i < _bind) {
      let sorted;
      let _tmp$3 = i;
      let _tmp$4 = true;
      while (true) {
        const j = _tmp$3;
        const sorted$2 = _tmp$4;
        if (j > 0 && cmp(arr.buf[arr.start + (j - 1 | 0) | 0], arr.buf[arr.start + j | 0]) > 0) {
          _M0MPC15array12MutArrayView4swapGUciEE(arr, j, j - 1 | 0);
          _tmp$3 = j - 1 | 0;
          _tmp$4 = false;
          continue;
        } else {
          sorted = sorted$2;
          break;
        }
      }
      if (!sorted) {
        const tries$2 = tries + 1 | 0;
        if (tries$2 > 8) {
          return false;
        }
        _tmp = i + 1 | 0;
        _tmp$2 = tries$2;
        continue;
      } else {
        _tmp = i + 1 | 0;
        continue;
      }
    } else {
      return true;
    }
  }
}
function _M0FPB28fixed__try__bubble__sort__byGiE(arr, cmp) {
  const _bind = arr.end - arr.start | 0;
  let _tmp = 1;
  let _tmp$2 = 0;
  while (true) {
    const i = _tmp;
    const tries = _tmp$2;
    if (i < _bind) {
      let sorted;
      let _tmp$3 = i;
      let _tmp$4 = true;
      while (true) {
        const j = _tmp$3;
        const sorted$2 = _tmp$4;
        if (j > 0 && cmp(arr.buf[arr.start + (j - 1 | 0) | 0], arr.buf[arr.start + j | 0]) > 0) {
          _M0MPC15array12MutArrayView4swapGiE(arr, j, j - 1 | 0);
          _tmp$3 = j - 1 | 0;
          _tmp$4 = false;
          continue;
        } else {
          sorted = sorted$2;
          break;
        }
      }
      if (!sorted) {
        const tries$2 = tries + 1 | 0;
        if (tries$2 > 8) {
          return false;
        }
        _tmp = i + 1 | 0;
        _tmp$2 = tries$2;
        continue;
      } else {
        _tmp = i + 1 | 0;
        continue;
      }
    } else {
      return true;
    }
  }
}
function _M0FPB22fixed__quick__sort__byGUciEE(arr, cmp, pred, limit) {
  let _tmp = limit;
  let _tmp$2 = arr;
  let _tmp$3 = pred;
  let _tmp$4 = true;
  let _tmp$5 = true;
  while (true) {
    const limit$2 = _tmp;
    const arr$2 = _tmp$2;
    const pred$2 = _tmp$3;
    const was_partitioned = _tmp$4;
    const balanced = _tmp$5;
    const len = arr$2.end - arr$2.start | 0;
    if (len <= 16) {
      if (len >= 2) {
        _M0FPB23fixed__bubble__sort__byGUciEE(arr$2, cmp);
      }
      return undefined;
    }
    if (limit$2 === 0) {
      _M0FPB21fixed__heap__sort__byGUciEE(arr$2, cmp);
      return undefined;
    }
    const _bind = _M0FPB24fixed__choose__pivot__byGUciEE(arr$2, cmp);
    const _pivot_index = _bind._0;
    const _likely_sorted = _bind._1;
    if (was_partitioned && (balanced && _likely_sorted)) {
      if (_M0FPB28fixed__try__bubble__sort__byGUciEE(arr$2, cmp)) {
        return undefined;
      }
    }
    const _bind$2 = _M0FPB20fixed__partition__byGUciEE(arr$2, cmp, _pivot_index);
    const _pivot = _bind$2._0;
    const _partitioned = _bind$2._1;
    const _p = len - _pivot | 0;
    const balanced$2 = (_pivot > _p ? _p : _pivot) >= (len / 8 | 0);
    const limit$3 = !balanced$2 ? limit$2 - 1 | 0 : limit$2;
    if (pred$2 === undefined) {
    } else {
      const _Some = pred$2;
      const _p$2 = _Some;
      if (cmp(_p$2, arr$2.buf[arr$2.start + _pivot | 0]) === 0) {
        let i;
        let _tmp$6 = _pivot;
        while (true) {
          const i$2 = _tmp$6;
          if (i$2 < len && cmp(_p$2, arr$2.buf[arr$2.start + i$2 | 0]) === 0) {
            _tmp$6 = i$2 + 1 | 0;
            continue;
          } else {
            i = i$2;
            break;
          }
        }
        _tmp = limit$3;
        _tmp$2 = _M0MPC15array12MutArrayView5sliceGUciEE(arr$2, i, len);
        _tmp$4 = _partitioned;
        _tmp$5 = balanced$2;
        continue;
      }
    }
    const left = _M0MPC15array12MutArrayView5sliceGUciEE(arr$2, 0, _pivot);
    const right = _M0MPC15array12MutArrayView5sliceGUciEE(arr$2, _pivot + 1 | 0, len);
    if ((left.end - left.start | 0) < (right.end - right.start | 0)) {
      _M0FPB22fixed__quick__sort__byGUciEE(left, cmp, pred$2, limit$3);
      _tmp = limit$3;
      _tmp$2 = right;
      _tmp$3 = arr$2.buf[arr$2.start + _pivot | 0];
      _tmp$4 = _partitioned;
      _tmp$5 = balanced$2;
      continue;
    } else {
      _M0FPB22fixed__quick__sort__byGUciEE(right, cmp, arr$2.buf[arr$2.start + _pivot | 0], limit$3);
      _tmp = limit$3;
      _tmp$2 = left;
      _tmp$4 = _partitioned;
      _tmp$5 = balanced$2;
      continue;
    }
  }
}
function _M0FPB22fixed__quick__sort__byGiE(arr, cmp, pred, limit) {
  let _tmp = limit;
  let _tmp$2 = arr;
  let _tmp$3 = pred;
  let _tmp$4 = true;
  let _tmp$5 = true;
  while (true) {
    const limit$2 = _tmp;
    const arr$2 = _tmp$2;
    const pred$2 = _tmp$3;
    const was_partitioned = _tmp$4;
    const balanced = _tmp$5;
    const len = arr$2.end - arr$2.start | 0;
    if (len <= 16) {
      if (len >= 2) {
        _M0FPB23fixed__bubble__sort__byGiE(arr$2, cmp);
      }
      return undefined;
    }
    if (limit$2 === 0) {
      _M0FPB21fixed__heap__sort__byGiE(arr$2, cmp);
      return undefined;
    }
    const _bind = _M0FPB24fixed__choose__pivot__byGiE(arr$2, cmp);
    const _pivot_index = _bind._0;
    const _likely_sorted = _bind._1;
    if (was_partitioned && (balanced && _likely_sorted)) {
      if (_M0FPB28fixed__try__bubble__sort__byGiE(arr$2, cmp)) {
        return undefined;
      }
    }
    const _bind$2 = _M0FPB20fixed__partition__byGiE(arr$2, cmp, _pivot_index);
    const _pivot = _bind$2._0;
    const _partitioned = _bind$2._1;
    const _p = len - _pivot | 0;
    const balanced$2 = (_pivot > _p ? _p : _pivot) >= (len / 8 | 0);
    const limit$3 = !balanced$2 ? limit$2 - 1 | 0 : limit$2;
    if (pred$2 === undefined) {
    } else {
      const _Some = pred$2;
      const _p$2 = _Some;
      if (cmp(_p$2, arr$2.buf[arr$2.start + _pivot | 0]) === 0) {
        let i;
        let _tmp$6 = _pivot;
        while (true) {
          const i$2 = _tmp$6;
          if (i$2 < len && cmp(_p$2, arr$2.buf[arr$2.start + i$2 | 0]) === 0) {
            _tmp$6 = i$2 + 1 | 0;
            continue;
          } else {
            i = i$2;
            break;
          }
        }
        _tmp = limit$3;
        _tmp$2 = _M0MPC15array12MutArrayView5sliceGiE(arr$2, i, len);
        _tmp$4 = _partitioned;
        _tmp$5 = balanced$2;
        continue;
      }
    }
    const left = _M0MPC15array12MutArrayView5sliceGiE(arr$2, 0, _pivot);
    const right = _M0MPC15array12MutArrayView5sliceGiE(arr$2, _pivot + 1 | 0, len);
    if ((left.end - left.start | 0) < (right.end - right.start | 0)) {
      _M0FPB22fixed__quick__sort__byGiE(left, cmp, pred$2, limit$3);
      _tmp = limit$3;
      _tmp$2 = right;
      _tmp$3 = arr$2.buf[arr$2.start + _pivot | 0];
      _tmp$4 = _partitioned;
      _tmp$5 = balanced$2;
      continue;
    } else {
      _M0FPB22fixed__quick__sort__byGiE(right, cmp, arr$2.buf[arr$2.start + _pivot | 0], limit$3);
      _tmp = limit$3;
      _tmp$2 = left;
      _tmp$4 = _partitioned;
      _tmp$5 = balanced$2;
      continue;
    }
  }
}
function _M0MPC15array12MutArrayView8sort__byGUciEE(self, cmp) {
  _M0FPB22fixed__quick__sort__byGUciEE(self, cmp, undefined, _M0FPB17fixed__get__limit(self.end - self.start | 0));
}
function _M0MPC15array12MutArrayView8sort__byGiE(self, cmp) {
  _M0FPB22fixed__quick__sort__byGiE(self, cmp, undefined, _M0FPB17fixed__get__limit(self.end - self.start | 0));
}
function _M0MPC15array5Array8sort__byGUciEE(self, cmp) {
  const _bind = self.len;
  _M0MPC15array12MutArrayView8sort__byGUciEE(new _M0TPB12MutArrayViewGUciEE(self.buf, 0, _bind), cmp);
}
function _M0MPC15array5Array8sort__byGiE(self, cmp) {
  const _bind = self.len;
  _M0MPC15array12MutArrayView8sort__byGiE(new _M0TPB12MutArrayViewGiE(self.buf, 0, _bind), cmp);
}
function _M0MPC15array5Array4makeGiE(len, elem) {
  const arr = _M0MPC15array5Array20unsafe__make__uninitGiE(len);
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < len) {
      arr.buf[i] = elem;
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return arr;
}
function _M0MPC15array5Array4makeGmE(len, elem) {
  const arr = _M0MPC15array5Array20unsafe__make__uninitGRPC14json4JsonE(len);
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < len) {
      arr.buf[i] = elem;
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return arr;
}
function _M0MPC15array5Array17reserve__capacityGmE(self, capacity) {
  if (_M0MPC15array5Array8capacityGRP312moonbitstack7moonstl4text6OpcodeE(self) >= capacity) {
    return undefined;
  }
  _M0MPC15array5Array14resize__bufferGRP312moonbitstack7moonstl4text6OpcodeE(self, capacity);
}
function _M0MPC15array5Array3popGUiiEE(self) {
  const len = self.len;
  if (len === 0) {
    return undefined;
  } else {
    const index = len - 1 | 0;
    const v = self.buf[index];
    self.len = index;
    return v;
  }
}
function _M0MPC15array5Array3popGiE(self) {
  const len = self.len;
  if (len === 0) {
    return undefined;
  } else {
    const index = len - 1 | 0;
    const v = self.buf[index];
    self.len = index;
    return v;
  }
}
function _M0MPC15array5Array4swapGiE(self, i, j) {
  if (i >= self.len || (j >= self.len || (i < 0 || j < 0))) {
    _M0FPB23index__out__of__bounds2GuE(self.len, i, j);
  }
  const temp = self.buf[i];
  const _bind = self.buf[j];
  self.buf[i] = _bind;
  self.buf[j] = temp;
}
function _M0FPC28internal7strconv10range__errGuE() {
  return new _M0DTPC16result6ResultGuRPB7FailureE3Err(new _M0DTPC15error5Error48moonbitlang_2fcore_2fbuiltin_2eFailure_2eFailure(_M0FPC28internal7strconv15range__err__str));
}
function _M0FPC28internal7strconv11syntax__errGRPC16string10StringViewE() {
  return new _M0DTPC16result6ResultGRPC16string10StringViewRPB7FailureE3Err(new _M0DTPC15error5Error48moonbitlang_2fcore_2fbuiltin_2eFailure_2eFailure(_M0FPC28internal7strconv16syntax__err__str));
}
function _M0FPC28internal7strconv11syntax__errGORPC28internal7strconv6NumberE() {
  return new _M0DTPC16result6ResultGORPC28internal7strconv6NumberRPB7FailureE3Err(new _M0DTPC15error5Error48moonbitlang_2fcore_2fbuiltin_2eFailure_2eFailure(_M0FPC28internal7strconv16syntax__err__str));
}
function _M0FPC28internal7strconv11syntax__errGuE() {
  return new _M0DTPC16result6ResultGuRPB7FailureE3Err(new _M0DTPC15error5Error48moonbitlang_2fcore_2fbuiltin_2eFailure_2eFailure(_M0FPC28internal7strconv16syntax__err__str));
}
function _M0FPC28internal7strconv11syntax__errGdE() {
  return new _M0DTPC16result6ResultGdRPB7FailureE3Err(new _M0DTPC15error5Error48moonbitlang_2fcore_2fbuiltin_2eFailure_2eFailure(_M0FPC28internal7strconv16syntax__err__str));
}
function _M0EPC16string10StringViewPC28internal7strconv12fold__digitsGlE(self, init, f) {
  let _tmp = self;
  let _tmp$2 = init;
  let _tmp$3 = 0;
  while (true) {
    const str = _tmp;
    const ret = _tmp$2;
    const len = _tmp$3;
    _L: {
      if ((str.end - str.start | 0) >= 1) {
        const _x = str.str.charCodeAt(str.start);
        if (_x >= 48 && _x <= 57) {
          const _x$2 = new _M0TPC16string10StringView(str.str, str.start + 1 | 0, str.end);
          _tmp = _x$2;
          _tmp$2 = f(_x - 48 | 0, ret);
          _tmp$3 = len + 1 | 0;
          continue;
        } else {
          if (_x === 95) {
            const _x$2 = new _M0TPC16string10StringView(str.str, str.start + 1 | 0, str.end);
            _tmp = _x$2;
            continue;
          } else {
            break _L;
          }
        }
      } else {
        break _L;
      }
    }
    return { _0: str, _1: ret, _2: len };
  }
}
function _M0FPC28internal7strconv13parse__digits(s, x) {
  return _M0EPC16string10StringViewPC28internal7strconv12fold__digitsGlE(s, x, (digit, acc) => BigInt.asUintN(64, BigInt.asUintN(64, acc * 10n) + BigInt.asUintN(64, BigInt(digit >>> 0))));
}
function _M0FPC28internal7strconv20try__parse__19digits(s, x) {
  let x$2 = x;
  let len = 0;
  let _tmp = s;
  while (true) {
    const s$2 = _tmp;
    let s$3;
    _L: {
      if ((s$2.end - s$2.start | 0) >= 1) {
        const _x = s$2.str.charCodeAt(s$2.start);
        if (_x >= 48 && _x <= 57) {
          const _x$2 = new _M0TPC16string10StringView(s$2.str, s$2.start + 1 | 0, s$2.end);
          if (BigInt.asUintN(64, x$2) < BigInt.asUintN(64, _M0FPC28internal7strconv17min__19digit__int)) {
            len = len + 1 | 0;
            x$2 = BigInt.asUintN(64, BigInt.asUintN(64, x$2 * 10n) + BigInt.asUintN(64, BigInt((_x - 48 | 0) >>> 0)));
            _tmp = _x$2;
            continue;
          } else {
            s$3 = s$2;
            break _L;
          }
        } else {
          if (_x === 95) {
            const _x$2 = new _M0TPC16string10StringView(s$2.str, s$2.start + 1 | 0, s$2.end);
            _tmp = _x$2;
            continue;
          } else {
            s$3 = s$2;
            break _L;
          }
        }
      } else {
        s$3 = s$2;
        break _L;
      }
    }
    return { _0: s$3, _1: x$2, _2: len };
  }
}
function _M0FPC28internal7strconv17parse__scientific(s) {
  let s$2 = s;
  let neg_exp = false;
  let rest;
  let ch;
  _L: {
    _L$2: {
      const _bind = s$2;
      if ((_bind.end - _bind.start | 0) >= 1) {
        const _x = _bind.str.charCodeAt(_bind.start);
        switch (_x) {
          case 43: {
            const _x$2 = new _M0TPC16string10StringView(_bind.str, _bind.start + 1 | 0, _bind.end);
            rest = _x$2;
            ch = _x;
            break _L$2;
          }
          case 45: {
            const _x$3 = new _M0TPC16string10StringView(_bind.str, _bind.start + 1 | 0, _bind.end);
            rest = _x$3;
            ch = _x;
            break _L$2;
          }
        }
      }
      break _L;
    }
    neg_exp = ch === 45;
    s$2 = rest;
  }
  _L$2: {
    const _bind = s$2;
    if ((_bind.end - _bind.start | 0) >= 1) {
      const _x = _bind.str.charCodeAt(_bind.start);
      if (_x >= 48 && _x <= 57) {
        const _bind$2 = _M0EPC16string10StringViewPC28internal7strconv12fold__digitsGlE(s$2, _M0FPC28internal7strconv17parse__scientificN8exp__numS2544, (digit, exp_num) => BigInt.asIntN(64, exp_num) < BigInt.asIntN(64, 65536n) ? BigInt.asUintN(64, BigInt.asUintN(64, 10n * exp_num) + BigInt.asUintN(64, BigInt(digit))) : exp_num);
        const _s = _bind$2._0;
        const _exp_num = _bind$2._1;
        return neg_exp ? { _0: _s, _1: BigInt.asUintN(64, -_exp_num) } : { _0: _s, _1: _exp_num };
      } else {
        break _L$2;
      }
    } else {
      break _L$2;
    }
  }
  return undefined;
}
function _M0FPC28internal7strconv13parse__number(s) {
  let s$2;
  let negative;
  _L: {
    let rest;
    _L$2: {
      if ((s.end - s.start | 0) >= 1) {
        const _x = s.str.charCodeAt(s.start);
        switch (_x) {
          case 45: {
            const _x$2 = new _M0TPC16string10StringView(s.str, s.start + 1 | 0, s.end);
            s$2 = _x$2;
            negative = true;
            break _L;
          }
          case 43: {
            const _x$3 = new _M0TPC16string10StringView(s.str, s.start + 1 | 0, s.end);
            rest = _x$3;
            break _L$2;
          }
          default: {
            rest = s;
            break _L$2;
          }
        }
      } else {
        rest = s;
        break _L$2;
      }
    }
    s$2 = rest;
    negative = false;
    break _L;
  }
  if ((s$2.end - s$2.start | 0) === 0) {
    return new _M0DTPC16result6ResultGORPC28internal7strconv6NumberRPC15error5ErrorE2Ok(undefined);
  }
  const _bind = _M0FPC28internal7strconv13parse__digits(s$2, 0n);
  const _s = _bind._0;
  const _mantissa = _bind._1;
  const _consumed = _bind._2;
  let mantissa = _mantissa;
  let s$3 = _s;
  let n_digits = _consumed;
  let n_after_dot = 0;
  let exponent = 0n;
  const _bind$2 = s$3;
  if ((_bind$2.end - _bind$2.start | 0) >= 1) {
    const _x = _bind$2.str.charCodeAt(_bind$2.start);
    if (_x === 46) {
      const _x$2 = new _M0TPC16string10StringView(_bind$2.str, _bind$2.start + 1 | 0, _bind$2.end);
      s$3 = _x$2;
      const _bind$3 = _M0FPC28internal7strconv13parse__digits(s$3, mantissa);
      const _new_s = _bind$3._0;
      const _new_mantissa = _bind$3._1;
      const _consumed_digit = _bind$3._2;
      s$3 = _new_s;
      mantissa = _new_mantissa;
      n_after_dot = _consumed_digit;
      exponent = BigInt.asUintN(64, -BigInt.asUintN(64, BigInt(n_after_dot)));
    }
  }
  n_digits = n_digits + n_after_dot | 0;
  if (n_digits === 0) {
    return new _M0DTPC16result6ResultGORPC28internal7strconv6NumberRPC15error5ErrorE2Ok(undefined);
  }
  let exp_number = 0n;
  let rest;
  _L$2: {
    _L$3: {
      const _bind$3 = s$3;
      if ((_bind$3.end - _bind$3.start | 0) >= 1) {
        const _x = _bind$3.str.charCodeAt(_bind$3.start);
        switch (_x) {
          case 101: {
            const _x$2 = new _M0TPC16string10StringView(_bind$3.str, _bind$3.start + 1 | 0, _bind$3.end);
            rest = _x$2;
            break _L$3;
          }
          case 69: {
            const _x$3 = new _M0TPC16string10StringView(_bind$3.str, _bind$3.start + 1 | 0, _bind$3.end);
            rest = _x$3;
            break _L$3;
          }
        }
      }
      break _L$2;
    }
    const _bind$3 = _M0FPC28internal7strconv17parse__scientific(rest);
    let _bind$4;
    if (_bind$3 === undefined) {
      return new _M0DTPC16result6ResultGORPC28internal7strconv6NumberRPC15error5ErrorE2Ok(undefined);
    } else {
      const _Some = _bind$3;
      _bind$4 = _Some;
    }
    const _new_s = _bind$4._0;
    const _exp_number_val = _bind$4._1;
    s$3 = _new_s;
    exp_number = _exp_number_val;
    exponent = BigInt.asUintN(64, exponent + exp_number);
  }
  const _bind$3 = s$3;
  if ((_bind$3.end - _bind$3.start | 0) === 0) {
    if (n_digits <= 19) {
      return new _M0DTPC16result6ResultGORPC28internal7strconv6NumberRPC15error5ErrorE2Ok(new _M0TPC28internal7strconv6Number(exponent, mantissa, negative, false));
    }
    n_digits = n_digits - 19 | 0;
    let many_digits = false;
    let _tmp = s.str;
    let _tmp$2 = s.start;
    let _tmp$3 = s.end;
    _L$3: while (true) {
      const s_str = _tmp;
      const s_start = _tmp$2;
      const s_end = _tmp$3;
      _L$4: {
        let rest$2;
        let ch;
        _L$5: {
          if ((s_end - s_start | 0) >= 1) {
            const _x = s_str.charCodeAt(s_start);
            switch (_x) {
              case 48: {
                const _x$2 = new _M0TPC16string10StringView(s_str, s_start + 1 | 0, s_end);
                rest$2 = _x$2;
                ch = _x;
                break _L$5;
              }
              case 46: {
                const _x$3 = new _M0TPC16string10StringView(s_str, s_start + 1 | 0, s_end);
                rest$2 = _x$3;
                ch = _x;
                break _L$5;
              }
              default: {
                break _L$4;
              }
            }
          } else {
            break _L$4;
          }
        }
        n_digits = n_digits - ((ch - 46 | 0) / 2 | 0) | 0;
        _tmp = rest$2.str;
        _tmp$2 = rest$2.start;
        _tmp$3 = rest$2.end;
        continue;
      }
      break;
    }
    if (n_digits > 0) {
      many_digits = true;
      mantissa = 0n;
      const _bind$4 = _M0FPC28internal7strconv20try__parse__19digits(s, mantissa);
      const _s$2 = _bind$4._0;
      const _new_mantissa = _bind$4._1;
      const _consumed_digit = _bind$4._2;
      mantissa = _new_mantissa;
      let _tmp$4;
      if (BigInt.asUintN(64, mantissa) >= BigInt.asUintN(64, _M0FPC28internal7strconv17min__19digit__int)) {
        _tmp$4 = _consumed_digit;
      } else {
        if (_M0MPC16string6String24char__length__ge_2einner(_s$2.str, 1, _s$2.start, _s$2.end)) {
          const _tmp$5 = _s$2.str;
          const _bind$5 = _M0MPC16string6String29offset__of__nth__char_2einner(_s$2.str, 1, _s$2.start, _s$2.end);
          let _tmp$6;
          if (_bind$5 === undefined) {
            _tmp$6 = _s$2.end;
          } else {
            const _Some = _bind$5;
            _tmp$6 = _Some;
          }
          const _x = new _M0TPC16string10StringView(_tmp$5, _tmp$6, _s$2.end);
          const _bind$6 = _M0FPC28internal7strconv20try__parse__19digits(_x, mantissa);
          const _new_mantissa$2 = _bind$6._1;
          const _consumed_digit$2 = _bind$6._2;
          mantissa = _new_mantissa$2;
          _tmp$4 = _consumed_digit$2;
        } else {
          return new _M0DTPC16result6ResultGORPC28internal7strconv6NumberRPC15error5ErrorE2Ok(undefined);
        }
      }
      exponent = BigInt.asUintN(64, BigInt(_tmp$4));
      exponent = BigInt.asUintN(64, exponent + exp_number);
    }
    return new _M0DTPC16result6ResultGORPC28internal7strconv6NumberRPC15error5ErrorE2Ok(new _M0TPC28internal7strconv6Number(exponent, mantissa, negative, many_digits));
  } else {
    return _M0FPC28internal7strconv11syntax__errGORPC28internal7strconv6NumberE();
  }
}
function _M0FPC28internal7strconv15parse__inf__nan(rest) {
  let pos;
  let rest$2;
  _L: {
    let rest$3;
    _L$2: {
      if ((rest.end - rest.start | 0) >= 1) {
        const _x = rest.str.charCodeAt(rest.start);
        switch (_x) {
          case 45: {
            const _x$2 = new _M0TPC16string10StringView(rest.str, rest.start + 1 | 0, rest.end);
            pos = false;
            rest$2 = _x$2;
            break _L;
          }
          case 43: {
            const _x$3 = new _M0TPC16string10StringView(rest.str, rest.start + 1 | 0, rest.end);
            rest$3 = _x$3;
            break _L$2;
          }
          default: {
            rest$3 = rest;
            break _L$2;
          }
        }
      } else {
        rest$3 = rest;
        break _L$2;
      }
    }
    pos = true;
    rest$2 = rest$3;
    break _L;
  }
  let _cursor_305 = 0;
  const _input_end_307 = rest$2.end - rest$2.start | 0;
  let _accept_state_308 = -1;
  let _match_end_309 = -1;
  let _labelled_block_result;
  _L$2: {
    let _labelled_block_result$2;
    _L$3: {
      if ((_cursor_305 + 2 | 0) < _input_end_307) {
        let _labelled_block_result$3;
        _L$4: {
          let _labelled_block_result$4;
          _L$5: {
            const _next_char_330 = rest$2.str.charCodeAt(rest$2.start + _cursor_305 | 0);
            _cursor_305 = _cursor_305 + 1 | 0;
            if (_next_char_330 < 79) {
              if (_next_char_330 < 74) {
                if (_next_char_330 < 73) {
                  _labelled_block_result = undefined;
                  break _L$2;
                } else {
                  _labelled_block_result$3 = undefined;
                  break _L$4;
                }
              } else {
                if (_next_char_330 > 77) {
                  _labelled_block_result$4 = undefined;
                  break _L$5;
                } else {
                  _labelled_block_result = undefined;
                  break _L$2;
                }
              }
            } else {
              if (_next_char_330 > 104) {
                if (_next_char_330 < 110) {
                  if (_next_char_330 < 106) {
                    _labelled_block_result$3 = undefined;
                    break _L$4;
                  } else {
                    _labelled_block_result = undefined;
                    break _L$2;
                  }
                } else {
                  if (_next_char_330 > 110) {
                    _labelled_block_result = undefined;
                    break _L$2;
                  } else {
                    _labelled_block_result$4 = undefined;
                    break _L$5;
                  }
                }
              } else {
                _labelled_block_result = undefined;
                break _L$2;
              }
            }
          }
          let _labelled_block_result$5;
          _L$6: {
            const _next_char_328 = rest$2.str.charCodeAt(rest$2.start + _cursor_305 | 0);
            _cursor_305 = _cursor_305 + 1 | 0;
            if (_next_char_328 < 66) {
              if (_next_char_328 < 65) {
                _labelled_block_result = undefined;
                break _L$2;
              } else {
                _labelled_block_result$5 = undefined;
                break _L$6;
              }
            } else {
              if (_next_char_328 > 96) {
                if (_next_char_328 < 98) {
                  _labelled_block_result$5 = undefined;
                  break _L$6;
                } else {
                  _labelled_block_result = undefined;
                  break _L$2;
                }
              } else {
                _labelled_block_result = undefined;
                break _L$2;
              }
            }
          }
          let _labelled_block_result$6;
          _L$7: {
            const _next_char_326 = rest$2.str.charCodeAt(rest$2.start + _cursor_305 | 0);
            _cursor_305 = _cursor_305 + 1 | 0;
            if (_next_char_326 < 79) {
              if (_next_char_326 < 78) {
                _labelled_block_result = undefined;
                break _L$2;
              } else {
                _labelled_block_result$6 = undefined;
                break _L$7;
              }
            } else {
              if (_next_char_326 > 109) {
                if (_next_char_326 < 111) {
                  _labelled_block_result$6 = undefined;
                  break _L$7;
                } else {
                  _labelled_block_result = undefined;
                  break _L$2;
                }
              } else {
                _labelled_block_result = undefined;
                break _L$2;
              }
            }
          }
          if (_cursor_305 < _input_end_307) {
            _labelled_block_result = undefined;
            break _L$2;
          } else {
            _accept_state_308 = 0;
            _match_end_309 = _cursor_305;
            _labelled_block_result = undefined;
            break _L$2;
          }
        }
        let _labelled_block_result$4;
        _L$5: {
          const _next_char_324 = rest$2.str.charCodeAt(rest$2.start + _cursor_305 | 0);
          _cursor_305 = _cursor_305 + 1 | 0;
          if (_next_char_324 < 79) {
            if (_next_char_324 < 78) {
              _labelled_block_result = undefined;
              break _L$2;
            } else {
              _labelled_block_result$4 = undefined;
              break _L$5;
            }
          } else {
            if (_next_char_324 > 109) {
              if (_next_char_324 < 111) {
                _labelled_block_result$4 = undefined;
                break _L$5;
              } else {
                _labelled_block_result = undefined;
                break _L$2;
              }
            } else {
              _labelled_block_result = undefined;
              break _L$2;
            }
          }
        }
        let _labelled_block_result$5;
        _L$6: {
          const _next_char_322 = rest$2.str.charCodeAt(rest$2.start + _cursor_305 | 0);
          _cursor_305 = _cursor_305 + 1 | 0;
          if (_next_char_322 < 71) {
            if (_next_char_322 < 70) {
              _labelled_block_result = undefined;
              break _L$2;
            } else {
              _labelled_block_result$5 = undefined;
              break _L$6;
            }
          } else {
            if (_next_char_322 > 101) {
              if (_next_char_322 < 103) {
                _labelled_block_result$5 = undefined;
                break _L$6;
              } else {
                _labelled_block_result = undefined;
                break _L$2;
              }
            } else {
              _labelled_block_result = undefined;
              break _L$2;
            }
          }
        }
        if (_cursor_305 < _input_end_307) {
          let _labelled_block_result$6;
          _L$7: {
            const _next_char_320 = rest$2.str.charCodeAt(rest$2.start + _cursor_305 | 0);
            _cursor_305 = _cursor_305 + 1 | 0;
            if (_next_char_320 < 74) {
              if (_next_char_320 < 73) {
                _labelled_block_result = undefined;
                break _L$2;
              } else {
                _labelled_block_result$6 = undefined;
                break _L$7;
              }
            } else {
              if (_next_char_320 > 104) {
                if (_next_char_320 < 106) {
                  _labelled_block_result$6 = undefined;
                  break _L$7;
                } else {
                  _labelled_block_result = undefined;
                  break _L$2;
                }
              } else {
                _labelled_block_result = undefined;
                break _L$2;
              }
            }
          }
          if ((_cursor_305 + 3 | 0) < _input_end_307) {
            let _labelled_block_result$7;
            _L$8: {
              const _next_char_318 = rest$2.str.charCodeAt(rest$2.start + _cursor_305 | 0);
              _cursor_305 = _cursor_305 + 1 | 0;
              if (_next_char_318 < 79) {
                if (_next_char_318 < 78) {
                  _labelled_block_result = undefined;
                  break _L$2;
                } else {
                  _labelled_block_result$7 = undefined;
                  break _L$8;
                }
              } else {
                if (_next_char_318 > 109) {
                  if (_next_char_318 < 111) {
                    _labelled_block_result$7 = undefined;
                    break _L$8;
                  } else {
                    _labelled_block_result = undefined;
                    break _L$2;
                  }
                } else {
                  _labelled_block_result = undefined;
                  break _L$2;
                }
              }
            }
            let _labelled_block_result$8;
            _L$9: {
              const _next_char_316 = rest$2.str.charCodeAt(rest$2.start + _cursor_305 | 0);
              _cursor_305 = _cursor_305 + 1 | 0;
              if (_next_char_316 < 74) {
                if (_next_char_316 < 73) {
                  _labelled_block_result = undefined;
                  break _L$2;
                } else {
                  _labelled_block_result$8 = undefined;
                  break _L$9;
                }
              } else {
                if (_next_char_316 > 104) {
                  if (_next_char_316 < 106) {
                    _labelled_block_result$8 = undefined;
                    break _L$9;
                  } else {
                    _labelled_block_result = undefined;
                    break _L$2;
                  }
                } else {
                  _labelled_block_result = undefined;
                  break _L$2;
                }
              }
            }
            let _labelled_block_result$9;
            _L$10: {
              const _next_char_314 = rest$2.str.charCodeAt(rest$2.start + _cursor_305 | 0);
              _cursor_305 = _cursor_305 + 1 | 0;
              if (_next_char_314 < 85) {
                if (_next_char_314 < 84) {
                  _labelled_block_result = undefined;
                  break _L$2;
                } else {
                  _labelled_block_result$9 = undefined;
                  break _L$10;
                }
              } else {
                if (_next_char_314 > 115) {
                  if (_next_char_314 < 117) {
                    _labelled_block_result$9 = undefined;
                    break _L$10;
                  } else {
                    _labelled_block_result = undefined;
                    break _L$2;
                  }
                } else {
                  _labelled_block_result = undefined;
                  break _L$2;
                }
              }
            }
            let _labelled_block_result$10;
            _L$11: {
              const _next_char_312 = rest$2.str.charCodeAt(rest$2.start + _cursor_305 | 0);
              _cursor_305 = _cursor_305 + 1 | 0;
              if (_next_char_312 < 90) {
                if (_next_char_312 < 89) {
                  _labelled_block_result = undefined;
                  break _L$2;
                } else {
                  _labelled_block_result$10 = undefined;
                  break _L$11;
                }
              } else {
                if (_next_char_312 > 120) {
                  if (_next_char_312 < 122) {
                    _labelled_block_result$10 = undefined;
                    break _L$11;
                  } else {
                    _labelled_block_result = undefined;
                    break _L$2;
                  }
                } else {
                  _labelled_block_result = undefined;
                  break _L$2;
                }
              }
            }
            if (_cursor_305 < _input_end_307) {
              _labelled_block_result = undefined;
              break _L$2;
            } else {
              _labelled_block_result$2 = undefined;
              break _L$3;
            }
          } else {
            _labelled_block_result = undefined;
            break _L$2;
          }
        } else {
          _labelled_block_result$2 = undefined;
          break _L$3;
        }
      } else {
        _labelled_block_result = undefined;
        break _L$2;
      }
    }
    _accept_state_308 = 1;
    _match_end_309 = _cursor_305;
    _labelled_block_result = undefined;
    break _L$2;
  }
  const _bind = _accept_state_308;
  switch (_bind) {
    case 0: {
      return new _M0DTPC16result6ResultGdRPC15error5ErrorE2Ok(_M0FPC16double14not__a__number);
    }
    case 1: {
      return pos ? new _M0DTPC16result6ResultGdRPC15error5ErrorE2Ok(_M0FPC16double8infinity) : new _M0DTPC16result6ResultGdRPC15error5ErrorE2Ok(_M0FPC16double13neg__infinity);
    }
    default: {
      return _M0FPC28internal7strconv11syntax__errGdE();
    }
  }
}
function _M0FPC28internal7strconv12checked__mul(a, b) {
  if (BigInt.asUintN(64, a) === BigInt.asUintN(64, 0n) || BigInt.asUintN(64, b) === BigInt.asUintN(64, 0n)) {
    return _M0FPC28internal7strconv12checked__mulN6constrS2672;
  }
  if (BigInt.asUintN(64, a) === BigInt.asUintN(64, 1n)) {
    return b;
  }
  if (BigInt.asUintN(64, b) === BigInt.asUintN(64, 1n)) {
    return a;
  }
  if ($i64_clz(b) === 0 || $i64_clz(a) === 0) {
    return undefined;
  }
  if (b === 0n) {
    $panic();
  }
  const quotient = BigInt.asUintN(64, BigInt.asUintN(64, 18446744073709551615n) / BigInt.asUintN(64, b));
  if (BigInt.asUintN(64, a) > BigInt.asUintN(64, quotient)) {
    return undefined;
  }
  return BigInt.asUintN(64, a * b);
}
function _M0FPC28internal7strconv17check__underscore(str) {
  if (_M0MPC16string10StringView20contains__code__unit(str, 95)) {
    let rest;
    if ((str.end - str.start | 0) >= 1) {
      const _x = str.str.charCodeAt(str.start);
      switch (_x) {
        case 43: {
          const _x$2 = new _M0TPC16string10StringView(str.str, str.start + 1 | 0, str.end);
          rest = _x$2;
          break;
        }
        case 45: {
          const _x$3 = new _M0TPC16string10StringView(str.str, str.start + 1 | 0, str.end);
          rest = _x$3;
          break;
        }
        default: {
          rest = str;
        }
      }
    } else {
      rest = str;
    }
    let rest$2;
    let allow_underscore;
    let hex;
    _L: {
      let _cursor_223 = 0;
      const _input_end_225 = rest.end - rest.start | 0;
      let _accept_state_226 = -1;
      let _match_end_227 = -1;
      let _labelled_block_result;
      _L$2: {
        if ((_cursor_223 + 1 | 0) < _input_end_225) {
          if (rest.str.charCodeAt(rest.start + _cursor_223 | 0) === 48) {
            _cursor_223 = _cursor_223 + 1 | 0;
            let _labelled_block_result$2;
            _L$3: {
              let _labelled_block_result$3;
              _L$4: {
                let _labelled_block_result$4;
                _L$5: {
                  const _next_char_229 = rest.str.charCodeAt(rest.start + _cursor_223 | 0);
                  _cursor_223 = _cursor_223 + 1 | 0;
                  if (_next_char_229 < 89) {
                    if (_next_char_229 < 79) {
                      if (_next_char_229 === 66) {
                        _labelled_block_result$2 = undefined;
                        break _L$3;
                      } else {
                        _labelled_block_result = undefined;
                        break _L$2;
                      }
                    } else {
                      if (_next_char_229 > 79) {
                        if (_next_char_229 < 88) {
                          _labelled_block_result = undefined;
                          break _L$2;
                        } else {
                          _labelled_block_result$4 = undefined;
                          break _L$5;
                        }
                      } else {
                        _labelled_block_result$3 = undefined;
                        break _L$4;
                      }
                    }
                  } else {
                    if (_next_char_229 > 97) {
                      if (_next_char_229 < 112) {
                        if (_next_char_229 < 99) {
                          _labelled_block_result$2 = undefined;
                          break _L$3;
                        } else {
                          if (_next_char_229 > 110) {
                            _labelled_block_result$3 = undefined;
                            break _L$4;
                          } else {
                            _labelled_block_result = undefined;
                            break _L$2;
                          }
                        }
                      } else {
                        if (_next_char_229 > 119) {
                          if (_next_char_229 < 121) {
                            _labelled_block_result$4 = undefined;
                            break _L$5;
                          } else {
                            _labelled_block_result = undefined;
                            break _L$2;
                          }
                        } else {
                          _labelled_block_result = undefined;
                          break _L$2;
                        }
                      }
                    } else {
                      _labelled_block_result = undefined;
                      break _L$2;
                    }
                  }
                }
                _accept_state_226 = 2;
                _match_end_227 = _cursor_223;
                _labelled_block_result = undefined;
                break _L$2;
              }
              _accept_state_226 = 1;
              _match_end_227 = _cursor_223;
              _labelled_block_result = undefined;
              break _L$2;
            }
            _accept_state_226 = 0;
            _match_end_227 = _cursor_223;
            _labelled_block_result = undefined;
            break _L$2;
          } else {
            _labelled_block_result = undefined;
            break _L$2;
          }
        } else {
          _labelled_block_result = undefined;
          break _L$2;
        }
      }
      const _bind = _accept_state_226;
      switch (_bind) {
        case 2: {
          const rest$3 = _M0MPC16string10StringView12unsafe__view(rest, _match_end_227, _input_end_225);
          rest$2 = rest$3;
          allow_underscore = true;
          hex = true;
          break _L;
        }
        case 1: {
          const rest$4 = _M0MPC16string10StringView12unsafe__view(rest, _match_end_227, _input_end_225);
          rest$2 = rest$4;
          allow_underscore = true;
          hex = false;
          break _L;
        }
        case 0: {
          const rest$5 = _M0MPC16string10StringView12unsafe__view(rest, _match_end_227, _input_end_225);
          rest$2 = rest$5;
          allow_underscore = true;
          hex = false;
          break _L;
        }
        default: {
          rest$2 = rest;
          allow_underscore = false;
          hex = false;
          break _L;
        }
      }
    }
    let _tmp = rest$2.str;
    let _tmp$2 = rest$2.start;
    let _tmp$3 = rest$2.end;
    let _tmp$4 = allow_underscore;
    let _tmp$5 = false;
    while (true) {
      const rest_str = _tmp;
      const rest_start = _tmp$2;
      const rest_end = _tmp$3;
      const allow_underscore$2 = _tmp$4;
      const follow_underscore = _tmp$5;
      let rest$3;
      _L$2: {
        _L$3: {
          let rest$4;
          _L$4: {
            _L$5: {
              let rest$5;
              _L$6: {
                let rest$6;
                _L$7: {
                  if ((rest_end - rest_start | 0) === 0) {
                    return true;
                  } else {
                    if ((rest_end - rest_start | 0) === 1) {
                      const _x = rest_str.charCodeAt(rest_start);
                      if (_x === 95) {
                        return false;
                      } else {
                        if (_x >= 48 && _x <= 57) {
                          const _x$2 = new _M0TPC16string10StringView(rest_str, rest_start + 1 | 0, rest_end);
                          rest$6 = _x$2;
                          break _L$7;
                        } else {
                          if (_x >= 97 && _x <= 102) {
                            const _x$2 = new _M0TPC16string10StringView(rest_str, rest_start + 1 | 0, rest_end);
                            if (hex) {
                              rest$5 = _x$2;
                              break _L$6;
                            } else {
                              if (_x === 101) {
                                if (follow_underscore === true) {
                                  break _L$5;
                                } else {
                                  rest$4 = _x$2;
                                  break _L$4;
                                }
                              } else {
                                if (follow_underscore === true) {
                                  break _L$3;
                                } else {
                                  rest$3 = _x$2;
                                  break _L$2;
                                }
                              }
                            }
                          } else {
                            if (_x >= 65 && _x <= 70) {
                              const _x$2 = new _M0TPC16string10StringView(rest_str, rest_start + 1 | 0, rest_end);
                              if (hex) {
                                rest$5 = _x$2;
                                break _L$6;
                              } else {
                                if (_x === 69) {
                                  if (follow_underscore === true) {
                                    break _L$5;
                                  } else {
                                    rest$4 = _x$2;
                                    break _L$4;
                                  }
                                } else {
                                  if (follow_underscore === true) {
                                    break _L$3;
                                  } else {
                                    rest$3 = _x$2;
                                    break _L$2;
                                  }
                                }
                              }
                            } else {
                              if (_x === 46) {
                                if (follow_underscore === true) {
                                  break _L$5;
                                } else {
                                  const _x$2 = new _M0TPC16string10StringView(rest_str, rest_start + 1 | 0, rest_end);
                                  rest$4 = _x$2;
                                  break _L$4;
                                }
                              } else {
                                if (_x === 43) {
                                  if (follow_underscore === true) {
                                    break _L$5;
                                  } else {
                                    const _x$2 = new _M0TPC16string10StringView(rest_str, rest_start + 1 | 0, rest_end);
                                    rest$4 = _x$2;
                                    break _L$4;
                                  }
                                } else {
                                  if (_x === 45) {
                                    if (follow_underscore === true) {
                                      break _L$5;
                                    } else {
                                      const _x$2 = new _M0TPC16string10StringView(rest_str, rest_start + 1 | 0, rest_end);
                                      rest$4 = _x$2;
                                      break _L$4;
                                    }
                                  } else {
                                    if (follow_underscore === true) {
                                      break _L$3;
                                    } else {
                                      const _bind = _M0MPC16string6String29offset__of__nth__char_2einner(rest_str, 1, rest_start, rest_end);
                                      let _tmp$6;
                                      if (_bind === undefined) {
                                        _tmp$6 = rest_end;
                                      } else {
                                        const _Some = _bind;
                                        _tmp$6 = _Some;
                                      }
                                      const _x$2 = new _M0TPC16string10StringView(rest_str, _tmp$6, rest_end);
                                      rest$3 = _x$2;
                                      break _L$2;
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    } else {
                      const _x = rest_str.charCodeAt(rest_start);
                      if (_x === 95) {
                        if (allow_underscore$2 === false) {
                          return false;
                        } else {
                          const _bind = rest_start + 1 | 0;
                          _tmp$2 = _bind;
                          _tmp$4 = false;
                          _tmp$5 = true;
                          continue;
                        }
                      } else {
                        if (_x >= 48 && _x <= 57) {
                          const _x$2 = new _M0TPC16string10StringView(rest_str, rest_start + 1 | 0, rest_end);
                          rest$6 = _x$2;
                          break _L$7;
                        } else {
                          if (_x >= 97 && _x <= 102) {
                            const _x$2 = new _M0TPC16string10StringView(rest_str, rest_start + 1 | 0, rest_end);
                            if (hex) {
                              rest$5 = _x$2;
                              break _L$6;
                            } else {
                              if (_x === 101) {
                                if (follow_underscore === true) {
                                  break _L$5;
                                } else {
                                  rest$4 = _x$2;
                                  break _L$4;
                                }
                              } else {
                                if (follow_underscore === true) {
                                  break _L$3;
                                } else {
                                  rest$3 = _x$2;
                                  break _L$2;
                                }
                              }
                            }
                          } else {
                            if (_x >= 65 && _x <= 70) {
                              const _x$2 = new _M0TPC16string10StringView(rest_str, rest_start + 1 | 0, rest_end);
                              if (hex) {
                                rest$5 = _x$2;
                                break _L$6;
                              } else {
                                if (_x === 69) {
                                  if (follow_underscore === true) {
                                    break _L$5;
                                  } else {
                                    rest$4 = _x$2;
                                    break _L$4;
                                  }
                                } else {
                                  if (follow_underscore === true) {
                                    break _L$3;
                                  } else {
                                    rest$3 = _x$2;
                                    break _L$2;
                                  }
                                }
                              }
                            } else {
                              if (_x === 46) {
                                if (follow_underscore === true) {
                                  break _L$5;
                                } else {
                                  const _x$2 = new _M0TPC16string10StringView(rest_str, rest_start + 1 | 0, rest_end);
                                  rest$4 = _x$2;
                                  break _L$4;
                                }
                              } else {
                                if (_x === 43) {
                                  if (follow_underscore === true) {
                                    break _L$5;
                                  } else {
                                    const _x$2 = new _M0TPC16string10StringView(rest_str, rest_start + 1 | 0, rest_end);
                                    rest$4 = _x$2;
                                    break _L$4;
                                  }
                                } else {
                                  if (_x === 45) {
                                    if (follow_underscore === true) {
                                      break _L$5;
                                    } else {
                                      const _x$2 = new _M0TPC16string10StringView(rest_str, rest_start + 1 | 0, rest_end);
                                      rest$4 = _x$2;
                                      break _L$4;
                                    }
                                  } else {
                                    if (follow_underscore === true) {
                                      break _L$3;
                                    } else {
                                      const _bind = _M0MPC16string6String29offset__of__nth__char_2einner(rest_str, 1, rest_start, rest_end);
                                      let _tmp$6;
                                      if (_bind === undefined) {
                                        _tmp$6 = rest_end;
                                      } else {
                                        const _Some = _bind;
                                        _tmp$6 = _Some;
                                      }
                                      const _x$2 = new _M0TPC16string10StringView(rest_str, _tmp$6, rest_end);
                                      rest$3 = _x$2;
                                      break _L$2;
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
                _tmp = rest$6.str;
                _tmp$2 = rest$6.start;
                _tmp$3 = rest$6.end;
                _tmp$4 = true;
                _tmp$5 = false;
                continue;
              }
              _tmp = rest$5.str;
              _tmp$2 = rest$5.start;
              _tmp$3 = rest$5.end;
              _tmp$4 = true;
              _tmp$5 = false;
              continue;
            }
            return false;
          }
          _tmp = rest$4.str;
          _tmp$2 = rest$4.start;
          _tmp$3 = rest$4.end;
          _tmp$4 = false;
          _tmp$5 = false;
          continue;
        }
        return false;
      }
      _tmp = rest$3.str;
      _tmp$2 = rest$3.start;
      _tmp$3 = rest$3.end;
      _tmp$4 = false;
      _tmp$5 = false;
      continue;
    }
  } else {
    return true;
  }
}
function _M0FPC28internal7strconv14eisel__umul128(a, b) {
  const a_lo = BigInt.asUintN(64, a & 4294967295n);
  const a_hi = BigInt.asUintN(64, BigInt.asUintN(64, a) >> BigInt(32 & 63));
  const b_lo = BigInt.asUintN(64, b & 4294967295n);
  const b_hi = BigInt.asUintN(64, BigInt.asUintN(64, b) >> BigInt(32 & 63));
  const x = BigInt.asUintN(64, a_lo * b_lo);
  const y = BigInt.asUintN(64, BigInt.asUintN(64, a_hi * b_lo) + BigInt.asUintN(64, BigInt.asUintN(64, x) >> BigInt(32 & 63)));
  const z = BigInt.asUintN(64, BigInt.asUintN(64, a_lo * b_hi) + BigInt.asUintN(64, y & 4294967295n));
  const hi = BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, a_hi * b_hi) + BigInt.asUintN(64, BigInt.asUintN(64, y) >> BigInt(32 & 63))) + BigInt.asUintN(64, BigInt.asUintN(64, z) >> BigInt(32 & 63)));
  return new _M0TPC28internal7strconv12EiselProduct(BigInt.asUintN(64, a * b), hi);
}
function _M0FPC28internal7strconv20try__eisel__lemire64(mantissa, exponent, negative) {
  if (BigInt.asUintN(64, mantissa) === BigInt.asUintN(64, 0n)) {
    return negative ? $i64_reinterpret_f64(9223372036854775808n) : 0;
  }
  if (BigInt.asIntN(64, exponent) < BigInt.asIntN(64, 18446744073709551268n) || BigInt.asIntN(64, exponent) > BigInt.asIntN(64, 347n)) {
    return _M0FPC16double14not__a__number;
  }
  const exponent$2 = Number(BigInt.asIntN(32, exponent)) | 0;
  const table_index = Math.imul(exponent$2 - -348 | 0, 2) | 0;
  const pow_hi = table_index >>> 0 < _M0FPC28internal7strconv27eisel__lemire__pow10__table.length ? _M0FPC28internal7strconv27eisel__lemire__pow10__table[table_index] : $oob();
  const _p = table_index + 1 | 0;
  const pow_lo = _p >>> 0 < _M0FPC28internal7strconv27eisel__lemire__pow10__table.length ? _M0FPC28internal7strconv27eisel__lemire__pow10__table[_p] : $oob();
  const pow_exp2 = 1 + (Math.imul(exponent$2, 108853) >> 15) | 0;
  const leading_zeros = $i64_clz(mantissa);
  const normalized = BigInt.asUintN(64, mantissa << BigInt(leading_zeros & 63));
  let result_exp2 = ((pow_exp2 + 63 | 0) + 1023 | 0) - leading_zeros | 0;
  const product = _M0FPC28internal7strconv14eisel__umul128(normalized, pow_hi);
  let product_hi = product.hi;
  let product_lo = product.lo;
  if (BigInt.asUintN(64, BigInt.asUintN(64, product_hi & 511n)) === BigInt.asUintN(64, 511n) && BigInt.asUintN(64, BigInt.asUintN(64, product_lo + normalized)) < BigInt.asUintN(64, normalized)) {
    const wider = _M0FPC28internal7strconv14eisel__umul128(normalized, pow_lo);
    let merged_hi = product_hi;
    const merged_lo = BigInt.asUintN(64, product_lo + wider.hi);
    if (BigInt.asUintN(64, merged_lo) < BigInt.asUintN(64, product_lo)) {
      merged_hi = BigInt.asUintN(64, merged_hi + 1n);
    }
    if (BigInt.asUintN(64, BigInt.asUintN(64, merged_hi & 511n)) === BigInt.asUintN(64, 511n) && (BigInt.asUintN(64, BigInt.asUintN(64, merged_lo + 1n)) === BigInt.asUintN(64, 0n) && BigInt.asUintN(64, BigInt.asUintN(64, wider.lo + normalized)) < BigInt.asUintN(64, normalized))) {
      return _M0FPC16double14not__a__number;
    }
    product_hi = merged_hi;
    product_lo = merged_lo;
  }
  const top_bit = Number(BigInt.asIntN(32, BigInt.asUintN(64, BigInt.asUintN(64, product_hi) >> BigInt(63 & 63)))) | 0;
  let result_mantissa = BigInt.asUintN(64, BigInt.asUintN(64, product_hi) >> BigInt(top_bit + 9 & 63));
  result_exp2 = result_exp2 - (1 - top_bit | 0) | 0;
  if (BigInt.asUintN(64, product_lo) === BigInt.asUintN(64, 0n) && (BigInt.asUintN(64, BigInt.asUintN(64, product_hi & 511n)) === BigInt.asUintN(64, 0n) && BigInt.asUintN(64, BigInt.asUintN(64, result_mantissa & 3n)) === BigInt.asUintN(64, 1n))) {
    return _M0FPC16double14not__a__number;
  }
  result_mantissa = BigInt.asUintN(64, result_mantissa + BigInt.asUintN(64, result_mantissa & 1n));
  result_mantissa = BigInt.asUintN(64, BigInt.asUintN(64, result_mantissa) >> BigInt(1 & 63));
  if (BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, result_mantissa) >> BigInt(53 & 63))) > BigInt.asUintN(64, 0n)) {
    result_mantissa = BigInt.asUintN(64, BigInt.asUintN(64, result_mantissa) >> BigInt(1 & 63));
    result_exp2 = result_exp2 + 1 | 0;
  }
  if (result_exp2 <= 0 || result_exp2 >= 2047) {
    return _M0FPC16double14not__a__number;
  }
  const exponent_bits = BigInt.asUintN(64, BigInt.asUintN(64, BigInt(result_exp2 >>> 0)) << BigInt(52 & 63));
  let result_bits = BigInt.asUintN(64, exponent_bits | BigInt.asUintN(64, result_mantissa & 4503599627370495n));
  if (negative) {
    result_bits = BigInt.asUintN(64, result_bits | 9223372036854775808n);
  }
  return $i64_reinterpret_f64(result_bits);
}
function _M0MPC28internal7strconv7Decimal9new__priv() {
  return new _M0TPC28internal7strconv7Decimal($makebytes(800, 0), 0, 0, false, false, 0);
}
function _M0MPC28internal7strconv7Decimal4trim(self) {
  while (true) {
    let _tmp;
    if (self.digits_num > 0) {
      const _tmp$2 = self.digits;
      const _tmp$3 = self.digits_num - 1 | 0;
      _tmp = (_tmp$3 >>> 0 < _tmp$2.length ? _tmp$2[_tmp$3] : $oob()) === 0;
    } else {
      _tmp = false;
    }
    if (_tmp) {
      self.digits_num = self.digits_num - 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (self.digits_num === 0) {
    self.decimal_point = 0;
    return;
  } else {
    return;
  }
}
function _M0FPC28internal7strconv26parse__decimal__from__view(str) {
  const d = _M0MPC28internal7strconv7Decimal9new__priv();
  let has_dp = false;
  let has_digits = false;
  let rest;
  _L: {
    _L$2: {
      if ((str.end - str.start | 0) >= 1) {
        const _x = str.str.charCodeAt(str.start);
        switch (_x) {
          case 45: {
            const _x$2 = new _M0TPC16string10StringView(str.str, str.start + 1 | 0, str.end);
            d.negative = true;
            rest = _x$2;
            break;
          }
          case 43: {
            rest = new _M0TPC16string10StringView(str.str, str.start + 1 | 0, str.end);
            break;
          }
          default: {
            break _L$2;
          }
        }
      } else {
        break _L$2;
      }
      break _L;
    }
    rest = str;
  }
  let rest$2;
  let _tmp = rest;
  while (true) {
    const rest$3 = _tmp;
    let rest$4;
    _L$2: {
      _L$3: {
        if ((rest$3.end - rest$3.start | 0) >= 1) {
          const _x = rest$3.str.charCodeAt(rest$3.start);
          if (_x === 95) {
            const _x$2 = new _M0TPC16string10StringView(rest$3.str, rest$3.start + 1 | 0, rest$3.end);
            _tmp = _x$2;
            continue;
          } else {
            if (_x === 46) {
              const _x$2 = new _M0TPC16string10StringView(rest$3.str, rest$3.start + 1 | 0, rest$3.end);
              if (!has_dp) {
                has_dp = true;
                d.decimal_point = d.digits_num;
                _tmp = _x$2;
                continue;
              } else {
                const _bind = _M0FPC28internal7strconv11syntax__errGuE();
                if (_bind.$tag === 1) {
                  const _ok = _bind;
                  _ok._0;
                } else {
                  return _bind;
                }
              }
            } else {
              if (_x >= 48 && _x <= 57) {
                const _x$2 = new _M0TPC16string10StringView(rest$3.str, rest$3.start + 1 | 0, rest$3.end);
                has_digits = true;
                if (_x === 48 && d.digits_num === 0) {
                  d.decimal_point = d.decimal_point - 1 | 0;
                  _tmp = _x$2;
                  continue;
                }
                if (d.digits_num < d.digits.length) {
                  const _tmp$2 = d.digits;
                  const _tmp$3 = d.digits_num;
                  if (_tmp$3 >>> 0 < _tmp$2.length) {
                    _tmp$2[_tmp$3] = (_x - 48 | 0) & 255;
                  } else {
                    $oob();
                  }
                  d.digits_num = d.digits_num + 1 | 0;
                } else {
                  if (!has_dp) {
                    d.overflowed = d.overflowed + 1 | 0;
                  }
                  if (_x !== 48) {
                    d.truncated = true;
                  }
                }
                _tmp = _x$2;
                continue;
              } else {
                rest$4 = rest$3;
                break _L$3;
              }
            }
          }
        } else {
          rest$4 = rest$3;
          break _L$3;
        }
        break _L$2;
      }
      rest$2 = rest$4;
      break;
    }
    continue;
  }
  if (has_digits) {
    if (!has_dp) {
      d.decimal_point = d.digits_num;
    }
    let rest$3;
    let rest$4;
    _L$2: {
      _L$3: {
        if ((rest$2.end - rest$2.start | 0) >= 1) {
          const _x = rest$2.str.charCodeAt(rest$2.start);
          switch (_x) {
            case 101: {
              const _x$2 = new _M0TPC16string10StringView(rest$2.str, rest$2.start + 1 | 0, rest$2.end);
              rest$4 = _x$2;
              break _L$3;
            }
            case 69: {
              const _x$3 = new _M0TPC16string10StringView(rest$2.str, rest$2.start + 1 | 0, rest$2.end);
              rest$4 = _x$3;
              break _L$3;
            }
            default: {
              rest$3 = rest$2;
            }
          }
        } else {
          rest$3 = rest$2;
        }
        break _L$2;
      }
      let exp_sign = 1;
      let rest$5;
      if ((rest$4.end - rest$4.start | 0) >= 1) {
        const _x = rest$4.str.charCodeAt(rest$4.start);
        switch (_x) {
          case 43: {
            rest$5 = new _M0TPC16string10StringView(rest$4.str, rest$4.start + 1 | 0, rest$4.end);
            break;
          }
          case 45: {
            const _x$2 = new _M0TPC16string10StringView(rest$4.str, rest$4.start + 1 | 0, rest$4.end);
            exp_sign = -1;
            rest$5 = _x$2;
            break;
          }
          default: {
            rest$5 = rest$4;
          }
        }
      } else {
        rest$5 = rest$4;
      }
      _L$4: {
        _L$5: {
          if ((rest$5.end - rest$5.start | 0) >= 1) {
            const _x = rest$5.str.charCodeAt(rest$5.start);
            if (_x >= 48 && _x <= 57) {
              const effective_dp = d.decimal_point + d.overflowed | 0;
              const exp_limit = exp_sign > 0 ? (effective_dp < 311 ? 311 - effective_dp | 0 : 0) : effective_dp > -331 ? effective_dp + 331 | 0 : 0;
              let exp = 0;
              let rest$6;
              let _tmp$2 = rest$5;
              while (true) {
                const rest$7 = _tmp$2;
                let rest$8;
                _L$6: {
                  if ((rest$7.end - rest$7.start | 0) >= 1) {
                    const _x$2 = rest$7.str.charCodeAt(rest$7.start);
                    if (_x$2 === 95) {
                      const _x$3 = new _M0TPC16string10StringView(rest$7.str, rest$7.start + 1 | 0, rest$7.end);
                      _tmp$2 = _x$3;
                      continue;
                    } else {
                      if (_x$2 >= 48 && _x$2 <= 57) {
                        const _x$3 = new _M0TPC16string10StringView(rest$7.str, rest$7.start + 1 | 0, rest$7.end);
                        if (exp < exp_limit) {
                          exp = (Math.imul(exp, 10) | 0) + (_x$2 - 48 | 0) | 0;
                          if (exp > exp_limit) {
                            exp = exp_limit;
                          }
                        }
                        _tmp$2 = _x$3;
                        continue;
                      } else {
                        rest$8 = rest$7;
                        break _L$6;
                      }
                    }
                  } else {
                    rest$8 = rest$7;
                    break _L$6;
                  }
                }
                rest$6 = rest$8;
                break;
              }
              d.decimal_point = d.decimal_point + (Math.imul(exp_sign, exp) | 0) | 0;
              rest$3 = rest$6;
            } else {
              break _L$5;
            }
          } else {
            break _L$5;
          }
          break _L$4;
        }
        const _bind = _M0FPC28internal7strconv11syntax__errGRPC16string10StringViewE();
        if (_bind.$tag === 1) {
          const _ok = _bind;
          rest$3 = _ok._0;
        } else {
          return _bind;
        }
      }
    }
    if ((rest$3.end - rest$3.start | 0) === 0) {
      _M0MPC28internal7strconv7Decimal4trim(d);
      return new _M0DTPC16result6ResultGRPC28internal7strconv7DecimalRPC15error5ErrorE2Ok(d);
    } else {
      return _M0FPC28internal7strconv11syntax__errGRPC16string10StringViewE();
    }
  } else {
    return _M0FPC28internal7strconv11syntax__errGRPC16string10StringViewE();
  }
}
function _M0FPC28internal7strconv20parse__decimal__priv(str) {
  return _M0FPC28internal7strconv26parse__decimal__from__view(str);
}
function _M0FPC28internal7strconv14assemble__bits(mantissa, exponent, negative) {
  const biased_exp = exponent - _M0FPC28internal7strconv12double__info.bias | 0;
  let bits = BigInt.asUintN(64, mantissa & BigInt.asUintN(64, BigInt.asUintN(64, 1n << BigInt(_M0FPC28internal7strconv12double__info.mantissa_bits & 63)) - 1n));
  const exp_bits = BigInt.asUintN(64, BigInt(biased_exp & ((1 << _M0FPC28internal7strconv12double__info.exponent_bits) - 1 | 0)));
  bits = BigInt.asUintN(64, bits | BigInt.asUintN(64, exp_bits << BigInt(_M0FPC28internal7strconv12double__info.mantissa_bits & 63)));
  if (negative) {
    bits = BigInt.asUintN(64, bits | BigInt.asUintN(64, BigInt.asUintN(64, 1n << BigInt(_M0FPC28internal7strconv12double__info.mantissa_bits & 63)) << BigInt(_M0FPC28internal7strconv12double__info.exponent_bits & 63)));
  }
  return bits;
}
function _M0MPC28internal7strconv7Decimal17should__round__up(self, d) {
  if (d < 0 || d >= self.digits_num) {
    return false;
  }
  let _tmp;
  const _tmp$2 = self.digits;
  if ((d >>> 0 < _tmp$2.length ? _tmp$2[d] : $oob()) === 5) {
    _tmp = (d + 1 | 0) === self.digits_num;
  } else {
    _tmp = false;
  }
  if (_tmp) {
    if (self.truncated) {
      return true;
    }
    let _tmp$3;
    if (d > 0) {
      const _tmp$4 = self.digits;
      const _tmp$5 = d - 1 | 0;
      _tmp$3 = ((_tmp$5 >>> 0 < _tmp$4.length ? _tmp$4[_tmp$5] : $oob()) % 2 | 0) !== 0;
    } else {
      _tmp$3 = false;
    }
    return _tmp$3;
  }
  const _tmp$3 = self.digits;
  return (d >>> 0 < _tmp$3.length ? _tmp$3[d] : $oob()) >= 5;
}
function _M0MPC28internal7strconv7Decimal16rounded__integer(self) {
  if (self.decimal_point > 20) {
    return 18446744073709551615n;
  }
  let _tmp = 0n;
  let _tmp$2 = 0;
  while (true) {
    const n = _tmp;
    const i = _tmp$2;
    if (i < self.decimal_point && i < self.digits_num) {
      const _tmp$3 = BigInt.asUintN(64, n * 10n);
      const _tmp$4 = self.digits;
      const _p = i >>> 0 < _tmp$4.length ? _tmp$4[i] : $oob();
      _tmp = BigInt.asUintN(64, _tmp$3 + BigInt.asUintN(64, BigInt(_p)));
      _tmp$2 = i + 1 | 0;
      continue;
    } else {
      let n$2;
      let _tmp$3 = n;
      let _tmp$4 = i;
      while (true) {
        const n$3 = _tmp$3;
        const i$2 = _tmp$4;
        if (i$2 < self.decimal_point) {
          _tmp$3 = BigInt.asUintN(64, n$3 * 10n);
          _tmp$4 = i$2 + 1 | 0;
          continue;
        } else {
          n$2 = n$3;
          break;
        }
      }
      return _M0MPC28internal7strconv7Decimal17should__round__up(self, self.decimal_point) ? BigInt.asUintN(64, n$2 + 1n) : n$2;
    }
  }
}
function _M0MPC28internal7strconv7Decimal11new__digits(self, s) {
  const new_digits = (s >>> 0 < _M0FPC28internal7strconv19left__shift__cheats.length ? _M0FPC28internal7strconv19left__shift__cheats[s] : $oob())._0;
  const cheat_num = (s >>> 0 < _M0FPC28internal7strconv19left__shift__cheats.length ? _M0FPC28internal7strconv19left__shift__cheats[s] : $oob())._1;
  const _bind = cheat_num.length;
  let less;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      const code_unit = cheat_num.charCodeAt(i);
      if (i >= self.digits_num) {
        less = true;
        break;
      }
      const d = code_unit - 48 | 0;
      const _tmp$2 = self.digits;
      if ((i >>> 0 < _tmp$2.length ? _tmp$2[i] : $oob()) !== d) {
        const _tmp$3 = self.digits;
        less = (i >>> 0 < _tmp$3.length ? _tmp$3[i] : $oob()) < d;
        break;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      less = false;
      break;
    }
  }
  return less ? new_digits - 1 | 0 : new_digits;
}
function _M0MPC28internal7strconv7Decimal11left__shift(self, s) {
  const new_digits = _M0MPC28internal7strconv7Decimal11new__digits(self, s);
  let read_index = self.digits_num - 1 | 0;
  let write_index = self.digits_num + new_digits | 0;
  let acc = 0n;
  while (true) {
    if (read_index >= 0) {
      const _tmp = self.digits;
      const _tmp$2 = read_index;
      const _p = _tmp$2 >>> 0 < _tmp.length ? _tmp[_tmp$2] : $oob();
      const d = BigInt.asUintN(64, BigInt(_p));
      acc = BigInt.asUintN(64, acc + BigInt.asUintN(64, d << BigInt(s & 63)));
      if (10n === 0n) {
        $panic();
      }
      const quo = BigInt.asUintN(64, BigInt.asIntN(64, acc) / BigInt.asIntN(64, 10n));
      const rem = Number(BigInt.asIntN(32, BigInt.asUintN(64, acc - BigInt.asUintN(64, quo * 10n)))) | 0;
      write_index = write_index - 1 | 0;
      if (write_index < self.digits.length) {
        const _tmp$3 = self.digits;
        const _tmp$4 = write_index;
        if (_tmp$4 >>> 0 < _tmp$3.length) {
          _tmp$3[_tmp$4] = rem & 255;
        } else {
          $oob();
        }
      } else {
        if (rem !== 0) {
          self.truncated = true;
        }
      }
      acc = quo;
      read_index = read_index - 1 | 0;
      continue;
    } else {
      break;
    }
  }
  while (true) {
    if (BigInt.asIntN(64, acc) > BigInt.asIntN(64, 0n)) {
      if (10n === 0n) {
        $panic();
      }
      const quo = BigInt.asUintN(64, BigInt.asIntN(64, acc) / BigInt.asIntN(64, 10n));
      const rem = Number(BigInt.asIntN(32, BigInt.asUintN(64, acc - BigInt.asUintN(64, 10n * quo)))) | 0;
      write_index = write_index - 1 | 0;
      if (write_index < self.digits.length) {
        const _tmp = self.digits;
        const _tmp$2 = write_index;
        if (_tmp$2 >>> 0 < _tmp.length) {
          _tmp[_tmp$2] = rem & 255;
        } else {
          $oob();
        }
      } else {
        if (rem !== 0) {
          self.truncated = true;
        }
      }
      acc = quo;
      continue;
    } else {
      break;
    }
  }
  self.digits_num = self.digits_num + new_digits | 0;
  if (self.digits_num > self.digits.length) {
    self.digits_num = self.digits.length;
  }
  self.decimal_point = self.decimal_point + new_digits | 0;
  _M0MPC28internal7strconv7Decimal4trim(self);
}
function _M0MPC28internal7strconv7Decimal12right__shift(self, s) {
  let read_index = 0;
  let write_index = 0;
  let acc = 0n;
  while (true) {
    if (BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, acc) >> BigInt(s & 63))) === BigInt.asUintN(64, 0n)) {
      if (read_index >= self.digits_num) {
        while (true) {
          if (BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, acc) >> BigInt(s & 63))) === BigInt.asUintN(64, 0n)) {
            acc = BigInt.asUintN(64, acc * 10n);
            read_index = read_index + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        break;
      }
      const _tmp = self.digits;
      const _tmp$2 = read_index;
      const d = _tmp$2 >>> 0 < _tmp.length ? _tmp[_tmp$2] : $oob();
      acc = BigInt.asUintN(64, BigInt.asUintN(64, acc * 10n) + BigInt.asUintN(64, BigInt(d)));
      read_index = read_index + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  self.decimal_point = self.decimal_point - (read_index - 1 | 0) | 0;
  const mask = BigInt.asUintN(64, BigInt.asUintN(64, 1n << BigInt(s & 63)) - 1n);
  while (true) {
    if (read_index < self.digits_num) {
      const out = BigInt.asUintN(64, BigInt.asUintN(64, acc) >> BigInt(s & 63));
      const _tmp = self.digits;
      const _tmp$2 = write_index;
      if (_tmp$2 >>> 0 < _tmp.length) {
        _tmp[_tmp$2] = (Number(BigInt.asIntN(32, out)) | 0) & 255;
      } else {
        $oob();
      }
      write_index = write_index + 1 | 0;
      acc = BigInt.asUintN(64, acc & mask);
      const _tmp$3 = self.digits;
      const _tmp$4 = read_index;
      const d = _tmp$4 >>> 0 < _tmp$3.length ? _tmp$3[_tmp$4] : $oob();
      acc = BigInt.asUintN(64, BigInt.asUintN(64, acc * 10n) + BigInt.asUintN(64, BigInt(d)));
      read_index = read_index + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  while (true) {
    if (BigInt.asUintN(64, acc) > BigInt.asUintN(64, 0n)) {
      const out = BigInt.asUintN(64, BigInt.asUintN(64, acc) >> BigInt(s & 63));
      if (write_index < self.digits.length) {
        const _tmp = self.digits;
        const _tmp$2 = write_index;
        if (_tmp$2 >>> 0 < _tmp.length) {
          _tmp[_tmp$2] = (Number(BigInt.asIntN(32, out)) | 0) & 255;
        } else {
          $oob();
        }
        write_index = write_index + 1 | 0;
      } else {
        if (BigInt.asUintN(64, out) > BigInt.asUintN(64, 0n)) {
          self.truncated = true;
        }
      }
      acc = BigInt.asUintN(64, acc & mask);
      acc = BigInt.asUintN(64, acc * 10n);
      continue;
    } else {
      break;
    }
  }
  self.digits_num = write_index;
  _M0MPC28internal7strconv7Decimal4trim(self);
}
function _M0MPC28internal7strconv7Decimal11shift__priv(self, s) {
  if (self.digits_num === 0) {
    return undefined;
  }
  let s$2 = s;
  if (s$2 > 0) {
    while (true) {
      if (s$2 > 59) {
        _M0MPC28internal7strconv7Decimal11left__shift(self, 59);
        s$2 = s$2 - 59 | 0;
        continue;
      } else {
        break;
      }
    }
    _M0MPC28internal7strconv7Decimal11left__shift(self, s$2);
  }
  if (s$2 < 0) {
    while (true) {
      if (s$2 < -59) {
        _M0MPC28internal7strconv7Decimal12right__shift(self, 59);
        s$2 = s$2 + 59 | 0;
        continue;
      } else {
        break;
      }
    }
    _M0MPC28internal7strconv7Decimal12right__shift(self, -s$2 | 0);
    return;
  } else {
    return;
  }
}
function _M0MPC28internal7strconv7Decimal16to__double__priv(self) {
  let exponent = 0;
  let mantissa = 0n;
  const effective_dp = self.decimal_point + self.overflowed | 0;
  if (self.digits_num === 0 || effective_dp < -330) {
    mantissa = 0n;
    exponent = _M0FPC28internal7strconv12double__info.bias;
    const bits = _M0FPC28internal7strconv14assemble__bits(mantissa, exponent, self.negative);
    return new _M0DTPC16result6ResultGdRPC15error5ErrorE2Ok($i64_reinterpret_f64(bits));
  }
  if (self.decimal_point > 310) {
    const _bind = _M0FPC28internal7strconv10range__errGuE();
    if (_bind.$tag === 1) {
      const _ok = _bind;
      _ok._0;
    } else {
      return _bind;
    }
  }
  self.decimal_point = self.decimal_point + self.overflowed | 0;
  while (true) {
    if (self.decimal_point > 0) {
      let n;
      if (self.decimal_point >= _M0FPC28internal7strconv6powtab.length) {
        n = 60;
      } else {
        const _p = self.decimal_point;
        n = _p >>> 0 < _M0FPC28internal7strconv6powtab.length ? _M0FPC28internal7strconv6powtab[_p] : $oob();
      }
      _M0MPC28internal7strconv7Decimal11shift__priv(self, -n | 0);
      exponent = exponent + n | 0;
      continue;
    } else {
      break;
    }
  }
  while (true) {
    let _tmp;
    if (self.decimal_point < 0) {
      _tmp = true;
    } else {
      let _tmp$2;
      if (self.decimal_point === 0) {
        const _tmp$3 = self.digits;
        _tmp$2 = (0 >>> 0 < _tmp$3.length ? _tmp$3[0] : $oob()) < 5;
      } else {
        _tmp$2 = false;
      }
      _tmp = _tmp$2;
    }
    if (_tmp) {
      let n;
      if ((-self.decimal_point | 0) >= _M0FPC28internal7strconv6powtab.length) {
        n = 60;
      } else {
        const _p = -self.decimal_point | 0;
        n = _p >>> 0 < _M0FPC28internal7strconv6powtab.length ? _M0FPC28internal7strconv6powtab[_p] : $oob();
      }
      _M0MPC28internal7strconv7Decimal11shift__priv(self, n);
      exponent = exponent - n | 0;
      continue;
    } else {
      break;
    }
  }
  exponent = exponent - 1 | 0;
  if (exponent < (_M0FPC28internal7strconv12double__info.bias + 1 | 0)) {
    const n = (_M0FPC28internal7strconv12double__info.bias + 1 | 0) - exponent | 0;
    _M0MPC28internal7strconv7Decimal11shift__priv(self, -n | 0);
    exponent = exponent + n | 0;
  }
  if ((exponent - _M0FPC28internal7strconv12double__info.bias | 0) >= ((1 << _M0FPC28internal7strconv12double__info.exponent_bits) - 1 | 0)) {
    const _bind = _M0FPC28internal7strconv10range__errGuE();
    if (_bind.$tag === 1) {
      const _ok = _bind;
      _ok._0;
    } else {
      return _bind;
    }
  }
  _M0MPC28internal7strconv7Decimal11shift__priv(self, _M0FPC28internal7strconv12double__info.mantissa_bits + 1 | 0);
  mantissa = _M0MPC28internal7strconv7Decimal16rounded__integer(self);
  if (BigInt.asUintN(64, mantissa) === BigInt.asUintN(64, BigInt.asUintN(64, 2n << BigInt(_M0FPC28internal7strconv12double__info.mantissa_bits & 63)))) {
    mantissa = BigInt.asUintN(64, BigInt.asIntN(64, mantissa) >> BigInt(1 & 63));
    exponent = exponent + 1 | 0;
    if ((exponent - _M0FPC28internal7strconv12double__info.bias | 0) >= ((1 << _M0FPC28internal7strconv12double__info.exponent_bits) - 1 | 0)) {
      const _bind = _M0FPC28internal7strconv10range__errGuE();
      if (_bind.$tag === 1) {
        const _ok = _bind;
        _ok._0;
      } else {
        return _bind;
      }
    }
  }
  if (BigInt.asUintN(64, BigInt.asUintN(64, mantissa & BigInt.asUintN(64, 1n << BigInt(_M0FPC28internal7strconv12double__info.mantissa_bits & 63)))) === BigInt.asUintN(64, 0n)) {
    exponent = _M0FPC28internal7strconv12double__info.bias;
  }
  const bits = _M0FPC28internal7strconv14assemble__bits(mantissa, exponent, self.negative);
  return new _M0DTPC16result6ResultGdRPC15error5ErrorE2Ok($i64_reinterpret_f64(bits));
}
function _M0FPC28internal7strconv17pow10__fast__path(exponent) {
  const _p = exponent & 31;
  return _p >>> 0 < _M0FPC28internal7strconv5table.length ? _M0FPC28internal7strconv5table[_p] : $oob();
}
function _M0MPC28internal7strconv6Number14is__fast__path(self) {
  return BigInt.asIntN(64, _M0FPC28internal7strconv25min__exponent__fast__path) <= BigInt.asIntN(64, self.exponent) && (BigInt.asIntN(64, self.exponent) <= BigInt.asIntN(64, _M0FPC28internal7strconv36max__exponent__disguised__fast__path) && (BigInt.asUintN(64, self.mantissa) <= BigInt.asUintN(64, _M0FPC28internal7strconv25max__mantissa__fast__path) && !self.many_digits));
}
function _M0MPC28internal7strconv6Number15try__fast__path(self) {
  if (_M0MPC28internal7strconv6Number14is__fast__path(self)) {
    let value;
    if (BigInt.asIntN(64, self.exponent) <= BigInt.asIntN(64, _M0FPC28internal7strconv25max__exponent__fast__path)) {
      const value$2 = $f64_convert_i64_u(BigInt.asUintN(64, self.mantissa));
      value = BigInt.asIntN(64, self.exponent) < BigInt.asIntN(64, 0n) ? value$2 / _M0FPC28internal7strconv17pow10__fast__path(-(Number(BigInt.asIntN(32, self.exponent)) | 0) | 0) : value$2 * _M0FPC28internal7strconv17pow10__fast__path(Number(BigInt.asIntN(32, self.exponent)) | 0);
    } else {
      const shift = BigInt.asUintN(64, self.exponent - _M0FPC28internal7strconv25max__exponent__fast__path);
      const _tmp = self.mantissa;
      const _p = Number(BigInt.asIntN(32, shift)) | 0;
      const _bind = _M0FPC28internal7strconv12checked__mul(_tmp, _p >>> 0 < _M0FPC28internal7strconv10int__pow10.length ? _M0FPC28internal7strconv10int__pow10[_p] : $oob());
      if (_bind === undefined) {
        return _M0DTPC16option6OptionGdE4None__;
      } else {
        const _Some = _bind;
        const _mantissa = _Some;
        if (BigInt.asUintN(64, _mantissa) > BigInt.asUintN(64, _M0FPC28internal7strconv25max__mantissa__fast__path)) {
          return _M0DTPC16option6OptionGdE4None__;
        }
        value = $f64_convert_i64_u(BigInt.asUintN(64, _mantissa)) * _M0FPC28internal7strconv17pow10__fast__path(Number(BigInt.asIntN(32, _M0FPC28internal7strconv25max__exponent__fast__path)) | 0);
      }
    }
    return new _M0DTPC16option6OptionGdE4Some(self.negative ? -value : value);
  } else {
    return _M0DTPC16option6OptionGdE4None__;
  }
}
function _M0FPC28internal7strconv13parse__double(str) {
  if (!((str.end - str.start | 0) === 0)) {
    if (_M0FPC28internal7strconv17check__underscore(str)) {
      const _bind = _M0FPC28internal7strconv13parse__number(str);
      let _bind$2;
      if (_bind.$tag === 1) {
        const _ok = _bind;
        _bind$2 = _ok._0;
      } else {
        return _bind;
      }
      if (_bind$2 === undefined) {
        return _M0FPC28internal7strconv15parse__inf__nan(str);
      } else {
        const _Some = _bind$2;
        const _num = _Some;
        const _bind$3 = _M0MPC28internal7strconv6Number15try__fast__path(_num);
        if (_bind$3.$tag === 1) {
          const _Some$2 = _bind$3;
          const _value = _Some$2._0;
          return new _M0DTPC16result6ResultGdRPC15error5ErrorE2Ok(_value);
        } else {
          const fast = _num.many_digits ? _M0FPC16double14not__a__number : _M0FPC28internal7strconv20try__eisel__lemire64(_num.mantissa, _num.exponent, _num.negative);
          if (fast !== fast) {
            const _bind$4 = _M0FPC28internal7strconv20parse__decimal__priv(str);
            let _tmp;
            if (_bind$4.$tag === 1) {
              const _ok = _bind$4;
              _tmp = _ok._0;
            } else {
              return _bind$4;
            }
            return _M0MPC28internal7strconv7Decimal16to__double__priv(_tmp);
          } else {
            return new _M0DTPC16result6ResultGdRPC15error5ErrorE2Ok(fast);
          }
        }
      }
    } else {
      return _M0FPC28internal7strconv11syntax__errGdE();
    }
  } else {
    return _M0FPC28internal7strconv11syntax__errGdE();
  }
}
function _M0FPC28encoding4utf814encode_2einner(str, bom) {
  return _M0FPC28encoding4utf816encode__utf8__js(str.str, str.start, str.end - str.start | 0, bom);
}
function _M0FP212moonbitstack8moonjson14compare__names(a, b) {
  const ba = _M0FPC28encoding4utf814encode_2einner(new _M0TPC16string10StringView(a, 0, a.length), false);
  const bb = _M0FPC28encoding4utf814encode_2einner(new _M0TPC16string10StringView(b, 0, b.length), false);
  let i = 0;
  while (true) {
    if (i < ba.length && i < bb.length) {
      const _tmp = i;
      const x = _tmp >>> 0 < ba.length ? ba[_tmp] : $oob();
      const _tmp$2 = i;
      const y = _tmp$2 >>> 0 < bb.length ? bb[_tmp$2] : $oob();
      if (x !== y) {
        return x - y | 0;
      }
      i = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return ba.length - bb.length | 0;
}
function _M0FP212moonbitstack8moonjson7newline(out, indent, level) {
  if (indent > 0) {
    _M0IPB13StringBuilderPB6Logger11write__char(out, 10);
    const _bind = Math.imul(indent, level) | 0;
    let _tmp = 0;
    while (true) {
      const _ = _tmp;
      if (_ < _bind) {
        _M0IPB13StringBuilderPB6Logger11write__char(out, 32);
        _tmp = _ + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  } else {
    return;
  }
}
function _M0FP212moonbitstack8moonjson11hex__escape(c) {
  const out = _M0MPB13StringBuilder21StringBuilder_2einner(8);
  _M0IPB13StringBuilderPB6Logger13write__string(out, "\\u");
  let _bind_buf = [12, 8, 4, 0];
  let _bind_len = 4;
  const _bind = _bind_len;
  const _bind$2 = _bind_buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const shift = _bind$2[_];
      const _p = _M0MPC16string6String9get__char(_M0FP212moonbitstack8moonjson11hex__escapeN6digitsS2928, c >> shift & 15);
      _M0IPB13StringBuilderPB6Logger11write__char(out, _p === -1 ? $panic() : _p);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return out.val;
}
function _M0FP212moonbitstack8moonjson5quote(out, s, ascii) {
  _M0IPB13StringBuilderPB6Logger11write__char(out, 34);
  let run = 0;
  const _bind = s.end - s.start | 0;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      if (i < 0 || i >= (s.end - s.start | 0)) {
        $panic();
      }
      const c = s.str.charCodeAt(s.start + i | 0);
      let escape;
      switch (c) {
        case 34: {
          escape = "\\\"";
          break;
        }
        case 92: {
          escape = "\\\\";
          break;
        }
        case 8: {
          escape = "\\b";
          break;
        }
        case 12: {
          escape = "\\f";
          break;
        }
        case 10: {
          escape = "\\n";
          break;
        }
        case 13: {
          escape = "\\r";
          break;
        }
        case 9: {
          escape = "\\t";
          break;
        }
        default: {
          escape = c < 32 || ascii && c > 126 ? _M0FP212moonbitstack8moonjson11hex__escape(c) : "";
        }
      }
      const _p = "";
      if (!(escape === _p)) {
        _M0IPB13StringBuilderPB6Logger11write__view(out, _M0MPC16string10StringView21clamped__view_2einner(s, run, i));
        _M0IPB13StringBuilderPB6Logger13write__string(out, escape);
        run = i + 1 | 0;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0IPB13StringBuilderPB6Logger11write__view(out, _M0MPC16string10StringView21clamped__view_2einner(s, run, undefined));
  _M0IPB13StringBuilderPB6Logger11write__char(out, 34);
}
function _M0FP212moonbitstack8moonjson3put(out, value, indent, level, ascii, sort) {
  switch (value.$tag) {
    case 0: {
      _M0IPB13StringBuilderPB6Logger13write__string(out, "null");
      return;
    }
    case 1: {
      _M0IPB13StringBuilderPB6Logger13write__string(out, "true");
      return;
    }
    case 2: {
      _M0IPB13StringBuilderPB6Logger13write__string(out, "false");
      return;
    }
    case 3: {
      const _Number = value;
      const _n = _Number._0;
      const _repr = _Number._1;
      if (_repr === undefined) {
        if (_n !== _n || (_n > _M0FPB18double__max__value || _n < _M0FPB18double__min__value)) {
          _M0IPB13StringBuilderPB6Logger13write__string(out, "null");
          return;
        } else {
          _M0IPB13StringBuilderPB6Logger13write__string(out, String(_n));
          return;
        }
      } else {
        const _Some = _repr;
        const _text = _Some;
        _M0IPB13StringBuilderPB6Logger13write__string(out, _text);
        return;
      }
    }
    case 4: {
      const _String = value;
      const _s = _String._0;
      _M0FP212moonbitstack8moonjson5quote(out, new _M0TPC16string10StringView(_s, 0, _s.length), ascii);
      return;
    }
    case 5: {
      const _Array = value;
      const _items = _Array._0;
      if (_items.len === 0) {
        _M0IPB13StringBuilderPB6Logger13write__string(out, "[]");
        return undefined;
      }
      _M0IPB13StringBuilderPB6Logger11write__char(out, 91);
      const _bind = _items.len;
      const _bind$2 = _items.buf;
      let _tmp = 0;
      while (true) {
        const k = _tmp;
        if (k < _bind) {
          const item = _bind$2[k];
          if (k > 0) {
            _M0IPB13StringBuilderPB6Logger11write__char(out, 44);
          }
          _M0FP212moonbitstack8moonjson7newline(out, indent, level + 1 | 0);
          _M0FP212moonbitstack8moonjson3put(out, item, indent, level + 1 | 0, ascii, sort);
          _tmp = k + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      _M0FP212moonbitstack8moonjson7newline(out, indent, level);
      _M0IPB13StringBuilderPB6Logger11write__char(out, 93);
      return;
    }
    default: {
      const _Object = value;
      const _members = _Object._0;
      if (_members.size === 0) {
        _M0IPB13StringBuilderPB6Logger13write__string(out, "{}");
        return undefined;
      }
      _M0IPB13StringBuilderPB6Logger11write__char(out, 123);
      const names = new _M0TPB5ArrayGsE([], 0);
      const _it = _M0MPB3Map5iter2GsRPC14json4JsonE(_members);
      while (true) {
        const _bind$3 = _M0MPB5Iter24nextGsRPC14json4JsonE(_it);
        if (_bind$3 === undefined) {
          break;
        } else {
          const _Some = _bind$3;
          const _x = _Some;
          const _name = _x._0;
          _M0MPC15array5Array4pushGRP312moonbitstack7moonstl4text6OpcodeE(names, _name);
          continue;
        }
      }
      if (sort) {
        _M0MPC15array5Array8sort__byGUciEE(names, _M0FP212moonbitstack8moonjson14compare__names);
      }
      let first = true;
      const _bind$3 = names.len;
      const _bind$4 = names.buf;
      let _tmp$2 = 0;
      while (true) {
        const _ = _tmp$2;
        if (_ < _bind$3) {
          const name = _bind$4[_];
          if (!first) {
            _M0IPB13StringBuilderPB6Logger11write__char(out, 44);
          }
          first = false;
          _M0FP212moonbitstack8moonjson7newline(out, indent, level + 1 | 0);
          _M0FP212moonbitstack8moonjson5quote(out, new _M0TPC16string10StringView(name, 0, name.length), ascii);
          _M0IPB13StringBuilderPB6Logger11write__char(out, 58);
          if (indent > 0) {
            _M0IPB13StringBuilderPB6Logger11write__char(out, 32);
          }
          const _p = _M0MPB3Map3getGsRPC14json4JsonE(_members, name);
          let _tmp$3;
          if (_p === undefined) {
            _tmp$3 = $panic();
          } else {
            const _p$2 = _p;
            _tmp$3 = _p$2;
          }
          _M0FP212moonbitstack8moonjson3put(out, _tmp$3, indent, level + 1 | 0, ascii, sort);
          _tmp$2 = _ + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      _M0FP212moonbitstack8moonjson7newline(out, indent, level);
      _M0IPB13StringBuilderPB6Logger11write__char(out, 125);
      return;
    }
  }
}
function _M0FP212moonbitstack8moonjson13dumps_2einner(value, indent, ascii, sort) {
  const out = _M0MPB13StringBuilder21StringBuilder_2einner(8);
  _M0FP212moonbitstack8moonjson3put(out, value, indent, 0, ascii, sort);
  return out.val;
}
function _M0FP212moonbitstack8moonjson10ends__line(c) {
  return c === 10 || (c === 13 || (c === 8232 || c === 8233));
}
function _M0FP212moonbitstack8moonjson16is__extra__space(c) {
  return c === 11 || (c === 12 || (c === 160 || (c === 65279 || (c === 8232 || (c === 8233 || (c === 5760 || (c >= 8192 && c <= 8202 || (c === 8239 || (c === 8287 || c === 12288)))))))));
}
function _M0MP212moonbitstack8moonjson6Reader4peek(self, k) {
  const _bind = self.src;
  if (k < (_bind.end - _bind.start | 0)) {
    const _bind$2 = self.src;
    if (k < 0 || k >= (_bind$2.end - _bind$2.start | 0)) {
      $panic();
    }
    return _bind$2.str.charCodeAt(_bind$2.start + k | 0);
  } else {
    return -1;
  }
}
function _M0MP212moonbitstack8moonjson6Reader4here(self) {
  return _M0MP212moonbitstack8moonjson6Reader4peek(self, self.i);
}
function _M0MP212moonbitstack8moonjson6Reader4spot(self, at) {
  let line = 1;
  let column = 1;
  let _tmp = 0;
  while (true) {
    const k = _tmp;
    if (k < at) {
      const _bind = self.src;
      if (k < 0 || k >= (_bind.end - _bind.start | 0)) {
        $panic();
      }
      if (_bind.str.charCodeAt(_bind.start + k | 0) === 10) {
        line = line + 1 | 0;
        column = 1;
      } else {
        column = column + 1 | 0;
      }
      _tmp = k + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0TP212moonbitstack8moonjson2At(at, line, column);
}
function _M0MP212moonbitstack8moonjson6Reader5space(self) {
  let going = true;
  while (true) {
    if (going) {
      const c = _M0MP212moonbitstack8moonjson6Reader4here(self);
      if (c === 32 || (c === 9 || (c === 10 || c === 13))) {
        self.i = self.i + 1 | 0;
      } else {
        if (self.flavor.extra_space && _M0FP212moonbitstack8moonjson16is__extra__space(c)) {
          self.i = self.i + 1 | 0;
        } else {
          if (self.flavor.comments && (c === 47 && _M0MP212moonbitstack8moonjson6Reader4peek(self, self.i + 1 | 0) === 47)) {
            self.i = self.i + 2 | 0;
            while (true) {
              if (_M0MP212moonbitstack8moonjson6Reader4here(self) >= 0 && !_M0FP212moonbitstack8moonjson10ends__line(_M0MP212moonbitstack8moonjson6Reader4here(self))) {
                self.i = self.i + 1 | 0;
                continue;
              } else {
                break;
              }
            }
          } else {
            if (self.flavor.comments && (c === 47 && _M0MP212moonbitstack8moonjson6Reader4peek(self, self.i + 1 | 0) === 42)) {
              const start = self.i;
              self.i = self.i + 2 | 0;
              let closed = false;
              while (true) {
                if (!closed) {
                  if (_M0MP212moonbitstack8moonjson6Reader4here(self) < 0) {
                    return new _M0DTPC16result6ResultGuRP212moonbitstack8moonjson7RefusedE3Err(new _M0DTPC15error5Error45moonbitstack_2fmoonjson_2eRefused_2eTruncated(_M0MP212moonbitstack8moonjson6Reader4spot(self, start)));
                  } else {
                    if (_M0MP212moonbitstack8moonjson6Reader4here(self) === 42 && _M0MP212moonbitstack8moonjson6Reader4peek(self, self.i + 1 | 0) === 47) {
                      self.i = self.i + 2 | 0;
                      closed = true;
                    } else {
                      self.i = self.i + 1 | 0;
                    }
                  }
                  continue;
                } else {
                  break;
                }
              }
            } else {
              going = false;
            }
          }
        }
      }
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPC16result6ResultGuRP212moonbitstack8moonjson7RefusedE2Ok(undefined);
}
function _M0MP212moonbitstack8moonjson6Reader4fail(self) {
  const c = _M0MP212moonbitstack8moonjson6Reader4here(self);
  return c < 0 ? new _M0DTPC15error5Error45moonbitstack_2fmoonjson_2eRefused_2eTruncated(_M0MP212moonbitstack8moonjson6Reader4spot(self, self.i)) : new _M0DTPC15error5Error46moonbitstack_2fmoonjson_2eRefused_2eUnexpected(_M0MP212moonbitstack8moonjson6Reader4spot(self, self.i), c);
}
function _M0FP212moonbitstack8moonjson14out__of__range(text) {
  if (0 >= (text.end - text.start | 0)) {
    $panic();
  }
  const negative = text.str.charCodeAt(text.start) === 45;
  let huge = true;
  const _bind = text.end - text.start | 0;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      if (i < 0 || i >= (text.end - text.start | 0)) {
        $panic();
      }
      const c = text.str.charCodeAt(text.start + i | 0);
      if (c === 101 || c === 69) {
        const _bind$2 = i + 1 | 0;
        if (_bind$2 < 0 || _bind$2 >= (text.end - text.start | 0)) {
          $panic();
        }
        huge = text.str.charCodeAt(text.start + _bind$2 | 0) !== 45;
        break;
      }
      if (c === 46) {
        let _tmp$2;
        if (i === (negative ? 2 : 1)) {
          const _bind$2 = i - 1 | 0;
          if (_bind$2 < 0 || _bind$2 >= (text.end - text.start | 0)) {
            $panic();
          }
          _tmp$2 = text.str.charCodeAt(text.start + _bind$2 | 0) === 48;
        } else {
          _tmp$2 = false;
        }
        huge = !_tmp$2;
        break;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return !huge ? (negative ? -0 : 0) : negative ? _M0FPC16double13neg__infinity : _M0FPC16double8infinity;
}
function _M0FP212moonbitstack8moonjson6nibble(c) {
  return c >= 48 && c <= 57 ? c - 48 | 0 : c >= 97 && c <= 102 ? (c - 97 | 0) + 10 | 0 : c >= 65 && c <= 70 ? (c - 65 | 0) + 10 | 0 : -1;
}
function _M0MP212moonbitstack8moonjson6Reader11hex__number(self, start, signed) {
  self.i = self.i + 2 | 0;
  const from = self.i;
  let value = 0;
  while (true) {
    if (_M0FP212moonbitstack8moonjson6nibble(_M0MP212moonbitstack8moonjson6Reader4here(self)) >= 0) {
      value = value * 16 + (_M0FP212moonbitstack8moonjson6nibble(_M0MP212moonbitstack8moonjson6Reader4here(self)) + 0);
      self.i = self.i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (self.i === from) {
    return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE3Err(new _M0DTPC15error5Error45moonbitstack_2fmoonjson_2eRefused_2eBadNumber(_M0MP212moonbitstack8moonjson6Reader4spot(self, start)));
  }
  const _p = signed ? -value : value;
  const _p$2 = undefined;
  return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE2Ok(new _M0DTPC14json4Json6Number(_p, _p$2));
}
function _M0MP212moonbitstack8moonjson6Reader4word(self, want) {
  const start = self.i;
  const _bind = want.length;
  let _tmp = 0;
  while (true) {
    const k = _tmp;
    if (k < _bind) {
      if (_M0MP212moonbitstack8moonjson6Reader4peek(self, start + k | 0) !== (k >>> 0 < want.length ? want.charCodeAt(k) : $oob())) {
        self.i = start + k | 0;
        return new _M0DTPC16result6ResultGuRP212moonbitstack8moonjson7RefusedE3Err(_M0MP212moonbitstack8moonjson6Reader4fail(self));
      }
      _tmp = k + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  self.i = start + want.length | 0;
  return new _M0DTPC16result6ResultGuRP212moonbitstack8moonjson7RefusedE2Ok(undefined);
}
function _M0MP212moonbitstack8moonjson6Reader6number(self) {
  const start = self.i;
  let signed = false;
  let plain = true;
  if (_M0MP212moonbitstack8moonjson6Reader4here(self) === 45) {
    signed = true;
    self.i = self.i + 1 | 0;
  } else {
    if (_M0MP212moonbitstack8moonjson6Reader4here(self) === 43) {
      if (!self.flavor.extra_numbers) {
        return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE3Err(_M0MP212moonbitstack8moonjson6Reader4fail(self));
      }
      self.i = self.i + 1 | 0;
      plain = false;
    }
  }
  if (self.flavor.extra_numbers) {
    if (_M0MP212moonbitstack8moonjson6Reader4here(self) === 73) {
      const _bind = _M0MP212moonbitstack8moonjson6Reader4word(self, "Infinity");
      if (_bind.$tag === 1) {
        const _ok = _bind;
        _ok._0;
      } else {
        return _bind;
      }
      const _p = signed ? _M0FPC16double13neg__infinity : _M0FPC16double8infinity;
      const _p$2 = undefined;
      return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE2Ok(new _M0DTPC14json4Json6Number(_p, _p$2));
    }
    if (_M0MP212moonbitstack8moonjson6Reader4here(self) === 78) {
      const _bind = _M0MP212moonbitstack8moonjson6Reader4word(self, "NaN");
      if (_bind.$tag === 1) {
        const _ok = _bind;
        _ok._0;
      } else {
        return _bind;
      }
      const _p = undefined;
      return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE2Ok(new _M0DTPC14json4Json6Number(_M0FPC16double14not__a__number, _p));
    }
    if (_M0MP212moonbitstack8moonjson6Reader4here(self) === 48 && (_M0MP212moonbitstack8moonjson6Reader4peek(self, self.i + 1 | 0) === 120 || _M0MP212moonbitstack8moonjson6Reader4peek(self, self.i + 1 | 0) === 88)) {
      const _bind = _M0MP212moonbitstack8moonjson6Reader11hex__number(self, start, signed);
      let _tmp;
      if (_bind.$tag === 1) {
        const _ok = _bind;
        _tmp = _ok._0;
      } else {
        return _bind;
      }
      return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE2Ok(_tmp);
    }
  }
  const int_start = self.i;
  while (true) {
    if (_M0MP212moonbitstack8moonjson6Reader4here(self) >= 48 && _M0MP212moonbitstack8moonjson6Reader4here(self) <= 57) {
      self.i = self.i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const digits = self.i - int_start | 0;
  if (digits === 0) {
    if (!(self.flavor.extra_numbers && _M0MP212moonbitstack8moonjson6Reader4here(self) === 46)) {
      return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE3Err(_M0MP212moonbitstack8moonjson6Reader4fail(self));
    }
    plain = false;
  } else {
    let _tmp;
    if (digits > 1) {
      const _bind = self.src;
      if (int_start < 0 || int_start >= (_bind.end - _bind.start | 0)) {
        $panic();
      }
      _tmp = _bind.str.charCodeAt(_bind.start + int_start | 0) === 48;
    } else {
      _tmp = false;
    }
    if (_tmp) {
      return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE3Err(new _M0DTPC15error5Error45moonbitstack_2fmoonjson_2eRefused_2eBadNumber(_M0MP212moonbitstack8moonjson6Reader4spot(self, start)));
    }
  }
  let fraction = 0;
  if (_M0MP212moonbitstack8moonjson6Reader4here(self) === 46) {
    self.i = self.i + 1 | 0;
    const frac = self.i;
    while (true) {
      if (_M0MP212moonbitstack8moonjson6Reader4here(self) >= 48 && _M0MP212moonbitstack8moonjson6Reader4here(self) <= 57) {
        self.i = self.i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    fraction = self.i - frac | 0;
    if (fraction === 0) {
      if (!self.flavor.extra_numbers) {
        return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE3Err(new _M0DTPC15error5Error45moonbitstack_2fmoonjson_2eRefused_2eBadNumber(_M0MP212moonbitstack8moonjson6Reader4spot(self, start)));
      }
      plain = false;
    }
  }
  if ((digits + fraction | 0) === 0) {
    return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE3Err(new _M0DTPC15error5Error45moonbitstack_2fmoonjson_2eRefused_2eBadNumber(_M0MP212moonbitstack8moonjson6Reader4spot(self, start)));
  }
  if (_M0MP212moonbitstack8moonjson6Reader4here(self) === 101 || _M0MP212moonbitstack8moonjson6Reader4here(self) === 69) {
    self.i = self.i + 1 | 0;
    if (_M0MP212moonbitstack8moonjson6Reader4here(self) === 43 || _M0MP212moonbitstack8moonjson6Reader4here(self) === 45) {
      self.i = self.i + 1 | 0;
    }
    const exp = self.i;
    while (true) {
      if (_M0MP212moonbitstack8moonjson6Reader4here(self) >= 48 && _M0MP212moonbitstack8moonjson6Reader4here(self) <= 57) {
        self.i = self.i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    if (self.i === exp) {
      return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE3Err(new _M0DTPC15error5Error45moonbitstack_2fmoonjson_2eRefused_2eBadNumber(_M0MP212moonbitstack8moonjson6Reader4spot(self, start)));
    }
  }
  const text = _M0MPC16string10StringView21clamped__view_2einner(self.src, start, self.i);
  let value;
  let _try_err;
  _L: {
    _L$2: {
      const _bind = _M0FPC28internal7strconv13parse__double(text);
      if (_bind.$tag === 1) {
        const _ok = _bind;
        value = _ok._0;
      } else {
        const _err = _bind;
        _try_err = _err._0;
        break _L$2;
      }
      break _L;
    }
    value = _M0FP212moonbitstack8moonjson14out__of__range(text);
  }
  let _tmp;
  if (plain) {
    const _p = _M0MPC16string10StringView9to__owned(text);
    _tmp = new _M0DTPC14json4Json6Number(value, _p);
  } else {
    const _p = undefined;
    _tmp = new _M0DTPC14json4Json6Number(value, _p);
  }
  return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE2Ok(_tmp);
}
function _M0FP212moonbitstack8moonjson14is__name__part(c, first) {
  return c === 36 || (c === 95 || (c >= 65 && c <= 90 || (c >= 97 && c <= 122 || (c > 127 || !first && (c >= 48 && c <= 57)))));
}
function _M0MP212moonbitstack8moonjson6Reader4quad(self, start) {
  let v = 0;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < 4) {
      const d = _M0FP212moonbitstack8moonjson6nibble(_M0MP212moonbitstack8moonjson6Reader4here(self));
      if (d < 0) {
        return new _M0DTPC16result6ResultGiRP212moonbitstack8moonjson7RefusedE3Err(new _M0DTPC15error5Error45moonbitstack_2fmoonjson_2eRefused_2eBadEscape(_M0MP212moonbitstack8moonjson6Reader4spot(self, start)));
      }
      v = v << 4 | d;
      self.i = self.i + 1 | 0;
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPC16result6ResultGiRP212moonbitstack8moonjson7RefusedE2Ok(v);
}
function _M0MP212moonbitstack8moonjson6Reader4name(self) {
  const begin = self.i;
  const out = _M0MPB13StringBuilder21StringBuilder_2einner(8);
  let run = self.i;
  let first = true;
  let escaped = false;
  while (true) {
    const c = _M0MP212moonbitstack8moonjson6Reader4here(self);
    if (c === 92 && _M0MP212moonbitstack8moonjson6Reader4peek(self, self.i + 1 | 0) === 117) {
      _M0IPB13StringBuilderPB6Logger11write__view(out, _M0MPC16string10StringView21clamped__view_2einner(self.src, run, self.i));
      const at = self.i;
      self.i = self.i + 2 | 0;
      const _bind = _M0MP212moonbitstack8moonjson6Reader4quad(self, at);
      let value;
      if (_bind.$tag === 1) {
        const _ok = _bind;
        value = _ok._0;
      } else {
        return _bind;
      }
      if (!_M0FP212moonbitstack8moonjson14is__name__part(value, first)) {
        return new _M0DTPC16result6ResultGsRP212moonbitstack8moonjson7RefusedE3Err(new _M0DTPC15error5Error45moonbitstack_2fmoonjson_2eRefused_2eBadEscape(_M0MP212moonbitstack8moonjson6Reader4spot(self, at)));
      }
      _M0IPB13StringBuilderPB6Logger11write__char(out, value);
      first = false;
      escaped = true;
      run = self.i;
      continue;
    }
    if (!_M0FP212moonbitstack8moonjson14is__name__part(c, first)) {
      break;
    }
    self.i = self.i + 1 | 0;
    first = false;
    continue;
  }
  if (first) {
    return new _M0DTPC16result6ResultGsRP212moonbitstack8moonjson7RefusedE3Err(_M0MP212moonbitstack8moonjson6Reader4fail(self));
  }
  if (!escaped) {
    return new _M0DTPC16result6ResultGsRP212moonbitstack8moonjson7RefusedE2Ok(_M0MPC16string10StringView9to__owned(_M0MPC16string10StringView21clamped__view_2einner(self.src, begin, self.i)));
  }
  _M0IPB13StringBuilderPB6Logger11write__view(out, _M0MPC16string10StringView21clamped__view_2einner(self.src, run, self.i));
  return new _M0DTPC16result6ResultGsRP212moonbitstack8moonjson7RefusedE2Ok(out.val);
}
function _M0MP212moonbitstack8moonjson6Reader9hex__byte(self, start) {
  const hi = _M0FP212moonbitstack8moonjson6nibble(_M0MP212moonbitstack8moonjson6Reader4here(self));
  const lo = _M0FP212moonbitstack8moonjson6nibble(_M0MP212moonbitstack8moonjson6Reader4peek(self, self.i + 1 | 0));
  if (hi < 0 || lo < 0) {
    return new _M0DTPC16result6ResultGcRP212moonbitstack8moonjson7RefusedE3Err(new _M0DTPC15error5Error45moonbitstack_2fmoonjson_2eRefused_2eBadEscape(_M0MP212moonbitstack8moonjson6Reader4spot(self, start)));
  }
  self.i = self.i + 2 | 0;
  return new _M0DTPC16result6ResultGcRP212moonbitstack8moonjson7RefusedE2Ok(hi << 4 | lo);
}
function _M0MP212moonbitstack8moonjson6Reader13loose__escape(self, out, c, start) {
  if (c < 0) {
    return new _M0DTPC16result6ResultGuRP212moonbitstack8moonjson7RefusedE3Err(new _M0DTPC15error5Error45moonbitstack_2fmoonjson_2eRefused_2eTruncated(_M0MP212moonbitstack8moonjson6Reader4spot(self, start)));
  }
  if (!self.flavor.extra_escapes) {
    return new _M0DTPC16result6ResultGuRP212moonbitstack8moonjson7RefusedE3Err(new _M0DTPC15error5Error45moonbitstack_2fmoonjson_2eRefused_2eBadEscape(_M0MP212moonbitstack8moonjson6Reader4spot(self, start)));
  }
  switch (c) {
    case 10: {
      return new _M0DTPC16result6ResultGuRP212moonbitstack8moonjson7RefusedE2Ok(undefined);
    }
    case 8232: {
      return new _M0DTPC16result6ResultGuRP212moonbitstack8moonjson7RefusedE2Ok(undefined);
    }
    case 8233: {
      return new _M0DTPC16result6ResultGuRP212moonbitstack8moonjson7RefusedE2Ok(undefined);
    }
    case 13: {
      if (_M0MP212moonbitstack8moonjson6Reader4here(self) === 10) {
        self.i = self.i + 1 | 0;
        return new _M0DTPC16result6ResultGuRP212moonbitstack8moonjson7RefusedE2Ok(undefined);
      } else {
        return new _M0DTPC16result6ResultGuRP212moonbitstack8moonjson7RefusedE2Ok(undefined);
      }
    }
    case 118: {
      return new _M0DTPC16result6ResultGuRP212moonbitstack8moonjson7RefusedE2Ok(_M0IPB13StringBuilderPB6Logger11write__char(out, 11));
    }
    case 120: {
      const _bind = _M0MP212moonbitstack8moonjson6Reader9hex__byte(self, start);
      let _tmp;
      if (_bind.$tag === 1) {
        const _ok = _bind;
        _tmp = _ok._0;
      } else {
        return _bind;
      }
      return new _M0DTPC16result6ResultGuRP212moonbitstack8moonjson7RefusedE2Ok(_M0IPB13StringBuilderPB6Logger11write__char(out, _tmp));
    }
    case 48: {
      if (_M0MP212moonbitstack8moonjson6Reader4here(self) >= 48 && _M0MP212moonbitstack8moonjson6Reader4here(self) <= 57) {
        return new _M0DTPC16result6ResultGuRP212moonbitstack8moonjson7RefusedE3Err(new _M0DTPC15error5Error45moonbitstack_2fmoonjson_2eRefused_2eBadEscape(_M0MP212moonbitstack8moonjson6Reader4spot(self, start)));
      } else {
        return new _M0DTPC16result6ResultGuRP212moonbitstack8moonjson7RefusedE2Ok(_M0IPB13StringBuilderPB6Logger11write__char(out, 0));
      }
    }
    default: {
      if (c >= 49 && c <= 57) {
        return new _M0DTPC16result6ResultGuRP212moonbitstack8moonjson7RefusedE3Err(new _M0DTPC15error5Error45moonbitstack_2fmoonjson_2eRefused_2eBadEscape(_M0MP212moonbitstack8moonjson6Reader4spot(self, start)));
      } else {
        return new _M0DTPC16result6ResultGuRP212moonbitstack8moonjson7RefusedE2Ok(_M0IPB13StringBuilderPB6Logger11write__char(out, c));
      }
    }
  }
}
function _M0MP212moonbitstack8moonjson6Reader7unicode(self, start) {
  const _bind = _M0MP212moonbitstack8moonjson6Reader4quad(self, start);
  let hi;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    hi = _ok._0;
  } else {
    return _bind;
  }
  if (hi < 55296 || hi > 57343) {
    return new _M0DTPC16result6ResultGcRP212moonbitstack8moonjson7RefusedE2Ok(hi);
  }
  if (hi >= 56320) {
    if (self.flavor.surrogates) {
      return new _M0DTPC16result6ResultGcRP212moonbitstack8moonjson7RefusedE2Ok(65533);
    }
    return new _M0DTPC16result6ResultGcRP212moonbitstack8moonjson7RefusedE3Err(new _M0DTPC15error5Error45moonbitstack_2fmoonjson_2eRefused_2eBadEscape(_M0MP212moonbitstack8moonjson6Reader4spot(self, start)));
  }
  if (_M0MP212moonbitstack8moonjson6Reader4here(self) !== 92 || _M0MP212moonbitstack8moonjson6Reader4peek(self, self.i + 1 | 0) !== 117) {
    if (self.flavor.surrogates) {
      return new _M0DTPC16result6ResultGcRP212moonbitstack8moonjson7RefusedE2Ok(65533);
    }
    return new _M0DTPC16result6ResultGcRP212moonbitstack8moonjson7RefusedE3Err(new _M0DTPC15error5Error45moonbitstack_2fmoonjson_2eRefused_2eBadEscape(_M0MP212moonbitstack8moonjson6Reader4spot(self, start)));
  }
  const pair = self.i;
  self.i = self.i + 2 | 0;
  const _bind$2 = _M0MP212moonbitstack8moonjson6Reader4quad(self, pair);
  let lo;
  if (_bind$2.$tag === 1) {
    const _ok = _bind$2;
    lo = _ok._0;
  } else {
    return _bind$2;
  }
  if (lo < 56320 || lo > 57343) {
    if (self.flavor.surrogates) {
      return new _M0DTPC16result6ResultGcRP212moonbitstack8moonjson7RefusedE2Ok(65533);
    }
    return new _M0DTPC16result6ResultGcRP212moonbitstack8moonjson7RefusedE3Err(new _M0DTPC15error5Error45moonbitstack_2fmoonjson_2eRefused_2eBadEscape(_M0MP212moonbitstack8moonjson6Reader4spot(self, pair)));
  }
  return new _M0DTPC16result6ResultGcRP212moonbitstack8moonjson7RefusedE2Ok((65536 + (Math.imul(hi - 55296 | 0, 1024) | 0) | 0) + (lo - 56320 | 0) | 0);
}
function _M0MP212moonbitstack8moonjson6Reader6escape(self, out) {
  const start = self.i;
  self.i = self.i + 1 | 0;
  const c = _M0MP212moonbitstack8moonjson6Reader4here(self);
  self.i = self.i + 1 | 0;
  switch (c) {
    case 34: {
      return new _M0DTPC16result6ResultGuRP212moonbitstack8moonjson7RefusedE2Ok(_M0IPB13StringBuilderPB6Logger11write__char(out, 34));
    }
    case 92: {
      return new _M0DTPC16result6ResultGuRP212moonbitstack8moonjson7RefusedE2Ok(_M0IPB13StringBuilderPB6Logger11write__char(out, 92));
    }
    case 47: {
      return new _M0DTPC16result6ResultGuRP212moonbitstack8moonjson7RefusedE2Ok(_M0IPB13StringBuilderPB6Logger11write__char(out, 47));
    }
    case 98: {
      return new _M0DTPC16result6ResultGuRP212moonbitstack8moonjson7RefusedE2Ok(_M0IPB13StringBuilderPB6Logger11write__char(out, 8));
    }
    case 102: {
      return new _M0DTPC16result6ResultGuRP212moonbitstack8moonjson7RefusedE2Ok(_M0IPB13StringBuilderPB6Logger11write__char(out, 12));
    }
    case 110: {
      return new _M0DTPC16result6ResultGuRP212moonbitstack8moonjson7RefusedE2Ok(_M0IPB13StringBuilderPB6Logger11write__char(out, 10));
    }
    case 114: {
      return new _M0DTPC16result6ResultGuRP212moonbitstack8moonjson7RefusedE2Ok(_M0IPB13StringBuilderPB6Logger11write__char(out, 13));
    }
    case 116: {
      return new _M0DTPC16result6ResultGuRP212moonbitstack8moonjson7RefusedE2Ok(_M0IPB13StringBuilderPB6Logger11write__char(out, 9));
    }
    case 117: {
      const _bind = _M0MP212moonbitstack8moonjson6Reader7unicode(self, start);
      let _tmp;
      if (_bind.$tag === 1) {
        const _ok = _bind;
        _tmp = _ok._0;
      } else {
        return _bind;
      }
      return new _M0DTPC16result6ResultGuRP212moonbitstack8moonjson7RefusedE2Ok(_M0IPB13StringBuilderPB6Logger11write__char(out, _tmp));
    }
    default: {
      return _M0MP212moonbitstack8moonjson6Reader13loose__escape(self, out, c, start);
    }
  }
}
function _M0MP212moonbitstack8moonjson6Reader4text(self) {
  const quote = _M0MP212moonbitstack8moonjson6Reader4here(self);
  const open = self.i;
  self.i = self.i + 1 | 0;
  const out = _M0MPB13StringBuilder21StringBuilder_2einner(8);
  let run = self.i;
  while (true) {
    if (_M0MP212moonbitstack8moonjson6Reader4here(self) >= 0) {
      const c = _M0MP212moonbitstack8moonjson6Reader4here(self);
      if (c === quote) {
        _M0IPB13StringBuilderPB6Logger11write__view(out, _M0MPC16string10StringView21clamped__view_2einner(self.src, run, self.i));
        self.i = self.i + 1 | 0;
        return new _M0DTPC16result6ResultGsRP212moonbitstack8moonjson7RefusedE2Ok(out.val);
      }
      if (c === 92) {
        _M0IPB13StringBuilderPB6Logger11write__view(out, _M0MPC16string10StringView21clamped__view_2einner(self.src, run, self.i));
        const _bind = _M0MP212moonbitstack8moonjson6Reader6escape(self, out);
        if (_bind.$tag === 1) {
          const _ok = _bind;
          _ok._0;
        } else {
          return _bind;
        }
        run = self.i;
        continue;
      }
      if (c < 32) {
        return new _M0DTPC16result6ResultGsRP212moonbitstack8moonjson7RefusedE3Err(_M0MP212moonbitstack8moonjson6Reader4fail(self));
      }
      self.i = self.i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPC16result6ResultGsRP212moonbitstack8moonjson7RefusedE3Err(new _M0DTPC15error5Error45moonbitstack_2fmoonjson_2eRefused_2eTruncated(_M0MP212moonbitstack8moonjson6Reader4spot(self, open)));
}
function _M0MP212moonbitstack8moonjson6Reader5value(self, depth) {
  if (depth > self.flavor.depth) {
    return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE3Err(new _M0DTPC15error5Error43moonbitstack_2fmoonjson_2eRefused_2eTooDeep(_M0MP212moonbitstack8moonjson6Reader4spot(self, self.i)));
  }
  const _bind = _M0MP212moonbitstack8moonjson6Reader4here(self);
  switch (_bind) {
    case 123: {
      return _M0MP212moonbitstack8moonjson6Reader6object(self, depth);
    }
    case 91: {
      return _M0MP212moonbitstack8moonjson6Reader5array(self, depth);
    }
    case 34: {
      const _bind$2 = _M0MP212moonbitstack8moonjson6Reader4text(self);
      let _p;
      if (_bind$2.$tag === 1) {
        const _ok = _bind$2;
        _p = _ok._0;
      } else {
        return _bind$2;
      }
      return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE2Ok(new _M0DTPC14json4Json6String(_p));
    }
    case 39: {
      if (self.flavor.single_quotes) {
        const _bind$3 = _M0MP212moonbitstack8moonjson6Reader4text(self);
        let _p$2;
        if (_bind$3.$tag === 1) {
          const _ok = _bind$3;
          _p$2 = _ok._0;
        } else {
          return _bind$3;
        }
        return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE2Ok(new _M0DTPC14json4Json6String(_p$2));
      } else {
        return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE3Err(_M0MP212moonbitstack8moonjson6Reader4fail(self));
      }
    }
    case 116: {
      const _bind$3 = _M0MP212moonbitstack8moonjson6Reader4word(self, "true");
      if (_bind$3.$tag === 1) {
        const _ok = _bind$3;
        _ok._0;
      } else {
        return _bind$3;
      }
      return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE2Ok(_M0DTPC14json4Json4True__);
    }
    case 102: {
      const _bind$4 = _M0MP212moonbitstack8moonjson6Reader4word(self, "false");
      if (_bind$4.$tag === 1) {
        const _ok = _bind$4;
        _ok._0;
      } else {
        return _bind$4;
      }
      return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE2Ok(_M0DTPC14json4Json5False__);
    }
    case 110: {
      const _bind$5 = _M0MP212moonbitstack8moonjson6Reader4word(self, "null");
      if (_bind$5.$tag === 1) {
        const _ok = _bind$5;
        _ok._0;
      } else {
        return _bind$5;
      }
      return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE2Ok(_M0DTPC14json4Json4Null__);
    }
    default: {
      return _M0MP212moonbitstack8moonjson6Reader6number(self);
    }
  }
}
function _M0MP212moonbitstack8moonjson6Reader5array(self, depth) {
  const out = new _M0TPB5ArrayGRPC14json4JsonE([], 0);
  self.i = self.i + 1 | 0;
  const _bind = _M0MP212moonbitstack8moonjson6Reader5space(self);
  if (_bind.$tag === 1) {
    const _ok = _bind;
    _ok._0;
  } else {
    return _bind;
  }
  if (_M0MP212moonbitstack8moonjson6Reader4here(self) === 93) {
    self.i = self.i + 1 | 0;
    return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE2Ok(new _M0DTPC14json4Json5Array(out));
  }
  let open = true;
  while (true) {
    if (open) {
      const _bind$2 = _M0MP212moonbitstack8moonjson6Reader5space(self);
      if (_bind$2.$tag === 1) {
        const _ok = _bind$2;
        _ok._0;
      } else {
        return _bind$2;
      }
      const _bind$3 = _M0MP212moonbitstack8moonjson6Reader5value(self, depth + 1 | 0);
      let _tmp;
      if (_bind$3.$tag === 1) {
        const _ok = _bind$3;
        _tmp = _ok._0;
      } else {
        return _bind$3;
      }
      _M0MPC15array5Array4pushGRP312moonbitstack7moonstl4text6OpcodeE(out, _tmp);
      const _bind$4 = _M0MP212moonbitstack8moonjson6Reader5space(self);
      if (_bind$4.$tag === 1) {
        const _ok = _bind$4;
        _ok._0;
      } else {
        return _bind$4;
      }
      const _bind$5 = _M0MP212moonbitstack8moonjson6Reader4here(self);
      switch (_bind$5) {
        case 44: {
          self.i = self.i + 1 | 0;
          const _bind$6 = _M0MP212moonbitstack8moonjson6Reader5space(self);
          if (_bind$6.$tag === 1) {
            const _ok = _bind$6;
            _ok._0;
          } else {
            return _bind$6;
          }
          if (_M0MP212moonbitstack8moonjson6Reader4here(self) === 93) {
            if (!self.flavor.trailing_commas) {
              return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE3Err(_M0MP212moonbitstack8moonjson6Reader4fail(self));
            }
            self.i = self.i + 1 | 0;
            open = false;
          }
          break;
        }
        case 93: {
          self.i = self.i + 1 | 0;
          open = false;
          break;
        }
        default: {
          return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE3Err(_M0MP212moonbitstack8moonjson6Reader4fail(self));
        }
      }
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE2Ok(new _M0DTPC14json4Json5Array(out));
}
function _M0MP212moonbitstack8moonjson6Reader6object(self, depth) {
  const _bind = [];
  const out = _M0MPB3Map3MapGsRPC14json4JsonE(new _M0TPB9ArrayViewGUsRPC14json4JsonEE(_bind, 0, 0), undefined);
  self.i = self.i + 1 | 0;
  const _bind$2 = _M0MP212moonbitstack8moonjson6Reader5space(self);
  if (_bind$2.$tag === 1) {
    const _ok = _bind$2;
    _ok._0;
  } else {
    return _bind$2;
  }
  if (_M0MP212moonbitstack8moonjson6Reader4here(self) === 125) {
    self.i = self.i + 1 | 0;
    return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE2Ok(new _M0DTPC14json4Json6Object(out));
  }
  let open = true;
  while (true) {
    if (open) {
      const _bind$3 = _M0MP212moonbitstack8moonjson6Reader5space(self);
      if (_bind$3.$tag === 1) {
        const _ok = _bind$3;
        _ok._0;
      } else {
        return _bind$3;
      }
      let key;
      if (_M0MP212moonbitstack8moonjson6Reader4here(self) === 34 || self.flavor.single_quotes && _M0MP212moonbitstack8moonjson6Reader4here(self) === 39) {
        const _bind$4 = _M0MP212moonbitstack8moonjson6Reader4text(self);
        if (_bind$4.$tag === 1) {
          const _ok = _bind$4;
          key = _ok._0;
        } else {
          return _bind$4;
        }
      } else {
        if (self.flavor.unquoted_keys) {
          const _bind$4 = _M0MP212moonbitstack8moonjson6Reader4name(self);
          if (_bind$4.$tag === 1) {
            const _ok = _bind$4;
            key = _ok._0;
          } else {
            return _bind$4;
          }
        } else {
          return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE3Err(_M0MP212moonbitstack8moonjson6Reader4fail(self));
        }
      }
      const _bind$4 = _M0MP212moonbitstack8moonjson6Reader5space(self);
      if (_bind$4.$tag === 1) {
        const _ok = _bind$4;
        _ok._0;
      } else {
        return _bind$4;
      }
      if (_M0MP212moonbitstack8moonjson6Reader4here(self) !== 58) {
        return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE3Err(_M0MP212moonbitstack8moonjson6Reader4fail(self));
      }
      self.i = self.i + 1 | 0;
      const _bind$5 = _M0MP212moonbitstack8moonjson6Reader5space(self);
      if (_bind$5.$tag === 1) {
        const _ok = _bind$5;
        _ok._0;
      } else {
        return _bind$5;
      }
      const _bind$6 = _M0MP212moonbitstack8moonjson6Reader5value(self, depth + 1 | 0);
      let value;
      if (_bind$6.$tag === 1) {
        const _ok = _bind$6;
        value = _ok._0;
      } else {
        return _bind$6;
      }
      _L: {
        _L$2: {
          const _bind$7 = _M0MPB3Map3getGsRPC14json4JsonE(out, key);
          const _bind$8 = self.flavor.duplicates;
          if (_bind$7 === undefined) {
            break _L$2;
          } else {
            switch (_bind$8) {
              case 1: {
                break;
              }
              case 2: {
                return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE3Err(new _M0DTPC15error5Error44moonbitstack_2fmoonjson_2eRefused_2eRepeated(_M0MP212moonbitstack8moonjson6Reader4spot(self, self.i), key));
              }
              default: {
                break _L$2;
              }
            }
          }
          break _L;
        }
        _M0MPB3Map3setGsRPC14json4JsonE(out, key, value);
      }
      const _bind$7 = _M0MP212moonbitstack8moonjson6Reader5space(self);
      if (_bind$7.$tag === 1) {
        const _ok = _bind$7;
        _ok._0;
      } else {
        return _bind$7;
      }
      const _bind$8 = _M0MP212moonbitstack8moonjson6Reader4here(self);
      switch (_bind$8) {
        case 44: {
          self.i = self.i + 1 | 0;
          const _bind$9 = _M0MP212moonbitstack8moonjson6Reader5space(self);
          if (_bind$9.$tag === 1) {
            const _ok = _bind$9;
            _ok._0;
          } else {
            return _bind$9;
          }
          if (_M0MP212moonbitstack8moonjson6Reader4here(self) === 125) {
            if (!self.flavor.trailing_commas) {
              return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE3Err(_M0MP212moonbitstack8moonjson6Reader4fail(self));
            }
            self.i = self.i + 1 | 0;
            open = false;
          }
          break;
        }
        case 125: {
          self.i = self.i + 1 | 0;
          open = false;
          break;
        }
        default: {
          return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE3Err(_M0MP212moonbitstack8moonjson6Reader4fail(self));
        }
      }
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE2Ok(new _M0DTPC14json4Json6Object(out));
}
function _M0FP212moonbitstack8moonjson5loads(input, flavor) {
  const r = new _M0TP212moonbitstack8moonjson6Reader(input, flavor, 0);
  const _bind = _M0MP212moonbitstack8moonjson6Reader5space(r);
  if (_bind.$tag === 1) {
    const _ok = _bind;
    _ok._0;
  } else {
    return _bind;
  }
  const _bind$2 = _M0MP212moonbitstack8moonjson6Reader5value(r, 0);
  let value;
  if (_bind$2.$tag === 1) {
    const _ok = _bind$2;
    value = _ok._0;
  } else {
    return _bind$2;
  }
  const _bind$3 = _M0MP212moonbitstack8moonjson6Reader5space(r);
  if (_bind$3.$tag === 1) {
    const _ok = _bind$3;
    _ok._0;
  } else {
    return _bind$3;
  }
  const _tmp = r.i;
  const _bind$4 = r.src;
  if (_tmp < (_bind$4.end - _bind$4.start | 0)) {
    return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE3Err(new _M0DTPC15error5Error44moonbitstack_2fmoonjson_2eRefused_2eTrailing(_M0MP212moonbitstack8moonjson6Reader4spot(r, r.i)));
  }
  return new _M0DTPC16result6ResultGRPC14json4JsonRP212moonbitstack8moonjson7RefusedE2Ok(value);
}
function _M0IP212moonbitstack8moonseed11UnavailablePB4Show6output(self, logger) {
  let _tmp;
  switch (self.$tag) {
    case 3: {
      _tmp = "the platform has no entropy source";
      break;
    }
    case 2: {
      _tmp = "the replay source is exhausted";
      break;
    }
    default: {
      const _Failed = self;
      _tmp = _Failed._0;
    }
  }
  logger.method_table.method_0(logger.self, _tmp);
}
function _M0FP212moonbitstack8moonseed5bytesGRP312moonbitstack8moonseed6system6SystemE(n, source) {
  if (n < 0) {
    const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(35);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "moonseed.bytes: a negative length, ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, n);
    $panic(_string_builder.val);
  }
  const buf = $makebytes(n, 0);
  const _bind = _M0IP312moonbitstack8moonseed6system6SystemP212moonbitstack8moonseed6Source4fill(source, buf);
  if (_bind.$tag === 1) {
    const _ok = _bind;
    _ok._0;
  } else {
    return _bind;
  }
  return new _M0DTPC16result6ResultGzRP212moonbitstack8moonseed11UnavailableE2Ok(_M0MPC15bytes5Bytes11from__array(new _M0TPB9ArrayViewGyE(buf, 0, buf.length)));
}
function _M0FPC13env14rand__internal(to_be_filled) {
  if (to_be_filled.length === 0) {
    return true;
  }
  return _M0FPC13env23get__random__values__js(to_be_filled);
}
function _M0FPC13env4rand(n) {
  if (n <= 0) {
    const probe = $makebytes(1, 0);
    return _M0FPC13env14rand__internal(probe) ? _M0FPC13env4randN6constrS3126 : undefined;
  }
  const buf = $makebytes(n, 0);
  return _M0FPC13env14rand__internal(buf) ? _M0MPC15bytes5Bytes11from__array(new _M0TPB9ArrayViewGyE(buf, 0, buf.length)) : undefined;
}
function _M0IP312moonbitstack8moonseed6system6SystemP212moonbitstack8moonseed6Source4fill(_self, buf) {
  _L: {
    const _bind = _M0FPC13env4rand(buf.length);
    if (_bind === undefined) {
      break _L;
    } else {
      const _Some = _bind;
      const _got = _Some;
      if (_got.length === buf.length) {
        const _bind$2 = buf.length;
        let _tmp = 0;
        while (true) {
          const i = _tmp;
          if (i < _bind$2) {
            if (i >>> 0 < buf.length) {
              buf[i] = i >>> 0 < _got.length ? _got[i] : $oob();
            } else {
              $oob();
            }
            _tmp = i + 1 | 0;
            continue;
          } else {
            return new _M0DTPC16result6ResultGuRP212moonbitstack8moonseed11UnavailableE2Ok(undefined);
          }
        }
      } else {
        break _L;
      }
    }
  }
  return new _M0DTPC16result6ResultGuRP212moonbitstack8moonseed11UnavailableE3Err(_M0DTPC15error5Error48moonbitstack_2fmoonseed_2eUnavailable_2ePlatform__);
}
function _M0FP312moonbitstack7moonstl4spec5mix64(value) {
  let z = value;
  z = BigInt.asUintN(64, BigInt.asUintN(64, z ^ BigInt.asUintN(64, BigInt.asUintN(64, z) >> BigInt(30 & 63))) * 13787848793156543929n);
  z = BigInt.asUintN(64, BigInt.asUintN(64, z ^ BigInt.asUintN(64, BigInt.asUintN(64, z) >> BigInt(27 & 63))) * 10723151780598845931n);
  return BigInt.asUintN(64, z ^ BigInt.asUintN(64, BigInt.asUintN(64, z) >> BigInt(31 & 63)));
}
function _M0FP312moonbitstack7moonstl4spec16hash__seed__from(bytes) {
  let hash = 14695981039346656037n;
  const _bind = bytes.end - bytes.start | 0;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      const _tmp$2 = hash;
      if (i < 0 || i >= (bytes.end - bytes.start | 0)) {
        $panic();
      }
      const _p = bytes.buf[bytes.start + i | 0];
      hash = BigInt.asUintN(64, BigInt.asUintN(64, _tmp$2 ^ BigInt.asUintN(64, BigInt(_p))) * 1099511628211n);
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const mixed = _M0FP312moonbitstack7moonstl4spec5mix64(hash);
  const seed = Number(BigInt.asUintN(32, BigInt.asUintN(64, BigInt.asUintN(64, mixed) >> BigInt(32 & 63)))) | 0;
  return seed === 0 ? 1 : seed;
}
function _M0FP312moonbitstack7moonstl4spec19seed__from__entropy() {
  const _bind = _M0FP212moonbitstack8moonseed5bytesGRP312moonbitstack8moonseed6system6SystemE(32, _M0FP312moonbitstack8moonseed6system6source);
  let bytes;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    bytes = _ok._0;
  } else {
    return _bind;
  }
  return new _M0DTPC16result6ResultGiRPC15error5ErrorE2Ok(_M0FP312moonbitstack7moonstl4spec16hash__seed__from(new _M0TPC15bytes9BytesView(bytes, 0, bytes.length)));
}
function _M0FP312moonbitstack7moonstl4spec10hash__seed() {
  const _bind = _M0FP312moonbitstack7moonstl4spec11seed__state.value;
  if (_bind === undefined) {
    let drawn;
    let _try_err;
    _L: {
      _L$2: {
        const _bind$2 = _M0FP312moonbitstack7moonstl4spec19seed__from__entropy();
        let _tmp;
        if (_bind$2.$tag === 1) {
          const _ok = _bind$2;
          _tmp = _ok._0;
        } else {
          const _err = _bind$2;
          _try_err = _err._0;
          break _L$2;
        }
        drawn = new _M0DTPB6ResultGiuE2Ok(_tmp);
        break _L;
      }
      drawn = new _M0DTPB6ResultGiuE3Err(undefined);
    }
    if (drawn.$tag === 1) {
      const _Ok = drawn;
      const _seed = _Ok._0;
      _M0FP312moonbitstack7moonstl4spec11seed__state.value = _seed;
      _M0FP312moonbitstack7moonstl4spec11seed__state.random = true;
      return _seed;
    } else {
      _M0FP312moonbitstack7moonstl4spec11seed__state.value = _M0FP312moonbitstack7moonstl4spec10hash__seedN6constrS3149;
      _M0FP312moonbitstack7moonstl4spec11seed__state.random = false;
      return 0;
    }
  } else {
    const _Some = _bind;
    return _Some;
  }
}
function _M0IP312moonbitstack7moonstl4spec7RefusedPB4Show6output(self, logger) {
  switch (self.$tag) {
    case 12: {
      const _Capacity = self;
      const _got = _Capacity._0;
      const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(9);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "capacity ");
      _M0MPB13StringBuilder13write__objectGiE(_string_builder, _got);
      logger.method_table.method_0(logger.self, _string_builder.val);
      return;
    }
    case 11: {
      const _Probability = self;
      const _got$2 = _Probability._0;
      const _string_builder$2 = _M0MPB13StringBuilder21StringBuilder_2einner(12);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$2, "probability ");
      _M0MPB13StringBuilder13write__objectGdE(_string_builder$2, _got$2);
      logger.method_table.method_0(logger.self, _string_builder$2.val);
      return;
    }
    case 10: {
      const _Arity = self;
      const _got$3 = _Arity._0;
      const _string_builder$3 = _M0MPB13StringBuilder21StringBuilder_2einner(6);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$3, "arity ");
      _M0MPB13StringBuilder13write__objectGiE(_string_builder$3, _got$3);
      logger.method_table.method_0(logger.self, _string_builder$3.val);
      return;
    }
    case 9: {
      const _Precision = self;
      const _got$4 = _Precision._0;
      const _string_builder$4 = _M0MPB13StringBuilder21StringBuilder_2einner(10);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$4, "precision ");
      _M0MPB13StringBuilder13write__objectGiE(_string_builder$4, _got$4);
      logger.method_table.method_0(logger.self, _string_builder$4.val);
      return;
    }
    case 8: {
      logger.method_table.method_0(logger.self, "duplicate value");
      return;
    }
    case 7: {
      const _NonMonotone = self;
      const _got$5 = _NonMonotone._0;
      const _limit = _NonMonotone._1;
      const _string_builder$5 = _M0MPB13StringBuilder21StringBuilder_2einner(30);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$5, "key ");
      _M0MPB13StringBuilder13write__objectGmE(_string_builder$5, _got$5);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$5, " is below the last popped ");
      _M0MPB13StringBuilder13write__objectGmE(_string_builder$5, _limit);
      logger.method_table.method_0(logger.self, _string_builder$5.val);
      return;
    }
    case 6: {
      const _TooMany = self;
      const _limit$2 = _TooMany._0;
      const _string_builder$6 = _M0MPB13StringBuilder21StringBuilder_2einner(19);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$6, "more than ");
      _M0MPB13StringBuilder13write__objectGiE(_string_builder$6, _limit$2);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$6, " elements");
      logger.method_table.method_0(logger.self, _string_builder$6.val);
      return;
    }
    case 5: {
      logger.method_table.method_0(logger.self, "incompatible shapes");
      return;
    }
    default: {
      logger.method_table.method_0(logger.self, "overlapping range");
      return;
    }
  }
}
function _M0MP312moonbitstack7moonstl4algo12Permutations3newGiE(pool, length) {
  const items = _M0MPC15array9ArrayView9to__ownedGiE(pool);
  const n = items.len;
  let k;
  if (length === undefined) {
    k = n;
  } else {
    const _Some = length;
    const _k = _Some;
    k = _k < 0 ? 0 : _k > n ? n : _k;
  }
  const indices = new _M0TPB5ArrayGiE([], 0);
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < n) {
      _M0MPC15array5Array4pushGiE(indices, i);
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const cycles = new _M0TPB5ArrayGiE([], 0);
  let _tmp$2 = 0;
  while (true) {
    const i = _tmp$2;
    if (i < k) {
      _M0MPC15array5Array4pushGiE(cycles, n - i | 0);
      _tmp$2 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0TP312moonbitstack7moonstl4algo12PermutationsGiE(items, indices, cycles, k, false, false);
}
function _M0MP312moonbitstack7moonstl4algo12Permutations4nextGiE(self) {
  if (self.done) {
    return undefined;
  }
  const n = self.pool.len;
  const k = self.size;
  if (!self.started) {
    self.started = true;
    if (k === 0) {
      self.done = true;
      return new _M0TPB5ArrayGiE([], 0);
    }
    const first = new _M0TPB5ArrayGiE([], 0);
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < k) {
        const _bind = self.pool;
        const _bind$2 = self.indices;
        if (i < 0 || i >= _bind$2.len) {
          $panic();
        }
        const _bind$3 = _bind$2.buf[i];
        if (_bind$3 < 0 || _bind$3 >= _bind.len) {
          $panic();
        }
        _M0MPC15array5Array4pushGiE(first, _bind.buf[_bind$3]);
        _tmp = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return first;
  }
  let i = k - 1 | 0;
  while (true) {
    if (i >= 0) {
      const _bind = self.cycles;
      const _bind$2 = i;
      const _bind$3 = self.cycles;
      const _bind$4 = i;
      if (_bind$4 < 0 || _bind$4 >= _bind$3.len) {
        $panic();
      }
      const _bind$5 = _bind$3.buf[_bind$4] - 1 | 0;
      if (_bind$2 < 0 || _bind$2 >= _bind.len) {
        $panic();
      }
      _bind.buf[_bind$2] = _bind$5;
      const _bind$6 = self.cycles;
      const _bind$7 = i;
      if (_bind$7 < 0 || _bind$7 >= _bind$6.len) {
        $panic();
      }
      if (_bind$6.buf[_bind$7] === 0) {
        const _bind$8 = self.indices;
        const _bind$9 = i;
        if (_bind$9 < 0 || _bind$9 >= _bind$8.len) {
          $panic();
        }
        const head = _bind$8.buf[_bind$9];
        const _bind$10 = i;
        const _bind$11 = n - 1 | 0;
        let _tmp = _bind$10;
        while (true) {
          const j = _tmp;
          if (j < _bind$11) {
            const _bind$12 = self.indices;
            const _bind$13 = self.indices;
            const _bind$14 = j + 1 | 0;
            if (_bind$14 < 0 || _bind$14 >= _bind$13.len) {
              $panic();
            }
            const _bind$15 = _bind$13.buf[_bind$14];
            if (j < 0 || j >= _bind$12.len) {
              $panic();
            }
            _bind$12.buf[j] = _bind$15;
            _tmp = j + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        const _bind$12 = self.indices;
        const _bind$13 = n - 1 | 0;
        if (_bind$13 < 0 || _bind$13 >= _bind$12.len) {
          $panic();
        }
        _bind$12.buf[_bind$13] = head;
        const _bind$14 = self.cycles;
        const _bind$15 = i;
        const _bind$16 = n - i | 0;
        if (_bind$15 < 0 || _bind$15 >= _bind$14.len) {
          $panic();
        }
        _bind$14.buf[_bind$15] = _bind$16;
      } else {
        const _bind$8 = self.cycles;
        const _bind$9 = i;
        if (_bind$9 < 0 || _bind$9 >= _bind$8.len) {
          $panic();
        }
        const j = _bind$8.buf[_bind$9];
        const _bind$10 = self.indices;
        const _bind$11 = i;
        if (_bind$11 < 0 || _bind$11 >= _bind$10.len) {
          $panic();
        }
        const swap = _bind$10.buf[_bind$11];
        const _bind$12 = self.indices;
        const _bind$13 = i;
        const _bind$14 = self.indices;
        const _bind$15 = n - j | 0;
        if (_bind$15 < 0 || _bind$15 >= _bind$14.len) {
          $panic();
        }
        const _bind$16 = _bind$14.buf[_bind$15];
        if (_bind$13 < 0 || _bind$13 >= _bind$12.len) {
          $panic();
        }
        _bind$12.buf[_bind$13] = _bind$16;
        const _bind$17 = self.indices;
        const _bind$18 = n - j | 0;
        if (_bind$18 < 0 || _bind$18 >= _bind$17.len) {
          $panic();
        }
        _bind$17.buf[_bind$18] = swap;
        const result = new _M0TPB5ArrayGiE([], 0);
        let _tmp = 0;
        while (true) {
          const index = _tmp;
          if (index < k) {
            const _bind$19 = self.pool;
            const _bind$20 = self.indices;
            if (index < 0 || index >= _bind$20.len) {
              $panic();
            }
            const _bind$21 = _bind$20.buf[index];
            if (_bind$21 < 0 || _bind$21 >= _bind$19.len) {
              $panic();
            }
            _M0MPC15array5Array4pushGiE(result, _bind$19.buf[_bind$21]);
            _tmp = index + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        return result;
      }
      i = i - 1 | 0;
      continue;
    } else {
      break;
    }
  }
  self.done = true;
  return undefined;
}
function _M0MP312moonbitstack7moonstl4algo12Permutations4iterGiE(self) {
  return _M0MPB4Iter3newGUcRPB5ArrayGiEEE(() => _M0MP312moonbitstack7moonstl4algo12Permutations4nextGiE(self), undefined);
}
function _M0MP312moonbitstack7moonstl4algo12Combinations3newGiE(pool, k) {
  const items = _M0MPC15array9ArrayView9to__ownedGiE(pool);
  const indices = new _M0TPB5ArrayGiE([], 0);
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < k) {
      _M0MPC15array5Array4pushGiE(indices, i);
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0TP312moonbitstack7moonstl4algo12CombinationsGiE(items, indices, false, k < 0 || k > items.len);
}
function _M0MP312moonbitstack7moonstl4algo12Combinations4nextGiE(self) {
  if (self.done) {
    return undefined;
  }
  const n = self.pool.len;
  const k = self.indices.len;
  if (!self.started) {
    self.started = true;
    if (k === 0) {
      self.done = true;
      return new _M0TPB5ArrayGiE([], 0);
    }
    const first = new _M0TPB5ArrayGiE([], 0);
    const _bind = self.indices;
    const _bind$2 = _bind.len;
    const _bind$3 = _bind.buf;
    let _tmp = 0;
    while (true) {
      const _ = _tmp;
      if (_ < _bind$2) {
        const index = _bind$3[_];
        const _bind$4 = self.pool;
        if (index < 0 || index >= _bind$4.len) {
          $panic();
        }
        _M0MPC15array5Array4pushGiE(first, _bind$4.buf[index]);
        _tmp = _ + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return first;
  }
  let i = k - 1 | 0;
  while (true) {
    let _tmp;
    if (i >= 0) {
      const _bind = self.indices;
      const _bind$2 = i;
      if (_bind$2 < 0 || _bind$2 >= _bind.len) {
        $panic();
      }
      _tmp = _bind.buf[_bind$2] === ((i + n | 0) - k | 0);
    } else {
      _tmp = false;
    }
    if (_tmp) {
      i = i - 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (i < 0) {
    self.done = true;
    return undefined;
  }
  const _bind = self.indices;
  const _bind$2 = i;
  const _bind$3 = self.indices;
  const _bind$4 = i;
  if (_bind$4 < 0 || _bind$4 >= _bind$3.len) {
    $panic();
  }
  const _bind$5 = _bind$3.buf[_bind$4] + 1 | 0;
  if (_bind$2 < 0 || _bind$2 >= _bind.len) {
    $panic();
  }
  _bind.buf[_bind$2] = _bind$5;
  const _bind$6 = i + 1 | 0;
  let _tmp = _bind$6;
  while (true) {
    const j = _tmp;
    if (j < k) {
      const _bind$7 = self.indices;
      const _bind$8 = self.indices;
      const _bind$9 = j - 1 | 0;
      if (_bind$9 < 0 || _bind$9 >= _bind$8.len) {
        $panic();
      }
      const _bind$10 = _bind$8.buf[_bind$9] + 1 | 0;
      if (j < 0 || j >= _bind$7.len) {
        $panic();
      }
      _bind$7.buf[j] = _bind$10;
      _tmp = j + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const result = new _M0TPB5ArrayGiE([], 0);
  const _bind$7 = self.indices;
  const _bind$8 = _bind$7.len;
  const _bind$9 = _bind$7.buf;
  let _tmp$2 = 0;
  while (true) {
    const _ = _tmp$2;
    if (_ < _bind$8) {
      const index = _bind$9[_];
      const _bind$10 = self.pool;
      if (index < 0 || index >= _bind$10.len) {
        $panic();
      }
      _M0MPC15array5Array4pushGiE(result, _bind$10.buf[index]);
      _tmp$2 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return result;
}
function _M0MP312moonbitstack7moonstl4algo12Combinations4iterGiE(self) {
  return _M0MPB4Iter3newGUcRPB5ArrayGiEEE(() => _M0MP312moonbitstack7moonstl4algo12Combinations4nextGiE(self), undefined);
}
function _M0MP312moonbitstack7moonstl3map4Trie3newGiE() {
  const _bind = [];
  return new _M0TP312moonbitstack7moonstl3map4TrieGiE(new _M0TPB5ArrayGRPB3MapGciEE([_M0MPB3Map3MapGciE(new _M0TPB9ArrayViewGUciEE(_bind, 0, 0), undefined)], 1), new _M0TPB5ArrayGOiE([undefined], 1), 0);
}
function _M0MP312moonbitstack7moonstl3map4Trie5childGiE(self, node, ch) {
  const _bind = self.children;
  if (node < 0 || node >= _bind.len) {
    $panic();
  }
  return _M0MPB3Map3getGciE(_bind.buf[node], ch);
}
function _M0MP312moonbitstack7moonstl3map4Trie14child__or__newGiE(self, node, ch) {
  const _bind = self.children;
  if (node < 0 || node >= _bind.len) {
    $panic();
  }
  const _bind$2 = _M0MPB3Map3getGciE(_bind.buf[node], ch);
  if (_bind$2 === undefined) {
    const child = self.children.len;
    const _tmp = self.children;
    const _bind$3 = [];
    _M0MPC15array5Array4pushGRP312moonbitstack7moonstl4text6OpcodeE(_tmp, _M0MPB3Map3MapGciE(new _M0TPB9ArrayViewGUciEE(_bind$3, 0, 0), undefined));
    _M0MPC15array5Array4pushGOiE(self.values, undefined);
    const _bind$4 = self.children;
    if (node < 0 || node >= _bind$4.len) {
      $panic();
    }
    _M0MPB3Map3setGciE(_bind$4.buf[node], ch, child);
    return child;
  } else {
    const _Some = _bind$2;
    return _Some;
  }
}
function _M0MP312moonbitstack7moonstl3map4Trie6insertGiE(self, key, value) {
  let node = 0;
  const _it = _M0MPC16string6String4iter(_M0MPC16string10StringView9to__owned(key));
  while (true) {
    const _bind = _M0MPB4Iter4nextGcE(_it);
    if (_bind === -1) {
      break;
    } else {
      const _Some = _bind;
      const _ch = _Some;
      node = _M0MP312moonbitstack7moonstl3map4Trie14child__or__newGiE(self, node, _ch);
      continue;
    }
  }
  const _bind = self.values;
  const _bind$2 = node;
  if (_bind$2 < 0 || _bind$2 >= _bind.len) {
    $panic();
  }
  const old = _bind.buf[_bind$2];
  const _bind$3 = self.values;
  const _bind$4 = node;
  const _bind$5 = value;
  if (_bind$4 < 0 || _bind$4 >= _bind$3.len) {
    $panic();
  }
  _bind$3.buf[_bind$4] = _bind$5;
  if (old === undefined) {
    self.entries = self.entries + 1 | 0;
  }
  return old;
}
function _M0MP312moonbitstack7moonstl3map4Trie4walkGiE(self, key) {
  let node = 0;
  const _it = _M0MPC16string6String4iter(_M0MPC16string10StringView9to__owned(key));
  while (true) {
    const _bind = _M0MPB4Iter4nextGcE(_it);
    if (_bind === -1) {
      break;
    } else {
      const _Some = _bind;
      const _ch = _Some;
      const _bind$2 = _M0MP312moonbitstack7moonstl3map4Trie5childGiE(self, node, _ch);
      if (_bind$2 === undefined) {
        return undefined;
      } else {
        const _Some$2 = _bind$2;
        const _child = _Some$2;
        node = _child;
      }
      continue;
    }
  }
  return node;
}
function _M0MP312moonbitstack7moonstl3map4Trie7collectGiE(self, node, prefix, into) {
  const _bind = self.values;
  if (node < 0 || node >= _bind.len) {
    $panic();
  }
  const _bind$2 = _bind.buf[node];
  if (_bind$2 === undefined) {
  } else {
    const _Some = _bind$2;
    const _value = _Some;
    _M0MPC15array5Array4pushGRP312moonbitstack7moonstl4text6OpcodeE(into, { _0: prefix, _1: _value });
  }
  const children = new _M0TPB5ArrayGUciEE([], 0);
  const _bind$3 = self.children;
  if (node < 0 || node >= _bind$3.len) {
    $panic();
  }
  const _it = _M0MPB3Map4iterGciE(_bind$3.buf[node]);
  while (true) {
    const _bind$4 = _M0MPB4Iter4nextGUcRPB5ArrayGiEEE(_it);
    if (_bind$4 === undefined) {
      break;
    } else {
      const _Some = _bind$4;
      const _x = _Some;
      const _ch = _x._0;
      const _child = _x._1;
      _M0MPC15array5Array4pushGRP312moonbitstack7moonstl4text6OpcodeE(children, { _0: _ch, _1: _child });
      continue;
    }
  }
  _M0MPC15array5Array8sort__byGUciEE(children, (a, b) => $compare_int(a._0, b._0));
  const _bind$4 = children.len;
  const _bind$5 = children.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$4) {
      const _foreach_element = _bind$5[_];
      const _ch = _foreach_element._0;
      const _child = _foreach_element._1;
      _M0MP312moonbitstack7moonstl3map4Trie7collectGiE(self, _child, `${prefix}${_M0IPC14char4CharPB4Show10to__string(_ch)}`, into);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0MP312moonbitstack7moonstl3map4Trie18keys__with__prefixGiE(self, prefix) {
  const _bind = _M0MP312moonbitstack7moonstl3map4Trie4walkGiE(self, prefix);
  if (_bind === undefined) {
    return new _M0TPB5ArrayGsE([], 0);
  } else {
    const _Some = _bind;
    const _node = _Some;
    const found = new _M0TPB5ArrayGUsiEE([], 0);
    _M0MP312moonbitstack7moonstl3map4Trie7collectGiE(self, _node, _M0MPC16string10StringView9to__owned(prefix), found);
    const _p = _M0MPC15array5Array20unsafe__make__uninitGRPC14json4JsonE(found.len);
    const _p$2 = found.len;
    const _p$3 = found.buf;
    let _tmp = 0;
    while (true) {
      const _p$4 = _tmp;
      if (_p$4 < _p$2) {
        const _p$5 = _p$3[_p$4];
        const _p$6 = _p$5._0;
        _p.buf[_p$4] = _p$6;
        _tmp = _p$4 + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return _p;
  }
}
function _M0MP312moonbitstack7moonstl3map4Trie9to__arrayGiE(self) {
  const found = new _M0TPB5ArrayGUsiEE([], 0);
  _M0MP312moonbitstack7moonstl3map4Trie7collectGiE(self, 0, "", found);
  return found;
}
function _M0FP312moonbitstack7moonstl3map13bucket__count(n) {
  let count = 8;
  while (true) {
    if (count < n && count < 1073741824) {
      count = Math.imul(count, 2) | 0;
      continue;
    } else {
      break;
    }
  }
  return count;
}
function _M0MP312moonbitstack7moonstl3map8IndexMap11new_2einnerGiiE(capacity, hash_seed) {
  const buckets = _M0FP312moonbitstack7moonstl3map13bucket__count(capacity > 0 ? Math.imul(capacity, 2) | 0 : 8);
  return new _M0TP312moonbitstack7moonstl3map8IndexMapGiiE(new _M0TPB5ArrayGUiiEE([], 0), new _M0TPB5ArrayGiE([], 0), _M0MPC15array5Array4makeGiE(buckets, -1), new _M0TPB5ArrayGiE([], 0), 0, 0, hash_seed);
}
function _M0MP312moonbitstack7moonstl3map8IndexMap3newGiiE(capacity$46$opt, hash_seed$46$opt) {
  let capacity;
  if (capacity$46$opt === undefined) {
    capacity = 0;
  } else {
    const _Some = capacity$46$opt;
    capacity = _Some;
  }
  let hash_seed;
  if (hash_seed$46$opt === undefined) {
    hash_seed = _M0FP312moonbitstack7moonstl4spec10hash__seed();
  } else {
    const _Some = hash_seed$46$opt;
    hash_seed = _Some;
  }
  return _M0MP312moonbitstack7moonstl3map8IndexMap11new_2einnerGiiE(capacity, hash_seed);
}
function _M0FP312moonbitstack7moonstl3map12hash__seededGiE(key, seed) {
  const low = BigInt.asUintN(64, BigInt.asUintN(64, BigInt(_M0IPC13int3IntPB4Hash4hash(key))) & 4294967295n);
  const high = BigInt.asUintN(64, BigInt.asUintN(64, BigInt(seed)) & 4294967295n);
  let z = BigInt.asUintN(64, BigInt.asUintN(64, low << BigInt(32 & 63)) | high);
  z = BigInt.asUintN(64, BigInt.asUintN(64, z ^ BigInt.asUintN(64, BigInt.asUintN(64, z) >> BigInt(30 & 63))) * 13787848793156543929n);
  z = BigInt.asUintN(64, BigInt.asUintN(64, z ^ BigInt.asUintN(64, BigInt.asUintN(64, z) >> BigInt(27 & 63))) * 10723151780598845931n);
  z = BigInt.asUintN(64, z ^ BigInt.asUintN(64, BigInt.asUintN(64, z) >> BigInt(31 & 63)));
  return Number(BigInt.asUintN(32, BigInt.asUintN(64, BigInt.asUintN(64, z) >> BigInt(33 & 63)))) & 2147483647;
}
function _M0MP312moonbitstack7moonstl3map8IndexMap4findGiiE(self, key) {
  const mask = self.slots.len - 1 | 0;
  const hash = _M0FP312moonbitstack7moonstl3map12hash__seededGiE(key, self.seed);
  let i = hash & mask;
  while (true) {
    const _bind = self.slots;
    const _bind$2 = i;
    if (_bind$2 < 0 || _bind$2 >= _bind.len) {
      $panic();
    }
    const entry = _bind.buf[_bind$2];
    if (entry === -1) {
      return undefined;
    }
    let _tmp;
    if (entry >= 0) {
      let _tmp$2;
      const _bind$3 = self.hashes;
      if (entry < 0 || entry >= _bind$3.len) {
        $panic();
      }
      if (_bind$3.buf[entry] === hash) {
        const _bind$4 = self.entries;
        if (entry < 0 || entry >= _bind$4.len) {
          $panic();
        }
        _tmp$2 = _bind$4.buf[entry]._0 === key;
      } else {
        _tmp$2 = false;
      }
      _tmp = _tmp$2;
    } else {
      _tmp = false;
    }
    if (_tmp) {
      return entry;
    }
    i = i + 1 & mask;
    continue;
  }
}
function _M0MP312moonbitstack7moonstl3map8IndexMap3getGiiE(self, key) {
  const _bind = _M0MP312moonbitstack7moonstl3map8IndexMap4findGiiE(self, key);
  if (_bind === undefined) {
    return undefined;
  } else {
    const _Some = _bind;
    const _index = _Some;
    const _bind$2 = self.entries;
    if (_index < 0 || _index >= _bind$2.len) {
      $panic();
    }
    return _bind$2.buf[_index]._1;
  }
}
function _M0MP312moonbitstack7moonstl3map8IndexMap7rebuildGiiE(self) {
  const buckets = _M0FP312moonbitstack7moonstl3map13bucket__count(self.entries.len === 0 ? 8 : Math.imul(self.entries.len, 2) | 0);
  self.slots = _M0MPC15array5Array4makeGiE(buckets, -1);
  self.slot_of = _M0MPC15array5Array4makeGiE(self.entries.len, -1);
  self.live = 0;
  self.graves = 0;
  const mask = buckets - 1 | 0;
  const _bind = self.entries.len;
  let _tmp = 0;
  while (true) {
    const index = _tmp;
    if (index < _bind) {
      const _bind$2 = self.hashes;
      if (index < 0 || index >= _bind$2.len) {
        $panic();
      }
      const hash = _bind$2.buf[index];
      let slot = hash & mask;
      while (true) {
        const _bind$3 = self.slots;
        const _bind$4 = slot;
        if (_bind$4 < 0 || _bind$4 >= _bind$3.len) {
          $panic();
        }
        if (_bind$3.buf[_bind$4] !== -1) {
          slot = slot + 1 & mask;
          continue;
        } else {
          break;
        }
      }
      const _bind$3 = self.slots;
      const _bind$4 = slot;
      if (_bind$4 < 0 || _bind$4 >= _bind$3.len) {
        $panic();
      }
      _bind$3.buf[_bind$4] = index;
      const _bind$5 = self.slot_of;
      const _bind$6 = slot;
      if (index < 0 || index >= _bind$5.len) {
        $panic();
      }
      _bind$5.buf[index] = _bind$6;
      self.live = self.live + 1 | 0;
      _tmp = index + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0MP312moonbitstack7moonstl3map8IndexMap12insert__fullGiiE(self, key, value) {
  const _bind = _M0MP312moonbitstack7moonstl3map8IndexMap4findGiiE(self, key);
  if (_bind === undefined) {
    if ((Math.imul((self.live + self.graves | 0) + 1 | 0, 4) | 0) >= (Math.imul(self.slots.len, 3) | 0)) {
      _M0MP312moonbitstack7moonstl3map8IndexMap7rebuildGiiE(self);
    }
    const hash = _M0FP312moonbitstack7moonstl3map12hash__seededGiE(key, self.seed);
    const mask = self.slots.len - 1 | 0;
    let slot = hash & mask;
    let dead = -1;
    while (true) {
      const _bind$2 = self.slots;
      const _bind$3 = slot;
      if (_bind$3 < 0 || _bind$3 >= _bind$2.len) {
        $panic();
      }
      const entry = _bind$2.buf[_bind$3];
      if (entry === -1) {
        break;
      }
      if (entry === -2 && dead < 0) {
        dead = slot;
      }
      slot = slot + 1 & mask;
      continue;
    }
    const chosen = dead >= 0 ? dead : slot;
    const index = self.entries.len;
    _M0MPC15array5Array4pushGRP312moonbitstack7moonstl4text6OpcodeE(self.entries, { _0: key, _1: value });
    _M0MPC15array5Array4pushGiE(self.hashes, hash);
    _M0MPC15array5Array4pushGiE(self.slot_of, chosen);
    const _bind$2 = self.slots;
    if (chosen < 0 || chosen >= _bind$2.len) {
      $panic();
    }
    _bind$2.buf[chosen] = index;
    if (dead >= 0) {
      self.graves = self.graves - 1 | 0;
    }
    self.live = self.live + 1 | 0;
    return { _0: index, _1: undefined };
  } else {
    const _Some = _bind;
    const _index = _Some;
    const _bind$2 = self.entries;
    if (_index < 0 || _index >= _bind$2.len) {
      $panic();
    }
    const old = _bind$2.buf[_index]._1;
    const _bind$3 = self.entries;
    if (_index < 0 || _index >= _bind$3.len) {
      $panic();
    }
    const held = _bind$3.buf[_index]._0;
    const _bind$4 = self.entries;
    const _bind$5 = { _0: held, _1: value };
    if (_index < 0 || _index >= _bind$4.len) {
      $panic();
    }
    _bind$4.buf[_index] = _bind$5;
    return { _0: _index, _1: old };
  }
}
function _M0MP312moonbitstack7moonstl3map8IndexMap3setGiiE(self, key, value) {
  const _bind = _M0MP312moonbitstack7moonstl3map8IndexMap12insert__fullGiiE(self, key, value);
  return _bind._1;
}
function _M0MP312moonbitstack7moonstl3map8IndexMap19swap__remove__indexGiiE(self, index) {
  const size = self.entries.len;
  if (index < 0 || index >= size) {
    return undefined;
  }
  const _bind = self.entries;
  if (index < 0 || index >= _bind.len) {
    $panic();
  }
  const removed = _bind.buf[index];
  const _bind$2 = self.slot_of;
  if (index < 0 || index >= _bind$2.len) {
    $panic();
  }
  const dead = _bind$2.buf[index];
  const last = size - 1 | 0;
  if (index !== last) {
    const _bind$3 = self.entries;
    const _bind$4 = self.entries;
    if (last < 0 || last >= _bind$4.len) {
      $panic();
    }
    const _bind$5 = _bind$4.buf[last];
    if (index < 0 || index >= _bind$3.len) {
      $panic();
    }
    _bind$3.buf[index] = _bind$5;
    const _bind$6 = self.hashes;
    const _bind$7 = self.hashes;
    if (last < 0 || last >= _bind$7.len) {
      $panic();
    }
    const _bind$8 = _bind$7.buf[last];
    if (index < 0 || index >= _bind$6.len) {
      $panic();
    }
    _bind$6.buf[index] = _bind$8;
    const _bind$9 = self.slot_of;
    const _bind$10 = self.slot_of;
    if (last < 0 || last >= _bind$10.len) {
      $panic();
    }
    const _bind$11 = _bind$10.buf[last];
    if (index < 0 || index >= _bind$9.len) {
      $panic();
    }
    _bind$9.buf[index] = _bind$11;
    const _bind$12 = self.slots;
    const _bind$13 = self.slot_of;
    if (index < 0 || index >= _bind$13.len) {
      $panic();
    }
    const _bind$14 = _bind$13.buf[index];
    if (_bind$14 < 0 || _bind$14 >= _bind$12.len) {
      $panic();
    }
    _bind$12.buf[_bind$14] = index;
  }
  _M0MPC15array5Array3popGUiiEE(self.entries);
  _M0MPC15array5Array3popGiE(self.hashes);
  _M0MPC15array5Array3popGiE(self.slot_of);
  const _bind$3 = self.slots;
  if (dead < 0 || dead >= _bind$3.len) {
    $panic();
  }
  _bind$3.buf[dead] = -2;
  self.live = self.live - 1 | 0;
  self.graves = self.graves + 1 | 0;
  return removed;
}
function _M0MP312moonbitstack7moonstl3map8IndexMap6removeGiiE(self, key) {
  const _bind = _M0MP312moonbitstack7moonstl3map8IndexMap4findGiiE(self, key);
  if (_bind === undefined) {
    return undefined;
  } else {
    const _Some = _bind;
    const _index = _Some;
    const _p = _M0MP312moonbitstack7moonstl3map8IndexMap19swap__remove__indexGiiE(self, _index);
    let _bind$2;
    if (_p === undefined) {
      _bind$2 = $panic();
    } else {
      const _p$2 = _p;
      _bind$2 = _p$2;
    }
    const _value = _bind$2._1;
    return _value;
  }
}
function _M0MP312moonbitstack7moonstl3map8IndexMap5rangeGiiE(self, start, len) {
  const from = start < 0 ? 0 : start;
  const size = self.entries.len;
  const stop = from >= size ? from : len < 0 ? from : (from + len | 0) > size ? size : from + len | 0;
  const cursor = new _M0TPB8MutLocalGiE(from);
  return _M0MPB4Iter3newGUcRPB5ArrayGiEEE(() => {
    if (cursor.val >= stop) {
      return undefined;
    } else {
      const _bind = self.entries;
      const _bind$2 = cursor.val;
      if (_bind$2 < 0 || _bind$2 >= _bind.len) {
        $panic();
      }
      const entry = _bind.buf[_bind$2];
      cursor.val = cursor.val + 1 | 0;
      return entry;
    }
  }, undefined);
}
function _M0MP312moonbitstack7moonstl3map8IndexMap4iterGiiE(self) {
  return _M0MP312moonbitstack7moonstl3map8IndexMap5rangeGiiE(self, 0, self.entries.len);
}
function _M0MP312moonbitstack7moonstl3map8IndexMap4keysGiiE(self) {
  return _M0MPB4Iter3mapGUiiEiE(_M0MP312moonbitstack7moonstl3map8IndexMap4iterGiiE(self), (entry) => entry._0);
}
function _M0MP312moonbitstack7moonstl3map8IndexMap14get__index__ofGiiE(self, key) {
  return _M0MP312moonbitstack7moonstl3map8IndexMap4findGiiE(self, key);
}
function _M0MP312moonbitstack7moonstl5cache8LruCache4nodeGiiE(self, slot) {
  const _bind = self.slots;
  if (slot < 0 || slot >= _bind.len) {
    $panic();
  }
  const _bind$2 = _bind.buf[slot];
  if (_bind$2 === undefined) {
    return $panic("moonstl: a live cache slot is empty");
  } else {
    const _Some = _bind$2;
    return _Some;
  }
}
function _M0MP312moonbitstack7moonstl5cache8LruCache12append__tailGiiE(self, slot) {
  const node = _M0MP312moonbitstack7moonstl5cache8LruCache4nodeGiiE(self, slot);
  node.prev = self.tail;
  node.next = -1;
  if (self.tail >= 0) {
    _M0MP312moonbitstack7moonstl5cache8LruCache4nodeGiiE(self, self.tail).next = slot;
  } else {
    self.head = slot;
  }
  self.tail = slot;
}
function _M0MP312moonbitstack7moonstl5cache8LruCache6detachGiiE(self, slot) {
  const node = _M0MP312moonbitstack7moonstl5cache8LruCache4nodeGiiE(self, slot);
  if (node.prev >= 0) {
    _M0MP312moonbitstack7moonstl5cache8LruCache4nodeGiiE(self, node.prev).next = node.next;
  } else {
    self.head = node.next;
  }
  if (node.next >= 0) {
    _M0MP312moonbitstack7moonstl5cache8LruCache4nodeGiiE(self, node.next).prev = node.prev;
  } else {
    self.tail = node.prev;
  }
  node.prev = -1;
  node.next = -1;
}
function _M0MP312moonbitstack7moonstl5cache8LruCache5touchGiiE(self, slot) {
  if (self.tail === slot) {
    return undefined;
  }
  _M0MP312moonbitstack7moonstl5cache8LruCache6detachGiiE(self, slot);
  _M0MP312moonbitstack7moonstl5cache8LruCache12append__tailGiiE(self, slot);
}
function _M0MP312moonbitstack7moonstl5cache8LruCache11new_2einnerGiiE(capacity, on_evict, hash_seed) {
  if (capacity <= 0) {
    return new _M0DTPC16result6ResultGRP312moonbitstack7moonstl5cache8LruCacheGiiERP312moonbitstack7moonstl4spec7RefusedE3Err(new _M0DTPC15error5Error50moonbitstack_2fmoonstl_2fspec_2eRefused_2eCapacity(capacity));
  }
  return new _M0DTPC16result6ResultGRP312moonbitstack7moonstl5cache8LruCacheGiiERP312moonbitstack7moonstl4spec7RefusedE2Ok(new _M0TP312moonbitstack7moonstl5cache8LruCacheGiiE(_M0MP312moonbitstack7moonstl3map8IndexMap11new_2einnerGiiE(capacity, hash_seed), new _M0TPB5ArrayGORP312moonbitstack7moonstl5cache7LruNodeGiiEE([], 0), new _M0TPB5ArrayGiE([], 0), capacity, -1, -1, 0n, 0n, 0n, on_evict));
}
function _M0MP312moonbitstack7moonstl5cache8LruCache3newGiiE(capacity, on_evict, hash_seed$46$opt) {
  let hash_seed;
  if (hash_seed$46$opt === undefined) {
    hash_seed = _M0FP312moonbitstack7moonstl4spec10hash__seed();
  } else {
    const _Some = hash_seed$46$opt;
    hash_seed = _Some;
  }
  return _M0MP312moonbitstack7moonstl5cache8LruCache11new_2einnerGiiE(capacity, on_evict, hash_seed);
}
function _M0MP312moonbitstack7moonstl5cache8LruCache5allocGiiE(self, key, value) {
  const node = new _M0TP312moonbitstack7moonstl5cache7LruNodeGiiE(key, value, -1, -1);
  const _bind = _M0MPC15array5Array3popGiE(self.free);
  if (_bind === undefined) {
    _M0MPC15array5Array4pushGORP312moonbitstack7moonstl5cache7LruNodeGiiEE(self.slots, node);
    return self.slots.len - 1 | 0;
  } else {
    const _Some = _bind;
    const _slot = _Some;
    const _bind$2 = self.slots;
    const _bind$3 = node;
    if (_slot < 0 || _slot >= _bind$2.len) {
      $panic();
    }
    _bind$2.buf[_slot] = _bind$3;
    return _slot;
  }
}
function _M0MP312moonbitstack7moonstl5cache8LruCache11drop__entryGiiE(self, slot) {
  _M0MP312moonbitstack7moonstl5cache8LruCache6detachGiiE(self, slot);
  const _bind = self.slots;
  const _bind$2 = undefined;
  if (slot < 0 || slot >= _bind.len) {
    $panic();
  }
  _bind.buf[slot] = _bind$2;
  _M0MPC15array5Array4pushGiE(self.free, slot);
}
function _M0MP312moonbitstack7moonstl5cache8LruCache9take__lruGiiE(self) {
  if (self.head < 0) {
    return undefined;
  }
  const slot = self.head;
  const node = _M0MP312moonbitstack7moonstl5cache8LruCache4nodeGiiE(self, slot);
  const key = node.key;
  const value = node.value;
  _M0MP312moonbitstack7moonstl3map8IndexMap6removeGiiE(self.index, key);
  _M0MP312moonbitstack7moonstl5cache8LruCache11drop__entryGiiE(self, slot);
  self.evictions = BigInt.asUintN(64, self.evictions + 1n);
  const _bind = self.on_evict;
  if (_bind === undefined) {
  } else {
    const _Some = _bind;
    const _callback = _Some;
    _callback(key, value);
  }
  return { _0: key, _1: value };
}
function _M0MP312moonbitstack7moonstl5cache8LruCache3setGiiE(self, key, value) {
  const _bind = _M0MP312moonbitstack7moonstl3map8IndexMap3getGiiE(self.index, key);
  if (_bind === undefined) {
    let displaced;
    const _p = self.index;
    if (_p.entries.len === self.capacity) {
      displaced = _M0MP312moonbitstack7moonstl5cache8LruCache9take__lruGiiE(self);
    } else {
      displaced = undefined;
    }
    const slot = _M0MP312moonbitstack7moonstl5cache8LruCache5allocGiiE(self, key, value);
    _M0MP312moonbitstack7moonstl3map8IndexMap3setGiiE(self.index, key, slot);
    _M0MP312moonbitstack7moonstl5cache8LruCache12append__tailGiiE(self, slot);
    return displaced;
  } else {
    const _Some = _bind;
    const _slot = _Some;
    const node = _M0MP312moonbitstack7moonstl5cache8LruCache4nodeGiiE(self, _slot);
    const old = node.value;
    node.value = value;
    _M0MP312moonbitstack7moonstl5cache8LruCache5touchGiiE(self, _slot);
    return { _0: key, _1: old };
  }
}
function _M0MP312moonbitstack7moonstl5cache8LruCache4iterGiiE(self) {
  const cursor = new _M0TPB8MutLocalGiE(self.head);
  return _M0MPB4Iter3newGUcRPB5ArrayGiEEE(() => {
    if (cursor.val < 0) {
      return undefined;
    } else {
      const node = _M0MP312moonbitstack7moonstl5cache8LruCache4nodeGiiE(self, cursor.val);
      cursor.val = node.next;
      return { _0: node.key, _1: node.value };
    }
  }, undefined);
}
function _M0MP312moonbitstack7moonstl5cache8LruCache4keysGiiE(self) {
  return _M0MPB4Iter3mapGUiiEiE(_M0MP312moonbitstack7moonstl5cache8LruCache4iterGiiE(self), (pair) => pair._0);
}
function _M0FP312moonbitstack7moonstl4heap17order__comparatorGiE(order) {
  if (order === 0) {
    return (a, b) => $compare_int(a, b);
  } else {
    return (a, b) => $compare_int(b, a);
  }
}
function _M0IP312moonbitstack7moonstl4heap8DaryHeapPB7Default7defaultGiE() {
  return new _M0TP312moonbitstack7moonstl4heap8DaryHeapGiE(4, _M0FP312moonbitstack7moonstl4heap17order__comparatorGiE(0), new _M0TPB5ArrayGiE([], 0));
}
function _M0FP312moonbitstack7moonstl4heap16dary__sift__downGiE(items, start, arity, cmp) {
  const n = items.len;
  let node = start;
  while (true) {
    const first = (Math.imul(node, arity) | 0) + 1 | 0;
    if (first >= n) {
      return;
    }
    const last = ((first + arity | 0) - 1 | 0) < n ? (first + arity | 0) - 1 | 0 : n - 1 | 0;
    let best = first;
    const _bind = first + 1 | 0;
    let _tmp = _bind;
    let _tmp$2 = _bind <= last;
    while (true) {
      const i = _tmp;
      const _more = _tmp$2;
      if (_more) {
        if (i < 0 || i >= items.len) {
          $panic();
        }
        const _tmp$3 = items.buf[i];
        const _bind$2 = best;
        if (_bind$2 < 0 || _bind$2 >= items.len) {
          $panic();
        }
        if (cmp(_tmp$3, items.buf[_bind$2]) < 0) {
          best = i;
        }
        _tmp = i + 1 | 0;
        _tmp$2 = i < last;
        continue;
      } else {
        break;
      }
    }
    const _bind$2 = best;
    if (_bind$2 < 0 || _bind$2 >= items.len) {
      $panic();
    }
    const _tmp$3 = items.buf[_bind$2];
    const _bind$3 = node;
    if (_bind$3 < 0 || _bind$3 >= items.len) {
      $panic();
    }
    if (cmp(_tmp$3, items.buf[_bind$3]) >= 0) {
      return;
    }
    _M0MPC15array5Array4swapGiE(items, node, best);
    node = best;
    continue;
  }
}
function _M0FP312moonbitstack7moonstl4heap14dary__sift__upGiE(items, start, arity, cmp) {
  let child = start;
  while (true) {
    if (child > 0) {
      const parent = (child - 1 | 0) / arity | 0;
      const _bind = child;
      if (_bind < 0 || _bind >= items.len) {
        $panic();
      }
      const _tmp = items.buf[_bind];
      if (parent < 0 || parent >= items.len) {
        $panic();
      }
      if (cmp(_tmp, items.buf[parent]) >= 0) {
        return;
      }
      _M0MPC15array5Array4swapGiE(items, child, parent);
      child = parent;
      continue;
    } else {
      return;
    }
  }
}
function _M0MP312moonbitstack7moonstl4heap8DaryHeap4pushGiE(self, value) {
  _M0MPC15array5Array4pushGiE(self.items, value);
  _M0FP312moonbitstack7moonstl4heap14dary__sift__upGiE(self.items, self.items.len - 1 | 0, self.arity, self.cmp);
}
function _M0MP312moonbitstack7moonstl4heap8DaryHeap3popGiE(self) {
  const last = self.items.len - 1 | 0;
  if (last < 0) {
    return undefined;
  }
  _M0MPC15array5Array4swapGiE(self.items, 0, last);
  const value = _M0MPC15array5Array3popGiE(self.items);
  if (last > 0) {
    _M0FP312moonbitstack7moonstl4heap16dary__sift__downGiE(self.items, 0, self.arity, self.cmp);
  }
  return value;
}
function _M0FP312moonbitstack7moonstl3phf9phf__slot(hash, displacement, table_len) {
  const low = BigInt.asUintN(64, hash & 4294967295n);
  const _tmp = BigInt.asUintN(64, BigInt(table_len));
  if (_tmp === 0n) {
    $panic();
  }
  return Number(BigInt.asIntN(32, BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, low + BigInt.asUintN(64, BigInt(displacement)))) % BigInt.asUintN(64, _tmp)))) | 0;
}
function _M0FP312moonbitstack7moonstl3phf9slot__for(layout, hash, bucket) {
  const _bind = layout.disps;
  if (bucket < 0 || bucket >= _bind.len) {
    $panic();
  }
  return _M0FP312moonbitstack7moonstl3phf9phf__slot(hash, _bind.buf[bucket], layout.table_len);
}
function _M0FP312moonbitstack7moonstl3phf17rank__from__owner(owner, table_len, length) {
  const word_count = (table_len + 63 | 0) / 64 | 0;
  const words = $make_array_len_and_init(word_count, 0n);
  let _tmp = 0;
  while (true) {
    const slot = _tmp;
    if (slot < table_len) {
      if ((slot >>> 0 < owner.length ? owner[slot] : $oob()) >= 0) {
        const _tmp$2 = slot / 64 | 0;
        const _tmp$3 = slot / 64 | 0;
        if (_tmp$2 >>> 0 < words.length) {
          words[_tmp$2] = BigInt.asUintN(64, (_tmp$3 >>> 0 < words.length ? words[_tmp$3] : $oob()) | BigInt.asUintN(64, _M0FP312moonbitstack7moonstl3phf17rank__from__ownerN3bitS3584 << BigInt(slot % 64 & 63)));
        } else {
          $oob();
        }
      }
      _tmp = slot + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const prefixes = $make_array_len_and_init(word_count, 0);
  let running = 0;
  let _tmp$2 = 0;
  while (true) {
    const word = _tmp$2;
    if (word < word_count) {
      if (word >>> 0 < prefixes.length) {
        prefixes[word] = running;
      } else {
        $oob();
      }
      running = running + $i64_popcnt(word >>> 0 < words.length ? words[word] : $oob()) | 0;
      _tmp$2 = word + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const dense = $make_array_len_and_init(length, 0);
  let rank = 0;
  let _tmp$3 = 0;
  while (true) {
    const slot = _tmp$3;
    if (slot < table_len) {
      if ((slot >>> 0 < owner.length ? owner[slot] : $oob()) >= 0) {
        const _tmp$4 = rank;
        if (_tmp$4 >>> 0 < dense.length) {
          dense[_tmp$4] = slot >>> 0 < owner.length ? owner[slot] : $oob();
        } else {
          $oob();
        }
        rank = rank + 1 | 0;
      }
      _tmp$3 = slot + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0TP312moonbitstack7moonstl3phf7PhfRank(words, prefixes, dense);
}
function _M0FP312moonbitstack7moonstl3phf11make__index(owner, layout) {
  const _bind = layout.build;
  if (_bind === 2) {
    return new _M0DTP312moonbitstack7moonstl3phf8PhfIndex6Ranked(_M0FP312moonbitstack7moonstl3phf17rank__from__owner(owner, layout.table_len, layout.length));
  } else {
    return new _M0DTP312moonbitstack7moonstl3phf8PhfIndex6Direct(owner);
  }
}
function _M0FP312moonbitstack7moonstl3phf10phf__mix64(value) {
  let z = value;
  z = BigInt.asUintN(64, BigInt.asUintN(64, z ^ BigInt.asUintN(64, BigInt.asUintN(64, z) >> BigInt(30 & 63))) * 13787848793156543929n);
  z = BigInt.asUintN(64, BigInt.asUintN(64, z ^ BigInt.asUintN(64, BigInt.asUintN(64, z) >> BigInt(27 & 63))) * 10723151780598845931n);
  return BigInt.asUintN(64, z ^ BigInt.asUintN(64, BigInt.asUintN(64, z) >> BigInt(31 & 63)));
}
function _M0FP312moonbitstack7moonstl3phf9phf__hash(bytes, salt) {
  let hash = BigInt.asUintN(64, 14695981039346656037n ^ salt);
  const _bind = bytes.end - bytes.start | 0;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      const _tmp$2 = hash;
      if (i < 0 || i >= (bytes.end - bytes.start | 0)) {
        $panic();
      }
      hash = BigInt.asUintN(64, BigInt.asUintN(64, _tmp$2 ^ _M0MPC14byte4Byte10to__uint64(bytes.buf[bytes.start + i | 0])) * 1099511628211n);
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return _M0FP312moonbitstack7moonstl3phf10phf__mix64(hash);
}
function _M0FP312moonbitstack7moonstl3phf12build__indexGsiE(layout, entries) {
  const owner = $make_array_len_and_init(layout.table_len, -1);
  const _bind = entries.len;
  const _bind$2 = entries.buf;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      const entry = _bind$2[i];
      const _bind$3 = _M0IPC16string6StringP312moonbitstack7moonstl3phf6PhfKey9to__bytes(entry._0);
      const hash = _M0FP312moonbitstack7moonstl3phf9phf__hash(new _M0TPC15bytes9BytesView(_bind$3, 0, _bind$3.length), layout.salt);
      const _p = layout.buckets;
      const _tmp$2 = BigInt.asUintN(64, BigInt(_p));
      if (_tmp$2 === 0n) {
        $panic();
      }
      const bucket = Number(BigInt.asIntN(32, BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, hash) >> BigInt(32 & 63))) % BigInt.asUintN(64, _tmp$2)))) | 0;
      const slot = _M0FP312moonbitstack7moonstl3phf9slot__for(layout, hash, bucket);
      if (slot < 0 || (slot >= layout.table_len || (slot >>> 0 < owner.length ? owner[slot] : $oob()) >= 0)) {
        return new _M0DTPC16result6ResultGRP312moonbitstack7moonstl3phf8PhfIndexRP312moonbitstack7moonstl4spec7RefusedE3Err(_M0DTPC15error5Error54moonbitstack_2fmoonstl_2fspec_2eRefused_2eIncompatible__);
      }
      if (slot >>> 0 < owner.length) {
        owner[slot] = i;
      } else {
        $oob();
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPC16result6ResultGRP312moonbitstack7moonstl3phf8PhfIndexRP312moonbitstack7moonstl4spec7RefusedE2Ok(_M0FP312moonbitstack7moonstl3phf11make__index(owner, layout));
}
function _M0MP312moonbitstack7moonstl3phf6PhfMap12from__layoutGsiE(layout, entries) {
  if (layout.length !== entries.len) {
    return new _M0DTPC16result6ResultGRP312moonbitstack7moonstl3phf6PhfMapGsiERP312moonbitstack7moonstl4spec7RefusedE3Err(_M0DTPC15error5Error54moonbitstack_2fmoonstl_2fspec_2eRefused_2eIncompatible__);
  }
  const _bind = _M0FP312moonbitstack7moonstl3phf12build__indexGsiE(layout, entries);
  let index;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    index = _ok._0;
  } else {
    return _bind;
  }
  const keys = new _M0TPB5ArrayGsE([], 0);
  const values = new _M0TPB5ArrayGiE([], 0);
  const _bind$2 = entries.len;
  const _bind$3 = entries.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const entry = _bind$3[_];
      _M0MPC15array5Array4pushGRP312moonbitstack7moonstl4text6OpcodeE(keys, entry._0);
      _M0MPC15array5Array4pushGiE(values, entry._1);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPC16result6ResultGRP312moonbitstack7moonstl3phf6PhfMapGsiERP312moonbitstack7moonstl4spec7RefusedE2Ok(new _M0TP312moonbitstack7moonstl3phf6PhfMapGsiE(layout, keys, values, index));
}
function _M0MP312moonbitstack7moonstl3phf6PhfMap4keysGsiE(self) {
  const cursor = new _M0TPB8MutLocalGiE(0);
  return _M0MPB4Iter3newGUcRPB5ArrayGiEEE(() => {
    if (cursor.val >= self.keys.len) {
      return undefined;
    } else {
      const _bind = self.keys;
      const _bind$2 = cursor.val;
      if (_bind$2 < 0 || _bind$2 >= _bind.len) {
        $panic();
      }
      const key = _bind.buf[_bind$2];
      cursor.val = cursor.val + 1 | 0;
      return key;
    }
  }, undefined);
}
function _M0MP312moonbitstack7moonstl3phf10PhfBuilder11new_2einnerGsiE(phf_options) {
  const _tmp = new _M0TPB5ArrayGsE([], 0);
  const _tmp$2 = new _M0TPB5ArrayGiE([], 0);
  const _bind = [];
  return new _M0TP312moonbitstack7moonstl3phf10PhfBuilderGsiE(phf_options, _tmp, _tmp$2, _M0MPB3Map3MapGzuE(new _M0TPB9ArrayViewGUzuEE(_bind, 0, 0), undefined));
}
function _M0MP312moonbitstack7moonstl3phf10PhfBuilder3newGsiE(phf_options$46$opt) {
  let phf_options;
  if (phf_options$46$opt === undefined) {
    phf_options = _M0FP312moonbitstack7moonstl3phf12phf__options;
  } else {
    const _Some = phf_options$46$opt;
    phf_options = _Some;
  }
  return _M0MP312moonbitstack7moonstl3phf10PhfBuilder11new_2einnerGsiE(phf_options);
}
function _M0MP312moonbitstack7moonstl3phf10PhfBuilder5entryGsiE(self, key, value) {
  const bytes = _M0IPC16string6StringP312moonbitstack7moonstl3phf6PhfKey9to__bytes(key);
  if (_M0MPB3Map8containsGzuE(self.seen, bytes)) {
    return new _M0DTPC16result6ResultGuRP312moonbitstack7moonstl4spec7RefusedE3Err(_M0DTPC15error5Error56moonbitstack_2fmoonstl_2fspec_2eRefused_2eDuplicateValue__);
  }
  _M0MPB3Map3setGzuE(self.seen, bytes, undefined);
  _M0MPC15array5Array4pushGRP312moonbitstack7moonstl4text6OpcodeE(self.keys, key);
  return new _M0DTPC16result6ResultGuRP312moonbitstack7moonstl4spec7RefusedE2Ok(_M0MPC15array5Array4pushGiE(self.values, value));
}
function _M0FP312moonbitstack7moonstl3phf13build__params(build) {
  switch (build) {
    case 0: {
      return _M0FP312moonbitstack7moonstl3phf13build__paramsN6recordS3653;
    }
    case 1: {
      return _M0FP312moonbitstack7moonstl3phf13build__paramsN6recordS3654;
    }
    default: {
      return _M0FP312moonbitstack7moonstl3phf13build__paramsN6recordS3655;
    }
  }
}
function _M0FP312moonbitstack7moonstl3phf9phf__salt(seed, attempt) {
  const seed_bits = BigInt.asUintN(64, BigInt(seed));
  const attempt_bits = BigInt.asUintN(64, BigInt(attempt));
  return _M0FP312moonbitstack7moonstl3phf10phf__mix64(BigInt.asUintN(64, seed_bits ^ BigInt.asUintN(64, attempt_bits << BigInt(32 & 63))));
}
function _M0FP312moonbitstack7moonstl3phf22bucket__is__impossible(hashes, items, start, count, table_len) {
  const modulus = BigInt.asUintN(64, BigInt(table_len));
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < count) {
      const _tmp$2 = start + i | 0;
      const _tmp$3 = _tmp$2 >>> 0 < items.length ? items[_tmp$2] : $oob();
      if (modulus === 0n) {
        $panic();
      }
      const a = BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, (_tmp$3 >>> 0 < hashes.length ? hashes[_tmp$3] : $oob()) & 4294967295n)) % BigInt.asUintN(64, modulus));
      let _tmp$4 = 0;
      while (true) {
        const j = _tmp$4;
        if (j < i) {
          const _tmp$5 = start + j | 0;
          const _tmp$6 = _tmp$5 >>> 0 < items.length ? items[_tmp$5] : $oob();
          if (modulus === 0n) {
            $panic();
          }
          if (BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, (_tmp$6 >>> 0 < hashes.length ? hashes[_tmp$6] : $oob()) & 4294967295n)) % BigInt.asUintN(64, modulus))) === BigInt.asUintN(64, a)) {
            return true;
          }
          _tmp$4 = j + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return false;
}
function _M0FP312moonbitstack7moonstl3phf14place__buckets(hashes, buckets, table_len, max_displacement) {
  const n = hashes.length;
  const counts = $make_array_len_and_init(buckets, 0);
  const bucket_of = $make_array_len_and_init(n, 0);
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < n) {
      const _p = i >>> 0 < hashes.length ? hashes[i] : $oob();
      const _tmp$2 = BigInt.asUintN(64, BigInt(buckets));
      if (_tmp$2 === 0n) {
        $panic();
      }
      const bucket = Number(BigInt.asIntN(32, BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, _p) >> BigInt(32 & 63))) % BigInt.asUintN(64, _tmp$2)))) | 0;
      if (i >>> 0 < bucket_of.length) {
        bucket_of[i] = bucket;
      } else {
        $oob();
      }
      if (bucket >>> 0 < counts.length) {
        counts[bucket] = (bucket >>> 0 < counts.length ? counts[bucket] : $oob()) + 1 | 0;
      } else {
        $oob();
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const starts = $make_array_len_and_init(buckets, 0);
  let running = 0;
  let _tmp$2 = 0;
  while (true) {
    const b = _tmp$2;
    if (b < buckets) {
      if (b >>> 0 < starts.length) {
        starts[b] = running;
      } else {
        $oob();
      }
      running = running + (b >>> 0 < counts.length ? counts[b] : $oob()) | 0;
      _tmp$2 = b + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const items = $make_array_len_and_init(n, 0);
  const cursor = $make_array_len_and_init(buckets, 0);
  let _tmp$3 = 0;
  while (true) {
    const b = _tmp$3;
    if (b < buckets) {
      if (b >>> 0 < cursor.length) {
        cursor[b] = b >>> 0 < starts.length ? starts[b] : $oob();
      } else {
        $oob();
      }
      _tmp$3 = b + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  let _tmp$4 = 0;
  while (true) {
    const i = _tmp$4;
    if (i < n) {
      const bucket = i >>> 0 < bucket_of.length ? bucket_of[i] : $oob();
      const _tmp$5 = bucket >>> 0 < cursor.length ? cursor[bucket] : $oob();
      if (_tmp$5 >>> 0 < items.length) {
        items[_tmp$5] = i;
      } else {
        $oob();
      }
      if (bucket >>> 0 < cursor.length) {
        cursor[bucket] = (bucket >>> 0 < cursor.length ? cursor[bucket] : $oob()) + 1 | 0;
      } else {
        $oob();
      }
      _tmp$4 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const order = new _M0TPB5ArrayGiE([], 0);
  let _tmp$5 = 0;
  while (true) {
    const b = _tmp$5;
    if (b < buckets) {
      _M0MPC15array5Array4pushGiE(order, b);
      _tmp$5 = b + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0MPC15array5Array8sort__byGiE(order, (a, b) => {
    const left = a >>> 0 < counts.length ? counts[a] : $oob();
    const right = b >>> 0 < counts.length ? counts[b] : $oob();
    return left > right ? -1 : left < right ? 1 : a - b | 0;
  });
  const owner = $make_array_len_and_init(table_len, -1);
  const disps = new _M0TPB5ArrayGiE([], 0);
  let _tmp$6 = 0;
  while (true) {
    const _ = _tmp$6;
    if (_ < buckets) {
      _M0MPC15array5Array4pushGiE(disps, 0);
      _tmp$6 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  let _tmp$7 = 0;
  while (true) {
    const position = _tmp$7;
    if (position < buckets) {
      if (position < 0 || position >= order.len) {
        $panic();
      }
      const bucket = order.buf[position];
      const count = bucket >>> 0 < counts.length ? counts[bucket] : $oob();
      if (count > 0) {
        if (_M0FP312moonbitstack7moonstl3phf22bucket__is__impossible(hashes, items, bucket >>> 0 < starts.length ? starts[bucket] : $oob(), count, table_len)) {
          return undefined;
        }
        const slots = $make_array_len_and_init(count, 0);
        let chosen = -1;
        let displacement = 0;
        while (true) {
          if (chosen < 0 && displacement < max_displacement) {
            let fits = true;
            let j = 0;
            while (true) {
              if (fits && j < count) {
                const _tmp$8 = (bucket >>> 0 < starts.length ? starts[bucket] : $oob()) + j | 0;
                const _tmp$9 = _tmp$8 >>> 0 < items.length ? items[_tmp$8] : $oob();
                const slot = _M0FP312moonbitstack7moonstl3phf9phf__slot(_tmp$9 >>> 0 < hashes.length ? hashes[_tmp$9] : $oob(), displacement, table_len);
                if ((slot >>> 0 < owner.length ? owner[slot] : $oob()) >= 0) {
                  fits = false;
                } else {
                  let t = 0;
                  while (true) {
                    if (fits && t < j) {
                      const _tmp$10 = t;
                      if ((_tmp$10 >>> 0 < slots.length ? slots[_tmp$10] : $oob()) === slot) {
                        fits = false;
                      }
                      t = t + 1 | 0;
                      continue;
                    } else {
                      break;
                    }
                  }
                  if (fits) {
                    const _tmp$10 = j;
                    if (_tmp$10 >>> 0 < slots.length) {
                      slots[_tmp$10] = slot;
                    } else {
                      $oob();
                    }
                  }
                }
                j = j + 1 | 0;
                continue;
              } else {
                break;
              }
            }
            if (fits) {
              chosen = displacement;
            }
            displacement = displacement + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        if (chosen < 0) {
          return undefined;
        }
        let _tmp$8 = 0;
        while (true) {
          const j = _tmp$8;
          if (j < count) {
            const _tmp$9 = j >>> 0 < slots.length ? slots[j] : $oob();
            const _tmp$10 = (bucket >>> 0 < starts.length ? starts[bucket] : $oob()) + j | 0;
            if (_tmp$9 >>> 0 < owner.length) {
              owner[_tmp$9] = _tmp$10 >>> 0 < items.length ? items[_tmp$10] : $oob();
            } else {
              $oob();
            }
            _tmp$8 = j + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        const _bind = chosen;
        if (bucket < 0 || bucket >= disps.len) {
          $panic();
        }
        disps.buf[bucket] = _bind;
      }
      _tmp$7 = position + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return disps;
}
function _M0FP312moonbitstack7moonstl3phf15table__len__for(n, params) {
  const numerator = BigInt.asUintN(64, BigInt.asUintN(64, BigInt(n)) * BigInt.asUintN(64, BigInt(params.load_den)));
  const denominator = BigInt.asUintN(64, BigInt(params.load_num));
  if (denominator === 0n) {
    $panic();
  }
  const scaled = BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, numerator + denominator) - 1n)) / BigInt.asUintN(64, denominator));
  return BigInt.asUintN(64, scaled) < BigInt.asUintN(64, 8n) ? 8 : Number(BigInt.asIntN(32, scaled)) | 0;
}
function _M0FP312moonbitstack7moonstl3phf14search__layout(bytes, build, seed) {
  const n = bytes.len;
  const params = _M0FP312moonbitstack7moonstl3phf13build__params(build);
  if (n === 0) {
    return new _M0TP312moonbitstack7moonstl3phf9PhfLayout(build, _M0FP312moonbitstack7moonstl3phf9phf__salt(seed, 0), 1, 1, 0, new _M0TPB5ArrayGiE([0], 1));
  }
  const _p = n / params.bucket_div | 0;
  const buckets = _p < 1 ? 1 : _p;
  let table_len = _M0FP312moonbitstack7moonstl3phf15table__len__for(n, params);
  let grow = 0;
  while (true) {
    if (grow < 6) {
      let attempt = 0;
      while (true) {
        if (attempt < 64) {
          const salt = _M0FP312moonbitstack7moonstl3phf9phf__salt(seed, (Math.imul(grow, 64) | 0) + attempt | 0);
          const hashes = $make_array_len_and_init(n, 0n);
          let _tmp = 0;
          while (true) {
            const i = _tmp;
            if (i < n) {
              if (i < 0 || i >= bytes.len) {
                $panic();
              }
              if (i >>> 0 < hashes.length) {
                hashes[i] = _M0FP312moonbitstack7moonstl3phf9phf__hash(_M0MPC15bytes5Bytes21clamped__view_2einner(bytes.buf[i], 0, undefined), salt);
              } else {
                $oob();
              }
              _tmp = i + 1 | 0;
              continue;
            } else {
              break;
            }
          }
          const _bind = _M0FP312moonbitstack7moonstl3phf14place__buckets(hashes, buckets, table_len, params.max_displacement);
          if (_bind === undefined) {
            attempt = attempt + 1 | 0;
          } else {
            const _Some = _bind;
            const _disps = _Some;
            return new _M0TP312moonbitstack7moonstl3phf9PhfLayout(build, salt, buckets, table_len, n, _disps);
          }
          continue;
        } else {
          break;
        }
      }
      if (table_len > 268435456) {
        break;
      }
      table_len = Math.imul(table_len, 2) | 0;
      grow = grow + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return undefined;
}
function _M0MP312moonbitstack7moonstl3phf10PhfBuilder5buildGsiE(self) {
  const key_bytes = new _M0TPB5ArrayGzE([], 0);
  const _bind = self.keys;
  const _bind$2 = _bind.len;
  const _bind$3 = _bind.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const key = _bind$3[_];
      _M0MPC15array5Array4pushGRP312moonbitstack7moonstl4text6OpcodeE(key_bytes, _M0IPC16string6StringP312moonbitstack7moonstl3phf6PhfKey9to__bytes(key));
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _bind$4 = _M0FP312moonbitstack7moonstl3phf14search__layout(key_bytes, self.options.build, self.options.seed);
  let layout;
  if (_bind$4 === undefined) {
    return new _M0DTPC16result6ResultGRP312moonbitstack7moonstl3phf6PhfMapGsiERP312moonbitstack7moonstl4spec7RefusedE3Err(new _M0DTPC15error5Error49moonbitstack_2fmoonstl_2fspec_2eRefused_2eTooMany(self.keys.len));
  } else {
    const _Some = _bind$4;
    layout = _Some;
  }
  const entries = new _M0TPB5ArrayGUsiEE([], 0);
  const _bind$5 = self.keys.len;
  let _tmp$2 = 0;
  while (true) {
    const i = _tmp$2;
    if (i < _bind$5) {
      const _bind$6 = self.keys;
      if (i < 0 || i >= _bind$6.len) {
        $panic();
      }
      const _tmp$3 = _bind$6.buf[i];
      const _bind$7 = self.values;
      if (i < 0 || i >= _bind$7.len) {
        $panic();
      }
      _M0MPC15array5Array4pushGRP312moonbitstack7moonstl4text6OpcodeE(entries, { _0: _tmp$3, _1: _bind$7.buf[i] });
      _tmp$2 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return _M0MP312moonbitstack7moonstl3phf6PhfMap12from__layoutGsiE(layout, entries);
}
function _M0FP312moonbitstack7moonstl3phf12utf16__bytes(view) {
  const out = $makebytes(Math.imul(view.end - view.start | 0, 2) | 0, 0);
  const _bind = view.end - view.start | 0;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      if (i < 0 || i >= (view.end - view.start | 0)) {
        $panic();
      }
      const unit = view.str.charCodeAt(view.start + i | 0);
      const _tmp$2 = Math.imul(2, i) | 0;
      if (_tmp$2 >>> 0 < out.length) {
        out[_tmp$2] = unit & 255 & 65535 & 255;
      } else {
        $oob();
      }
      const _tmp$3 = (Math.imul(2, i) | 0) + 1 | 0;
      if (_tmp$3 >>> 0 < out.length) {
        out[_tmp$3] = unit >> 8 & 65535 & 255;
      } else {
        $oob();
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return _M0MPC15bytes5Bytes11from__array(new _M0TPB9ArrayViewGyE(out, 0, out.length));
}
function _M0IPC16string6StringP312moonbitstack7moonstl3phf6PhfKey9to__bytes(self) {
  return _M0FP312moonbitstack7moonstl3phf12utf16__bytes(new _M0TPC16string10StringView(self, 0, self.length));
}
function _M0FP312moonbitstack7moonstl3seq17require__capacity(capacity) {
  if (capacity <= 0) {
    return new _M0DTPC16result6ResultGuRP312moonbitstack7moonstl4spec7RefusedE3Err(new _M0DTPC15error5Error50moonbitstack_2fmoonstl_2fspec_2eRefused_2eCapacity(capacity));
  } else {
    return new _M0DTPC16result6ResultGuRP312moonbitstack7moonstl4spec7RefusedE2Ok(undefined);
  }
}
function _M0MP312moonbitstack7moonstl3seq10RingBuffer11new_2einnerGiE(capacity, overflow) {
  const _bind = _M0FP312moonbitstack7moonstl3seq17require__capacity(capacity);
  if (_bind.$tag === 1) {
    const _ok = _bind;
    _ok._0;
  } else {
    return _bind;
  }
  return new _M0DTPC16result6ResultGRP312moonbitstack7moonstl3seq10RingBufferGiERP312moonbitstack7moonstl4spec7RefusedE2Ok(new _M0TP312moonbitstack7moonstl3seq10RingBufferGiE(new _M0TPB5ArrayGiE([], 0), 0, 0, capacity, overflow));
}
function _M0FP312moonbitstack7moonstl3seq11grown__size(current, needed, ceiling) {
  const doubled = current > (ceiling / 2 | 0) ? ceiling : Math.imul(current, 2) | 0;
  const target = doubled < needed ? needed : doubled;
  return target > ceiling ? ceiling : target;
}
function _M0MP312moonbitstack7moonstl3seq10RingBuffer4growGiE(self, filler) {
  const old = self.slots.len;
  const target = _M0FP312moonbitstack7moonstl3seq11grown__size(old, self.len + 1 | 0, self.capacity);
  const next = new _M0TPB5ArrayGiE([], 0);
  if (old === 0) {
    _M0MPC15array5Array4pushGiE(next, filler);
  } else {
    const _bind = self.len;
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < _bind) {
        const _bind$2 = self.slots;
        const _bind$3 = (self.head + i | 0) % old | 0;
        if (_bind$3 < 0 || _bind$3 >= _bind$2.len) {
          $panic();
        }
        _M0MPC15array5Array4pushGiE(next, _bind$2.buf[_bind$3]);
        _tmp = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    if (0 >= next.len) {
      $panic();
    }
    const fill = next.buf[0];
    while (true) {
      if (next.len < target) {
        _M0MPC15array5Array4pushGiE(next, fill);
        continue;
      } else {
        break;
      }
    }
  }
  self.slots = next;
  self.head = 0;
}
function _M0MP312moonbitstack7moonstl3seq10RingBuffer10push__backGiE(self, value) {
  if (self.len === self.capacity) {
    const _bind = self.overflow;
    if (_bind === 0) {
      const _bind$2 = self.slots;
      const _bind$3 = self.head;
      if (_bind$3 < 0 || _bind$3 >= _bind$2.len) {
        $panic();
      }
      const dropped = _bind$2.buf[_bind$3];
      const slots_len = self.slots.len;
      self.head = (self.head + 1 | 0) % slots_len | 0;
      self.len = self.len - 1 | 0;
      const _bind$4 = self.slots;
      const _bind$5 = (self.head + self.len | 0) % slots_len | 0;
      if (_bind$5 < 0 || _bind$5 >= _bind$4.len) {
        $panic();
      }
      _bind$4.buf[_bind$5] = value;
      self.len = self.len + 1 | 0;
      return dropped;
    } else {
      return value;
    }
  } else {
    if (self.len === self.slots.len) {
      _M0MP312moonbitstack7moonstl3seq10RingBuffer4growGiE(self, value);
    }
    const slots_len = self.slots.len;
    const _bind = self.slots;
    const _bind$2 = (self.head + self.len | 0) % slots_len | 0;
    if (_bind$2 < 0 || _bind$2 >= _bind.len) {
      $panic();
    }
    _bind.buf[_bind$2] = value;
    self.len = self.len + 1 | 0;
    return undefined;
  }
}
function _M0MP312moonbitstack7moonstl3seq10RingBuffer9to__arrayGiE(self) {
  const out = new _M0TPB5ArrayGiE([], 0);
  const slots_len = self.slots.len;
  const _bind = self.len;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      const _bind$2 = self.slots;
      const _bind$3 = (self.head + i | 0) % slots_len | 0;
      if (_bind$3 < 0 || _bind$3 >= _bind$2.len) {
        $panic();
      }
      _M0MPC15array5Array4pushGiE(out, _bind$2.buf[_bind$3]);
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return out;
}
function _M0FP312moonbitstack7moonstl3seq10words__for(bits) {
  return bits <= 0 ? 0 : bits > 134217663 ? 2147483647 : (bits + 63 | 0) / 64 | 0;
}
function _M0FP312moonbitstack7moonstl3seq14popcount__upto(words, limit) {
  let total = 0;
  const stop = limit > words.len ? words.len : limit;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < stop) {
      const _tmp$2 = total;
      if (i < 0 || i >= words.len) {
        $panic();
      }
      total = _tmp$2 + $i64_popcnt(words.buf[i]) | 0;
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return total;
}
function _M0MP312moonbitstack7moonstl3seq6BitSet11new_2einner(capacity) {
  const words = new _M0TPB5ArrayGmE([], 0);
  if (capacity > 0) {
    _M0MPC15array5Array17reserve__capacityGmE(words, _M0FP312moonbitstack7moonstl3seq10words__for(capacity));
  }
  return new _M0TP312moonbitstack7moonstl3seq6BitSet(words);
}
function _M0MP312moonbitstack7moonstl3seq6BitSet4grow(self, index) {
  const needed = _M0FP312moonbitstack7moonstl3seq10words__for(index + 1 | 0);
  while (true) {
    if (self.words.len < needed) {
      _M0MPC15array5Array4pushGRP312moonbitstack7moonstl4text6OpcodeE(self.words, 0n);
      continue;
    } else {
      return;
    }
  }
}
function _M0MP312moonbitstack7moonstl3seq6BitSet6insert(self, index) {
  if (index < 0) {
    return false;
  }
  _M0MP312moonbitstack7moonstl3seq6BitSet4grow(self, index);
  const word = index >> 6;
  const mask = BigInt.asUintN(64, _M0FP312moonbitstack7moonstl3seq9bit__maskN3oneS3810 << BigInt(index & 63 & 63));
  const _bind = self.words;
  if (word < 0 || word >= _bind.len) {
    $panic();
  }
  if (BigInt.asUintN(64, BigInt.asUintN(64, _bind.buf[word] & mask)) !== BigInt.asUintN(64, 0n)) {
    return false;
  } else {
    const _bind$2 = self.words;
    const _bind$3 = self.words;
    if (word < 0 || word >= _bind$3.len) {
      $panic();
    }
    const _bind$4 = BigInt.asUintN(64, _bind$3.buf[word] | mask);
    if (word < 0 || word >= _bind$2.len) {
      $panic();
    }
    _bind$2.buf[word] = _bind$4;
    return true;
  }
}
function _M0MP312moonbitstack7moonstl3seq6BitSet4rank(self, index) {
  if (index <= 0) {
    return 0;
  }
  const word = index >> 6;
  let count = _M0FP312moonbitstack7moonstl3seq14popcount__upto(self.words, word);
  if (word < self.words.len && (index & 63) !== 0) {
    const mask = BigInt.asUintN(64, BigInt.asUintN(64, _M0FP312moonbitstack7moonstl3seq9bit__maskN3oneS3810 << BigInt(index & 63 & 63)) - 1n);
    const _tmp = count;
    const _bind = self.words;
    if (word < 0 || word >= _bind.len) {
      $panic();
    }
    count = _tmp + $i64_popcnt(BigInt.asUintN(64, _bind.buf[word] & mask)) | 0;
  }
  return count;
}
function _M0MP312moonbitstack7moonstl3seq6BitSet6select(self, n) {
  if (n < 0) {
    return undefined;
  }
  let remaining = n;
  let word = 0;
  while (true) {
    if (word < self.words.len) {
      const _bind = self.words;
      const _bind$2 = word;
      if (_bind$2 < 0 || _bind$2 >= _bind.len) {
        $panic();
      }
      const count = $i64_popcnt(_bind.buf[_bind$2]);
      if (remaining < count) {
        let bit = 0;
        while (true) {
          if (bit < 64) {
            const _bind$3 = self.words;
            const _bind$4 = word;
            if (_bind$4 < 0 || _bind$4 >= _bind$3.len) {
              $panic();
            }
            const _tmp = _bind$3.buf[_bind$4];
            const _p = bit;
            if (BigInt.asUintN(64, BigInt.asUintN(64, _tmp & BigInt.asUintN(64, _M0FP312moonbitstack7moonstl3seq9bit__maskN3oneS3810 << BigInt(_p & 63 & 63)))) !== BigInt.asUintN(64, 0n)) {
              if (remaining === 0) {
                return (word << 6) + bit | 0;
              }
              remaining = remaining - 1 | 0;
            }
            bit = bit + 1 | 0;
            continue;
          } else {
            break;
          }
        }
      }
      remaining = remaining - count | 0;
      word = word + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return undefined;
}
function _M0MP312moonbitstack7moonstl3seq6BitSet4iter(self) {
  const word = new _M0TPB8MutLocalGiE(0);
  const bit = new _M0TPB8MutLocalGiE(0);
  return _M0MPB4Iter3newGiE(() => {
    while (true) {
      if (word.val < self.words.len) {
        while (true) {
          if (bit.val < 64) {
            const _bind = self.words;
            const _bind$2 = word.val;
            if (_bind$2 < 0 || _bind$2 >= _bind.len) {
              $panic();
            }
            const _tmp = _bind.buf[_bind$2];
            const _p = bit.val;
            if (BigInt.asUintN(64, BigInt.asUintN(64, _tmp & BigInt.asUintN(64, _M0FP312moonbitstack7moonstl3seq9bit__maskN3oneS3810 << BigInt(_p & 63 & 63)))) !== BigInt.asUintN(64, 0n)) {
              const index = (word.val << 6) + bit.val | 0;
              bit.val = bit.val + 1 | 0;
              return index;
            }
            bit.val = bit.val + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        word.val = word.val + 1 | 0;
        bit.val = 0;
        continue;
      } else {
        break;
      }
    }
    return undefined;
  }, undefined);
}
function _M0MP312moonbitstack7moonstl3seq6BitSet9to__array(self) {
  const out = new _M0TPB5ArrayGiE([], 0);
  const _it = _M0MP312moonbitstack7moonstl3seq6BitSet4iter(self);
  while (true) {
    const _bind = _M0MPB4Iter4nextGiE(_it);
    if (_bind === undefined) {
      break;
    } else {
      const _Some = _bind;
      const _index = _Some;
      _M0MPC15array5Array4pushGiE(out, _index);
      continue;
    }
  }
  return out;
}
function _M0FPC14math13math__pow__js(_tmp, _tmp$2) {
  return Math.pow(_tmp, _tmp$2);
}
function _M0FPC14math3pow(base, exponent) {
  if (base === 1) {
    return 1;
  }
  if (base === -1 && (exponent === _M0FPC16double8infinity || exponent === _M0FPC16double13neg__infinity)) {
    return 1;
  }
  return _M0FPC14math13math__pow__js(base, exponent);
}
function _M0FPC14math2ln(_tmp) {
  return Math.log(_tmp);
}
function _M0FPC14math3exp(_tmp) {
  return Math.exp(_tmp);
}
function _M0FP312moonbitstack7moonstl6sketch16hash__with__seedGiE(item, seed) {
  const low = _M0MPB6Hasher14Hasher_2einner(seed);
  _M0MPB6Hasher7combineGiE(low, item);
  const high = _M0MPB6Hasher14Hasher_2einner(seed ^ 1540483477);
  _M0MPB6Hasher7combineGiE(high, item);
  const _p = _M0MPB6Hasher8finalize(low);
  const _tmp = BigInt.asUintN(64, BigInt.asUintN(64, BigInt(_p)) & 4294967295n);
  const _p$2 = _M0MPB6Hasher8finalize(high);
  return BigInt.asUintN(64, _tmp | BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, BigInt(_p$2)) & 4294967295n) << BigInt(32 & 63)));
}
function _M0FP312moonbitstack7moonstl6sketch5mix64(value) {
  let z = BigInt.asUintN(64, value + 11400714819323198485n);
  z = BigInt.asUintN(64, BigInt.asUintN(64, z ^ BigInt.asUintN(64, BigInt.asUintN(64, z) >> BigInt(30 & 63))) * 13787848793156543929n);
  z = BigInt.asUintN(64, BigInt.asUintN(64, z ^ BigInt.asUintN(64, BigInt.asUintN(64, z) >> BigInt(27 & 63))) * 10723151780598845931n);
  return BigInt.asUintN(64, z ^ BigInt.asUintN(64, BigInt.asUintN(64, z) >> BigInt(31 & 63)));
}
function _M0MP312moonbitstack7moonstl6sketch14CountMinSketch11new_2einnerGiE(epsilon, confidence, hash_seed) {
  if (!(epsilon > 0) || !(epsilon < 1)) {
    return new _M0DTPC16result6ResultGRP312moonbitstack7moonstl6sketch14CountMinSketchGiERP312moonbitstack7moonstl4spec7RefusedE3Err(new _M0DTPC15error5Error53moonbitstack_2fmoonstl_2fspec_2eRefused_2eProbability(epsilon));
  }
  if (!(confidence > 0) || !(confidence < 1)) {
    return new _M0DTPC16result6ResultGRP312moonbitstack7moonstl6sketch14CountMinSketchGiERP312moonbitstack7moonstl4spec7RefusedE3Err(new _M0DTPC15error5Error53moonbitstack_2fmoonstl_2fspec_2eRefused_2eProbability(confidence));
  }
  const width = _M0MPC16double6Double7to__int(_M0MPC16double6Double4ceil(2.7182818284590451 / epsilon));
  const depth = _M0MPC16double6Double7to__int(_M0MPC16double6Double4ceil(_M0FPC14math2ln(1 / (1 - confidence))));
  const w = width < 1 ? 1 : width;
  const d = depth < 1 ? 1 : depth;
  const counters = new _M0TPB5ArrayGiE([], 0);
  const _bind = Math.imul(w, d) | 0;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      _M0MPC15array5Array4pushGiE(counters, 0);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPC16result6ResultGRP312moonbitstack7moonstl6sketch14CountMinSketchGiERP312moonbitstack7moonstl4spec7RefusedE2Ok(new _M0TP312moonbitstack7moonstl6sketch14CountMinSketchGiE(hash_seed, w, d, counters, 0n));
}
function _M0MP312moonbitstack7moonstl6sketch14CountMinSketch6columnGiE(self, item_hash, row) {
  const mixed = _M0FP312moonbitstack7moonstl6sketch5mix64(BigInt.asUintN(64, item_hash ^ BigInt.asUintN(64, BigInt.asUintN(64, BigInt(row)) * 11400714819323198485n)));
  const _p = self.width;
  const _tmp = BigInt.asUintN(64, BigInt(_p));
  if (_tmp === 0n) {
    $panic();
  }
  return Number(BigInt.asUintN(32, BigInt.asUintN(64, BigInt.asUintN(64, mixed) % BigInt.asUintN(64, _tmp)))) | 0;
}
function _M0MP312moonbitstack7moonstl6sketch14CountMinSketch6insertGiE(self, item) {
  const hash = _M0FP312moonbitstack7moonstl6sketch16hash__with__seedGiE(item, self.seed);
  let lowest = 2147483647;
  const _bind = self.depth;
  let _tmp = 0;
  while (true) {
    const row = _tmp;
    if (row < _bind) {
      const at = (Math.imul(row, self.width) | 0) + _M0MP312moonbitstack7moonstl6sketch14CountMinSketch6columnGiE(self, hash, row) | 0;
      const _bind$2 = self.counters;
      if (at < 0 || at >= _bind$2.len) {
        $panic();
      }
      if (_bind$2.buf[at] < lowest) {
        const _bind$3 = self.counters;
        if (at < 0 || at >= _bind$3.len) {
          $panic();
        }
        lowest = _bind$3.buf[at];
      }
      _tmp = row + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _bind$2 = self.depth;
  let _tmp$2 = 0;
  while (true) {
    const row = _tmp$2;
    if (row < _bind$2) {
      const at = (Math.imul(row, self.width) | 0) + _M0MP312moonbitstack7moonstl6sketch14CountMinSketch6columnGiE(self, hash, row) | 0;
      const _bind$3 = self.counters;
      if (at < 0 || at >= _bind$3.len) {
        $panic();
      }
      if (_bind$3.buf[at] === lowest) {
        const _bind$4 = self.counters;
        const _bind$5 = self.counters;
        if (at < 0 || at >= _bind$5.len) {
          $panic();
        }
        const _bind$6 = _bind$5.buf[at] + 1 | 0;
        if (at < 0 || at >= _bind$4.len) {
          $panic();
        }
        _bind$4.buf[at] = _bind$6;
      }
      _tmp$2 = row + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  self.total = BigInt.asUintN(64, self.total + 1n);
}
function _M0MP312moonbitstack7moonstl6sketch14CountMinSketch8estimateGiE(self, item) {
  const hash = _M0FP312moonbitstack7moonstl6sketch16hash__with__seedGiE(item, self.seed);
  let lowest = 2147483647;
  const _bind = self.depth;
  let _tmp = 0;
  while (true) {
    const row = _tmp;
    if (row < _bind) {
      const at = (Math.imul(row, self.width) | 0) + _M0MP312moonbitstack7moonstl6sketch14CountMinSketch6columnGiE(self, hash, row) | 0;
      const _bind$2 = self.counters;
      if (at < 0 || at >= _bind$2.len) {
        $panic();
      }
      if (_bind$2.buf[at] < lowest) {
        const _bind$3 = self.counters;
        if (at < 0 || at >= _bind$3.len) {
          $panic();
        }
        lowest = _bind$3.buf[at];
      }
      _tmp = row + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return lowest === 2147483647 ? 0 : lowest;
}
function _M0FP312moonbitstack7moonstl6sketch16bloom__bit__size(capacity, rate, hashes) {
  const per_bit = 1 - _M0FPC14math3pow(rate, 1 / (hashes + 0));
  return -((hashes + 0) * (capacity + 0)) / _M0FPC14math2ln(per_bit);
}
function _M0FP312moonbitstack7moonstl6sketch18bloom__hash__count(rate) {
  const optimal = -_M0FPC14math2ln(rate) * 1.4426950408889634;
  let count = _M0MPC16double6Double7to__int(_M0MPC16double6Double5round(optimal));
  if (count < 1) {
    count = 1;
  }
  if (count > 64) {
    count = 64;
  }
  return count;
}
function _M0FP312moonbitstack7moonstl6sketch18bloom__layer__rate(rate, index) {
  const scaled = rate * _M0FPC14math3pow(0.5, (index + 1 | 0) + 0);
  return scaled < 1.00000000001e-313 ? 1.00000000001e-313 : scaled;
}
function _M0FP312moonbitstack7moonstl6sketch12bloom__layer(capacity, rate, hashes) {
  const bits = _M0FP312moonbitstack7moonstl6sketch16bloom__bit__size(capacity, rate, hashes);
  if (bits > 2147483584) {
    return undefined;
  }
  let words = (_M0MPC16double6Double7to__int(_M0MPC16double6Double4ceil(bits)) + 63 | 0) / 64 | 0;
  if (words < 1) {
    words = 1;
  }
  return new _M0TP312moonbitstack7moonstl6sketch10BloomLayer(_M0MPC15array5Array4makeGmE(words, 0n), Math.imul(words, 64) | 0, capacity, 0n, rate);
}
function _M0FP312moonbitstack7moonstl6sketch15bloom__position(hash, index, bit_count) {
  const step = BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, hash) >> BigInt(32 & 63)) | 1n);
  const _tmp = BigInt.asUintN(64, BigInt(bit_count));
  if (_tmp === 0n) {
    $panic();
  }
  return Number(BigInt.asUintN(32, BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, hash + BigInt.asUintN(64, BigInt.asUintN(64, BigInt(index)) * step))) % BigInt.asUintN(64, _tmp)))) | 0;
}
function _M0FP312moonbitstack7moonstl6sketch10bloom__set(layer, hash, hashes) {
  let changed = false;
  let _tmp = 0;
  while (true) {
    const index = _tmp;
    if (index < hashes) {
      const position = _M0FP312moonbitstack7moonstl6sketch15bloom__position(hash, index, layer.bit_count);
      const word = position / 64 | 0;
      const mask = BigInt.asUintN(64, 1n << BigInt(position % 64 & 63));
      const _bind = layer.words;
      if (word < 0 || word >= _bind.len) {
        $panic();
      }
      if (BigInt.asUintN(64, BigInt.asUintN(64, _bind.buf[word] & mask)) === BigInt.asUintN(64, 0n)) {
        const _bind$2 = layer.words;
        const _bind$3 = layer.words;
        if (word < 0 || word >= _bind$3.len) {
          $panic();
        }
        const _bind$4 = BigInt.asUintN(64, _bind$3.buf[word] | mask);
        if (word < 0 || word >= _bind$2.len) {
          $panic();
        }
        _bind$2.buf[word] = _bind$4;
        changed = true;
      }
      _tmp = index + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return changed;
}
function _M0FP312moonbitstack7moonstl6sketch11bloom__test(layer, hash, hashes) {
  let _tmp = 0;
  while (true) {
    const index = _tmp;
    if (index < hashes) {
      const position = _M0FP312moonbitstack7moonstl6sketch15bloom__position(hash, index, layer.bit_count);
      const word = position / 64 | 0;
      const mask = BigInt.asUintN(64, 1n << BigInt(position % 64 & 63));
      const _bind = layer.words;
      if (word < 0 || word >= _bind.len) {
        $panic();
      }
      if (BigInt.asUintN(64, BigInt.asUintN(64, _bind.buf[word] & mask)) === BigInt.asUintN(64, 0n)) {
        return false;
      }
      _tmp = index + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return true;
}
function _M0MP312moonbitstack7moonstl6sketch11BloomFilter11new_2einnerGiE(expected_items, bloom_options, hash_seed) {
  if (expected_items <= 0) {
    return new _M0DTPC16result6ResultGRP312moonbitstack7moonstl6sketch11BloomFilterGiERP312moonbitstack7moonstl4spec7RefusedE3Err(new _M0DTPC15error5Error50moonbitstack_2fmoonstl_2fspec_2eRefused_2eCapacity(expected_items));
  }
  const rate = bloom_options.false_positive_rate;
  if (!(rate > 0) || !(rate < 1)) {
    return new _M0DTPC16result6ResultGRP312moonbitstack7moonstl6sketch11BloomFilterGiERP312moonbitstack7moonstl4spec7RefusedE3Err(new _M0DTPC15error5Error53moonbitstack_2fmoonstl_2fspec_2eRefused_2eProbability(rate));
  }
  const hashes = _M0FP312moonbitstack7moonstl6sketch18bloom__hash__count(rate);
  const _bind = _M0FP312moonbitstack7moonstl6sketch12bloom__layer(expected_items, _M0FP312moonbitstack7moonstl6sketch18bloom__layer__rate(rate, 0), hashes);
  let layer;
  if (_bind === undefined) {
    return new _M0DTPC16result6ResultGRP312moonbitstack7moonstl6sketch11BloomFilterGiERP312moonbitstack7moonstl4spec7RefusedE3Err(new _M0DTPC15error5Error50moonbitstack_2fmoonstl_2fspec_2eRefused_2eCapacity(expected_items));
  } else {
    const _Some = _bind;
    layer = _Some;
  }
  return new _M0DTPC16result6ResultGRP312moonbitstack7moonstl6sketch11BloomFilterGiERP312moonbitstack7moonstl4spec7RefusedE2Ok(new _M0TP312moonbitstack7moonstl6sketch11BloomFilterGiE(hash_seed, hashes, expected_items, rate, bloom_options.growth, new _M0TPB5ArrayGRP312moonbitstack7moonstl6sketch10BloomLayerE([layer], 1), 0n));
}
function _M0MP312moonbitstack7moonstl6sketch11BloomFilter3newGiE(expected_items, bloom_options$46$opt, hash_seed$46$opt) {
  let bloom_options;
  if (bloom_options$46$opt === undefined) {
    bloom_options = _M0FP312moonbitstack7moonstl6sketch14bloom__options;
  } else {
    const _Some = bloom_options$46$opt;
    bloom_options = _Some;
  }
  let hash_seed;
  if (hash_seed$46$opt === undefined) {
    hash_seed = _M0FP312moonbitstack7moonstl4spec10hash__seed();
  } else {
    const _Some = hash_seed$46$opt;
    hash_seed = _Some;
  }
  return _M0MP312moonbitstack7moonstl6sketch11BloomFilter11new_2einnerGiE(expected_items, bloom_options, hash_seed);
}
function _M0MP312moonbitstack7moonstl6sketch11BloomFilter16grow__if__neededGiE(self) {
  const _bind = self.growth;
  if (_bind === 0) {
    return undefined;
  }
  let growing = true;
  while (true) {
    if (growing) {
      growing = false;
      const index = self.layers.len - 1 | 0;
      const _bind$2 = self.layers;
      if (index < 0 || index >= _bind$2.len) {
        $panic();
      }
      const last = _bind$2.buf[index];
      if (BigInt.asIntN(64, last.items) < BigInt.asIntN(64, BigInt.asUintN(64, BigInt(last.capacity)))) {
        return undefined;
      }
      if (last.capacity <= 1073741824) {
        const next_capacity = Math.imul(last.capacity, 2) | 0;
        const next_rate = _M0FP312moonbitstack7moonstl6sketch18bloom__layer__rate(self.false_positive_rate, self.layers.len);
        const _bind$3 = _M0FP312moonbitstack7moonstl6sketch12bloom__layer(next_capacity, next_rate, self.hashes);
        if (_bind$3 === undefined) {
        } else {
          const _Some = _bind$3;
          const _layer = _Some;
          _M0MPC15array5Array4pushGRP312moonbitstack7moonstl4text6OpcodeE(self.layers, _layer);
          growing = true;
        }
      }
      continue;
    } else {
      return;
    }
  }
}
function _M0MP312moonbitstack7moonstl6sketch11BloomFilter12may__containGiE(self, item) {
  const hash = _M0FP312moonbitstack7moonstl6sketch16hash__with__seedGiE(item, self.hash_seed);
  const _bind = self.layers.len;
  let _tmp = 0;
  while (true) {
    const index = _tmp;
    if (index < _bind) {
      const _bind$2 = self.layers;
      if (index < 0 || index >= _bind$2.len) {
        $panic();
      }
      if (_M0FP312moonbitstack7moonstl6sketch11bloom__test(_bind$2.buf[index], hash, self.hashes)) {
        return true;
      }
      _tmp = index + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return false;
}
function _M0MP312moonbitstack7moonstl6sketch11BloomFilter6insertGiE(self, item) {
  if (_M0MP312moonbitstack7moonstl6sketch11BloomFilter12may__containGiE(self, item)) {
    return false;
  }
  _M0MP312moonbitstack7moonstl6sketch11BloomFilter16grow__if__neededGiE(self);
  const index = self.layers.len - 1 | 0;
  const hash = _M0FP312moonbitstack7moonstl6sketch16hash__with__seedGiE(item, self.hash_seed);
  const _bind = self.layers;
  if (index < 0 || index >= _bind.len) {
    $panic();
  }
  const changed = _M0FP312moonbitstack7moonstl6sketch10bloom__set(_bind.buf[index], hash, self.hashes);
  if (changed) {
    const _bind$2 = self.layers;
    if (index < 0 || index >= _bind$2.len) {
      $panic();
    }
    const layer = _bind$2.buf[index];
    layer.items = BigInt.asUintN(64, layer.items + 1n);
    const _bind$3 = self.layers;
    if (index < 0 || index >= _bind$3.len) {
      $panic();
    }
    _bind$3.buf[index] = layer;
    self.items = BigInt.asUintN(64, self.items + 1n);
  }
  return changed;
}
function _M0MP312moonbitstack7moonstl6sketch11BloomFilter32estimated__false__positive__rateGiE(self) {
  let survives = 1;
  const _bind = self.layers.len;
  let _tmp = 0;
  while (true) {
    const index = _tmp;
    if (index < _bind) {
      const _bind$2 = self.layers;
      if (index < 0 || index >= _bind$2.len) {
        $panic();
      }
      const layer = _bind$2.buf[index];
      if (BigInt.asIntN(64, layer.items) > BigInt.asIntN(64, 0n)) {
        const n = $f64_convert_i64(BigInt.asIntN(64, layer.items));
        const m = layer.bit_count + 0;
        const k = self.hashes + 0;
        const filled = 1 - _M0FPC14math3exp(-(k * n) / m);
        const rate = _M0FPC14math3pow(filled, k);
        survives = survives * (1 - rate);
      }
      _tmp = index + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return 1 - survives;
}
function _M0FP312moonbitstack7moonstl4text12kmp__failure(pattern) {
  const m = pattern.end - pattern.start | 0;
  const fail = _M0MPC15array5Array4makeGiE(m, 0);
  let k = 0;
  let _tmp = 1;
  while (true) {
    const i = _tmp;
    if (i < m) {
      const c = pattern.str.charCodeAt(pattern.start + i | 0);
      while (true) {
        let _tmp$2;
        if (k > 0) {
          const _p = k;
          _tmp$2 = c !== pattern.str.charCodeAt(pattern.start + _p | 0);
        } else {
          _tmp$2 = false;
        }
        if (_tmp$2) {
          const _bind = k - 1 | 0;
          if (_bind < 0 || _bind >= fail.len) {
            $panic();
          }
          k = fail.buf[_bind];
          continue;
        } else {
          break;
        }
      }
      const _p = k;
      if (c === pattern.str.charCodeAt(pattern.start + _p | 0)) {
        k = k + 1 | 0;
      }
      const _bind = k;
      if (i < 0 || i >= fail.len) {
        $panic();
      }
      fail.buf[i] = _bind;
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return fail;
}
function _M0MP312moonbitstack7moonstl4text3Kmp3new(pattern) {
  return new _M0TP312moonbitstack7moonstl4text3Kmp(_M0MPC16string10StringView9to__owned(pattern), _M0FP312moonbitstack7moonstl4text12kmp__failure(pattern));
}
function _M0MP312moonbitstack7moonstl4text7KmpScan12next__offset(self) {
  const m = self.fail.len;
  const _bind = self.text;
  const n = _bind.end - _bind.start | 0;
  const _bind$2 = self.pattern;
  const pattern = new _M0TPC16string10StringView(_bind$2, 0, _bind$2.length);
  while (true) {
    if (self.pos < n) {
      const _p = self.text;
      const _p$2 = self.pos;
      const c = _p.str.charCodeAt(_p.start + _p$2 | 0);
      self.pos = self.pos + 1 | 0;
      while (true) {
        let _tmp;
        if (self.matched > 0) {
          const _p$3 = self.matched;
          _tmp = c !== pattern.str.charCodeAt(pattern.start + _p$3 | 0);
        } else {
          _tmp = false;
        }
        if (_tmp) {
          const _bind$3 = self.fail;
          const _bind$4 = self.matched - 1 | 0;
          if (_bind$4 < 0 || _bind$4 >= _bind$3.len) {
            $panic();
          }
          self.matched = _bind$3.buf[_bind$4];
          continue;
        } else {
          break;
        }
      }
      const _p$3 = self.matched;
      if (c === pattern.str.charCodeAt(pattern.start + _p$3 | 0)) {
        self.matched = self.matched + 1 | 0;
      }
      if (self.matched === m) {
        const _bind$3 = self.fail;
        const _bind$4 = m - 1 | 0;
        if (_bind$4 < 0 || _bind$4 >= _bind$3.len) {
          $panic();
        }
        self.matched = _bind$3.buf[_bind$4];
        return self.pos - m | 0;
      }
      continue;
    } else {
      break;
    }
  }
  return undefined;
}
function _M0MP312moonbitstack7moonstl4text9EmptyScan12next__offset(self) {
  if (self.pos > self.end) {
    return undefined;
  }
  const at = self.pos;
  self.pos = self.pos + 1 | 0;
  return at;
}
function _M0MP312moonbitstack7moonstl4text3Kmp11search__all(self, text) {
  if (self.fail.len === 0) {
    const scan = new _M0TP312moonbitstack7moonstl4text9EmptyScan(0, text.end - text.start | 0);
    return _M0MPB4Iter3newGiE(() => _M0MP312moonbitstack7moonstl4text9EmptyScan12next__offset(scan), undefined);
  }
  const scan = new _M0TP312moonbitstack7moonstl4text7KmpScan(self.pattern, self.fail, text, 0, 0);
  return _M0MPB4Iter3newGiE(() => _M0MP312moonbitstack7moonstl4text7KmpScan12next__offset(scan), undefined);
}
function _M0FP312moonbitstack7moonstl4text26sequence__matcher__optionsGcE() {
  return new _M0TP312moonbitstack7moonstl4text22SequenceMatcherOptionsGcE(true, (_discard_) => false);
}
function _M0MP312moonbitstack7moonstl4text6Opcode3tag(self) {
  switch (self.$tag) {
    case 0: {
      return "equal";
    }
    case 1: {
      return "replace";
    }
    case 2: {
      return "delete";
    }
    default: {
      return "insert";
    }
  }
}
function _M0MP312moonbitstack7moonstl4text6Opcode2a1(self) {
  switch (self.$tag) {
    case 0: {
      const _Equal = self;
      const _a1 = _Equal._0;
      return _a1;
    }
    case 1: {
      const _Replace = self;
      const _a1$2 = _Replace._0;
      return _a1$2;
    }
    case 2: {
      const _Delete = self;
      const _a1$3 = _Delete._0;
      return _a1$3;
    }
    default: {
      const _Insert = self;
      const _a1$4 = _Insert._0;
      return _a1$4;
    }
  }
}
function _M0MP312moonbitstack7moonstl4text6Opcode2a2(self) {
  switch (self.$tag) {
    case 0: {
      const _Equal = self;
      const _a2 = _Equal._1;
      return _a2;
    }
    case 1: {
      const _Replace = self;
      const _a2$2 = _Replace._1;
      return _a2$2;
    }
    case 2: {
      const _Delete = self;
      const _a2$3 = _Delete._1;
      return _a2$3;
    }
    default: {
      const _Insert = self;
      const _a2$4 = _Insert._1;
      return _a2$4;
    }
  }
}
function _M0MP312moonbitstack7moonstl4text6Opcode2b1(self) {
  switch (self.$tag) {
    case 0: {
      const _Equal = self;
      const _b1 = _Equal._2;
      return _b1;
    }
    case 1: {
      const _Replace = self;
      const _b1$2 = _Replace._2;
      return _b1$2;
    }
    case 2: {
      const _Delete = self;
      const _b1$3 = _Delete._2;
      return _b1$3;
    }
    default: {
      const _Insert = self;
      const _b1$4 = _Insert._2;
      return _b1$4;
    }
  }
}
function _M0MP312moonbitstack7moonstl4text6Opcode2b2(self) {
  switch (self.$tag) {
    case 0: {
      const _Equal = self;
      const _b2 = _Equal._3;
      return _b2;
    }
    case 1: {
      const _Replace = self;
      const _b2$2 = _Replace._3;
      return _b2$2;
    }
    case 2: {
      const _Delete = self;
      const _b2$3 = _Delete._3;
      return _b2$3;
    }
    default: {
      const _Insert = self;
      const _b2$4 = _Insert._3;
      return _b2$4;
    }
  }
}
function _M0MP312moonbitstack7moonstl4text15SequenceMatcher8index__bGcE(self) {
  const junk = new _M0TPB5ArrayGbE([], 0);
  const _bind = self.b.len;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      _M0MPC15array5Array4pushGbE(junk, false);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _bind$2 = [];
  const positions = _M0MPB3Map3MapGcRPB5ArrayGiEE(new _M0TPB9ArrayViewGUcRPB5ArrayGiEEE(_bind$2, 0, 0), undefined);
  const _bind$3 = self.b.len;
  let _tmp$2 = 0;
  while (true) {
    const i = _tmp$2;
    if (i < _bind$3) {
      const _bind$4 = self.b;
      if (i < 0 || i >= _bind$4.len) {
        $panic();
      }
      const element = _bind$4.buf[i];
      const _func = self.options.junk;
      if (_func(element)) {
        if (i < 0 || i >= junk.len) {
          $panic();
        }
        junk.buf[i] = true;
      } else {
        const _bind$5 = _M0MPB3Map3getGcRPB5ArrayGiEE(positions, element);
        if (_bind$5 === undefined) {
          _M0MPB3Map3setGcRPB5ArrayGiEE(positions, element, new _M0TPB5ArrayGiE([i], 1));
        } else {
          const _Some = _bind$5;
          const _list = _Some;
          _M0MPC15array5Array4pushGiE(_list, i);
        }
      }
      _tmp$2 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (self.options.autojunk && self.b.len >= 200) {
    const threshold = (self.b.len / 100 | 0) + 1 | 0;
    const _bind$4 = [];
    const popular = _M0MPB3Map3MapGcuE(new _M0TPB9ArrayViewGUcuEE(_bind$4, 0, 0), undefined);
    const _it = _M0MPB3Map4iterGcRPB5ArrayGiEE(positions);
    while (true) {
      const _bind$5 = _M0MPB4Iter4nextGUcRPB5ArrayGiEEE(_it);
      if (_bind$5 === undefined) {
        break;
      } else {
        const _Some = _bind$5;
        const _x = _Some;
        const _element = _x._0;
        const _list = _x._1;
        if (_list.len > threshold) {
          _M0MPB3Map3setGcuE(popular, _element, undefined);
        }
        continue;
      }
    }
    const _bind$5 = self.b.len;
    let _tmp$3 = 0;
    while (true) {
      const i = _tmp$3;
      if (i < _bind$5) {
        const _bind$6 = self.b;
        if (i < 0 || i >= _bind$6.len) {
          $panic();
        }
        if (_M0MPB3Map8containsGcuE(popular, _bind$6.buf[i])) {
          if (i < 0 || i >= junk.len) {
            $panic();
          }
          junk.buf[i] = true;
        }
        _tmp$3 = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    const _it$2 = _M0MPB3Map4keysGcuE(popular);
    while (true) {
      const _bind$6 = _M0MPB4Iter4nextGcE(_it$2);
      if (_bind$6 === -1) {
        break;
      } else {
        const _Some = _bind$6;
        const _element = _Some;
        _M0MPB3Map6removeGcRPB5ArrayGiEE(positions, _element);
        continue;
      }
    }
  }
  self.b2j = positions;
  self.bjunk = junk;
  const _bind$4 = [];
  self.bpopular = _M0MPB3Map3MapGcuE(new _M0TPB9ArrayViewGUcuEE(_bind$4, 0, 0), undefined);
}
function _M0MP312moonbitstack7moonstl4text15SequenceMatcher11new_2einnerGcE(a, b, options) {
  const first = _M0MPC15array9ArrayView9to__ownedGcE(a);
  const second = _M0MPC15array9ArrayView9to__ownedGcE(b);
  const _bind = [];
  const _tmp = _M0MPB3Map3MapGcRPB5ArrayGiEE(new _M0TPB9ArrayViewGUcRPB5ArrayGiEEE(_bind, 0, 0), undefined);
  const _tmp$2 = new _M0TPB5ArrayGbE([], 0);
  const _bind$2 = [];
  const matcher = new _M0TP312moonbitstack7moonstl4text15SequenceMatcherGcE(first, second, options, _tmp, _tmp$2, _M0MPB3Map3MapGcuE(new _M0TPB9ArrayViewGUcuEE(_bind$2, 0, 0), undefined));
  _M0MP312moonbitstack7moonstl4text15SequenceMatcher8index__bGcE(matcher);
  return matcher;
}
function _M0MP312moonbitstack7moonstl4text15SequenceMatcher3newGcE(a, b, options$46$opt) {
  let options;
  if (options$46$opt === undefined) {
    options = _M0FP312moonbitstack7moonstl4text26sequence__matcher__optionsGcE();
  } else {
    const _Some = options$46$opt;
    options = _Some;
  }
  return _M0MP312moonbitstack7moonstl4text15SequenceMatcher11new_2einnerGcE(a, b, options);
}
function _M0MP312moonbitstack7moonstl4text15SequenceMatcher20find__longest__matchGcE(self, alo, ahi, blo, bhi) {
  let best_i = alo;
  let best_j = blo;
  let best_size = 0;
  const _bind = [];
  let j2len = _M0MPB3Map3MapGiiE(new _M0TPB9ArrayViewGUiiEE(_bind, 0, 0), undefined);
  let _tmp = alo;
  while (true) {
    const i = _tmp;
    if (i < ahi) {
      const _bind$2 = self.a;
      if (i < 0 || i >= _bind$2.len) {
        $panic();
      }
      const element = _bind$2.buf[i];
      const _bind$3 = [];
      const next = _M0MPB3Map3MapGiiE(new _M0TPB9ArrayViewGUiiEE(_bind$3, 0, 0), undefined);
      const _bind$4 = _M0MPB3Map3getGcRPB5ArrayGiEE(self.b2j, element);
      if (_bind$4 === undefined) {
      } else {
        const _Some = _bind$4;
        const _positions = _Some;
        const _bind$5 = _positions.len;
        const _bind$6 = _positions.buf;
        let _tmp$2 = 0;
        while (true) {
          const _ = _tmp$2;
          if (_ < _bind$5) {
            const j = _bind$6[_];
            _L: {
              if (j < blo) {
                break _L;
              }
              if (j >= bhi) {
                break;
              }
              const _bind$7 = _M0MPB3Map3getGiiE(j2len, j - 1 | 0);
              let length;
              if (_bind$7 === undefined) {
                length = 1;
              } else {
                const _Some$2 = _bind$7;
                const _previous = _Some$2;
                length = _previous + 1 | 0;
              }
              _M0MPB3Map3setGiiE(next, j, length);
              if (length > best_size) {
                best_i = (i + 1 | 0) - length | 0;
                best_j = (j + 1 | 0) - length | 0;
                best_size = length;
              }
              break _L;
            }
            _tmp$2 = _ + 1 | 0;
            continue;
          } else {
            break;
          }
        }
      }
      j2len = next;
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  while (true) {
    let _tmp$2;
    if (best_i > alo) {
      let _tmp$3;
      if (best_j > blo) {
        const _bind$2 = self.bjunk;
        const _bind$3 = best_j - 1 | 0;
        if (_bind$3 < 0 || _bind$3 >= _bind$2.len) {
          $panic();
        }
        _tmp$3 = _bind$2.buf[_bind$3];
      } else {
        _tmp$3 = false;
      }
      _tmp$2 = _tmp$3;
    } else {
      _tmp$2 = false;
    }
    if (_tmp$2) {
      best_i = best_i - 1 | 0;
      best_j = best_j - 1 | 0;
      best_size = best_size + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  while (true) {
    let _tmp$2;
    if ((best_i + best_size | 0) < ahi) {
      let _tmp$3;
      if ((best_j + best_size | 0) < bhi) {
        const _bind$2 = self.bjunk;
        const _bind$3 = best_j + best_size | 0;
        if (_bind$3 < 0 || _bind$3 >= _bind$2.len) {
          $panic();
        }
        _tmp$3 = _bind$2.buf[_bind$3];
      } else {
        _tmp$3 = false;
      }
      _tmp$2 = _tmp$3;
    } else {
      _tmp$2 = false;
    }
    if (_tmp$2) {
      best_size = best_size + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0TP312moonbitstack7moonstl4text5Match(best_i, best_j, best_size);
}
function _M0MP312moonbitstack7moonstl4text15SequenceMatcher21get__matching__blocksGcE(self) {
  const blocks = new _M0TPB5ArrayGRP312moonbitstack7moonstl4text5MatchE([], 0);
  const queue = new _M0TPB5ArrayGUiiiiEE([{ _0: 0, _1: self.a.len, _2: 0, _3: self.b.len }], 1);
  while (true) {
    if (queue.len > 0) {
      const _p = _M0MPC15array5Array3popGUiiEE(queue);
      let _bind;
      if (_p === undefined) {
        _bind = $panic();
      } else {
        const _p$2 = _p;
        _bind = _p$2;
      }
      const _alo = _bind._0;
      const _ahi = _bind._1;
      const _blo = _bind._2;
      const _bhi = _bind._3;
      const found = _M0MP312moonbitstack7moonstl4text15SequenceMatcher20find__longest__matchGcE(self, _alo, _ahi, _blo, _bhi);
      const i = found.a_start;
      const j = found.b_start;
      const size = found.size;
      if (size > 0) {
        _M0MPC15array5Array4pushGRP312moonbitstack7moonstl4text6OpcodeE(blocks, found);
        if (_alo < i && _blo < j) {
          _M0MPC15array5Array4pushGRP312moonbitstack7moonstl4text6OpcodeE(queue, { _0: _alo, _1: i, _2: _blo, _3: j });
        }
        if ((i + size | 0) < _ahi && (j + size | 0) < _bhi) {
          _M0MPC15array5Array4pushGRP312moonbitstack7moonstl4text6OpcodeE(queue, { _0: i + size | 0, _1: _ahi, _2: j + size | 0, _3: _bhi });
        }
      }
      continue;
    } else {
      break;
    }
  }
  _M0MPC15array5Array8sort__byGUciEE(blocks, (left, right) => {
    const order = $compare_int(left.a_start, right.a_start);
    return order !== 0 ? order : $compare_int(left.b_start, right.b_start);
  });
  const merged = new _M0TPB5ArrayGRP312moonbitstack7moonstl4text5MatchE([], 0);
  const _bind = blocks.len;
  const _bind$2 = blocks.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const block = _bind$2[_];
      _L: {
        if (merged.len > 0) {
          const _bind$3 = merged.len - 1 | 0;
          if (_bind$3 < 0 || _bind$3 >= merged.len) {
            $panic();
          }
          const last = merged.buf[_bind$3];
          if ((last.a_start + last.size | 0) === block.a_start && (last.b_start + last.size | 0) === block.b_start) {
            const _bind$4 = merged.len - 1 | 0;
            const _bind$5 = new _M0TP312moonbitstack7moonstl4text5Match(last.a_start, last.b_start, last.size + block.size | 0);
            if (_bind$4 < 0 || _bind$4 >= merged.len) {
              $panic();
            }
            merged.buf[_bind$4] = _bind$5;
            break _L;
          }
        }
        _M0MPC15array5Array4pushGRP312moonbitstack7moonstl4text6OpcodeE(merged, block);
        break _L;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0MPC15array5Array4pushGRP312moonbitstack7moonstl4text6OpcodeE(merged, new _M0TP312moonbitstack7moonstl4text5Match(self.a.len, self.b.len, 0));
  return merged;
}
function _M0MP312moonbitstack7moonstl4text15SequenceMatcher12get__opcodesGcE(self) {
  const opcodes = new _M0TPB5ArrayGRP312moonbitstack7moonstl4text6OpcodeE([], 0);
  let i = 0;
  let j = 0;
  const _bind = _M0MP312moonbitstack7moonstl4text15SequenceMatcher21get__matching__blocksGcE(self);
  const _bind$2 = _bind.len;
  const _bind$3 = _bind.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const block = _bind$3[_];
      const ai = block.a_start;
      const bj = block.b_start;
      const size = block.size;
      const tag = i < ai && j < bj ? new _M0DTP312moonbitstack7moonstl4text6Opcode7Replace(i, ai, j, bj) : i < ai ? new _M0DTP312moonbitstack7moonstl4text6Opcode6Delete(i, ai, j, bj) : j < bj ? new _M0DTP312moonbitstack7moonstl4text6Opcode6Insert(i, ai, j, bj) : undefined;
      if (tag === undefined) {
      } else {
        const _Some = tag;
        const _opcode = _Some;
        _M0MPC15array5Array4pushGRP312moonbitstack7moonstl4text6OpcodeE(opcodes, _opcode);
      }
      if (size > 0) {
        _M0MPC15array5Array4pushGRP312moonbitstack7moonstl4text6OpcodeE(opcodes, new _M0DTP312moonbitstack7moonstl4text6Opcode5Equal(ai, ai + size | 0, bj, bj + size | 0));
      }
      i = ai + size | 0;
      j = bj + size | 0;
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return opcodes;
}
function _M0MP312moonbitstack7moonstl4text15SequenceMatcher5ratioGcE(self) {
  let matches = 0;
  const _bind = _M0MP312moonbitstack7moonstl4text15SequenceMatcher21get__matching__blocksGcE(self);
  const _bind$2 = _bind.len;
  const _bind$3 = _bind.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const block = _bind$3[_];
      matches = matches + block.size | 0;
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const total = self.a.len + self.b.len | 0;
  return total === 0 ? 1 : 2 * (matches + 0) / (total + 0);
}
function _M0FP312moonbitstack7moonstl4tree13segment__size(n) {
  let size = 1;
  while (true) {
    if (size < n && size < 1073741824) {
      size = Math.imul(size, 2) | 0;
      continue;
    } else {
      break;
    }
  }
  return size;
}
function _M0MP312moonbitstack7moonstl4tree11SegmentTree3newGiE(length, op, identity) {
  const size = _M0FP312moonbitstack7moonstl4tree13segment__size(length < 1 ? 1 : length);
  const nodes = new _M0TPB5ArrayGiE([], 0);
  const _bind = Math.imul(2, size) | 0;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      _M0MPC15array5Array4pushGiE(nodes, identity);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0TP312moonbitstack7moonstl4tree11SegmentTreeGiE(op, identity, size, nodes);
}
function _M0MP312moonbitstack7moonstl4tree11SegmentTree11from__arrayGiE(values, op, identity) {
  const tree = _M0MP312moonbitstack7moonstl4tree11SegmentTree3newGiE(values.end - values.start | 0, op, identity);
  const _bind = values.end - values.start | 0;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      const _bind$2 = tree.nodes;
      const _bind$3 = tree.size + i | 0;
      if (i < 0 || i >= (values.end - values.start | 0)) {
        $panic();
      }
      const _bind$4 = values.buf[values.start + i | 0];
      if (_bind$3 < 0 || _bind$3 >= _bind$2.len) {
        $panic();
      }
      _bind$2.buf[_bind$3] = _bind$4;
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  let i = tree.size - 1 | 0;
  while (true) {
    if (i >= 1) {
      const _bind$2 = tree.nodes;
      const _bind$3 = i;
      const _func = tree.op;
      const _bind$4 = tree.nodes;
      const _bind$5 = Math.imul(2, i) | 0;
      if (_bind$5 < 0 || _bind$5 >= _bind$4.len) {
        $panic();
      }
      const _tmp$2 = _bind$4.buf[_bind$5];
      const _bind$6 = tree.nodes;
      const _bind$7 = (Math.imul(2, i) | 0) + 1 | 0;
      if (_bind$7 < 0 || _bind$7 >= _bind$6.len) {
        $panic();
      }
      const _bind$8 = _func(_tmp$2, _bind$6.buf[_bind$7]);
      if (_bind$3 < 0 || _bind$3 >= _bind$2.len) {
        $panic();
      }
      _bind$2.buf[_bind$3] = _bind$8;
      i = i - 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return tree;
}
function _M0MP312moonbitstack7moonstl4tree11SegmentTree5queryGiE(self, start, end) {
  const lo = start < 0 ? 0 : start;
  const hi = end > self.size ? self.size : end;
  if (lo >= hi) {
    return self.identity;
  }
  let left = lo + self.size | 0;
  let right = hi + self.size | 0;
  let acc_left = self.identity;
  let acc_right = self.identity;
  while (true) {
    if (left < right) {
      if ((left % 2 | 0) === 1) {
        const _func = self.op;
        const _tmp = acc_left;
        const _bind = self.nodes;
        const _bind$2 = left;
        if (_bind$2 < 0 || _bind$2 >= _bind.len) {
          $panic();
        }
        acc_left = _func(_tmp, _bind.buf[_bind$2]);
        left = left + 1 | 0;
      }
      if ((right % 2 | 0) === 1) {
        right = right - 1 | 0;
        const _func = self.op;
        const _bind = self.nodes;
        const _bind$2 = right;
        if (_bind$2 < 0 || _bind$2 >= _bind.len) {
          $panic();
        }
        acc_right = _func(_bind.buf[_bind$2], acc_right);
      }
      left = left / 2 | 0;
      right = right / 2 | 0;
      continue;
    } else {
      break;
    }
  }
  const _func = self.op;
  return _func(acc_left, acc_right);
}
function _M0MP312moonbitstack7moonstl4tree11SegmentTree10query__allGiE(self) {
  const _bind = self.nodes;
  if (1 >= _bind.len) {
    $panic();
  }
  return _bind.buf[1];
}
function _M0MP312moonbitstack7moonstl4tree11DisjointSet3new() {
  return new _M0TP312moonbitstack7moonstl4tree11DisjointSet(new _M0TPB5ArrayGiE([], 0), new _M0TPB5ArrayGiE([], 0), 0);
}
function _M0MP312moonbitstack7moonstl4tree11DisjointSet3add(self) {
  const index = self.parents.len;
  _M0MPC15array5Array4pushGiE(self.parents, index);
  _M0MPC15array5Array4pushGiE(self.sizes, 1);
  self.sets = self.sets + 1 | 0;
  return index;
}
function _M0MP312moonbitstack7moonstl4tree11DisjointSet4find(self, element) {
  if (element < 0 || element >= self.parents.len) {
    return -1;
  }
  let at = element;
  while (true) {
    const _bind = self.parents;
    const _bind$2 = at;
    if (_bind$2 < 0 || _bind$2 >= _bind.len) {
      $panic();
    }
    if (_bind.buf[_bind$2] !== at) {
      const _bind$3 = self.parents;
      const _bind$4 = self.parents;
      const _bind$5 = at;
      if (_bind$5 < 0 || _bind$5 >= _bind$4.len) {
        $panic();
      }
      const _bind$6 = _bind$4.buf[_bind$5];
      if (_bind$6 < 0 || _bind$6 >= _bind$3.len) {
        $panic();
      }
      const grandparent = _bind$3.buf[_bind$6];
      const _bind$7 = self.parents;
      const _bind$8 = at;
      if (_bind$8 < 0 || _bind$8 >= _bind$7.len) {
        $panic();
      }
      _bind$7.buf[_bind$8] = grandparent;
      at = grandparent;
      continue;
    } else {
      break;
    }
  }
  return at;
}
function _M0MP312moonbitstack7moonstl4tree11DisjointSet5union(self, a, b) {
  const root_a = _M0MP312moonbitstack7moonstl4tree11DisjointSet4find(self, a);
  const root_b = _M0MP312moonbitstack7moonstl4tree11DisjointSet4find(self, b);
  if (root_a < 0 || (root_b < 0 || root_a === root_b)) {
    return false;
  }
  let small;
  let big;
  _L: {
    const _bind = self.sizes;
    if (root_a < 0 || root_a >= _bind.len) {
      $panic();
    }
    const _tmp = _bind.buf[root_a];
    const _bind$2 = self.sizes;
    if (root_b < 0 || root_b >= _bind$2.len) {
      $panic();
    }
    if (_tmp < _bind$2.buf[root_b]) {
      small = root_a;
      big = root_b;
      break _L;
    } else {
      small = root_b;
      big = root_a;
      break _L;
    }
  }
  const _bind = self.parents;
  if (small < 0 || small >= _bind.len) {
    $panic();
  }
  _bind.buf[small] = big;
  const _bind$2 = self.sizes;
  const _bind$3 = self.sizes;
  if (big < 0 || big >= _bind$3.len) {
    $panic();
  }
  const _tmp = _bind$3.buf[big];
  const _bind$4 = self.sizes;
  if (small < 0 || small >= _bind$4.len) {
    $panic();
  }
  const _bind$5 = _tmp + _bind$4.buf[small] | 0;
  if (big < 0 || big >= _bind$2.len) {
    $panic();
  }
  _bind$2.buf[big] = _bind$5;
  self.sets = self.sets - 1 | 0;
  return true;
}
function _M0MP312moonbitstack7moonstl4tree11DisjointSet8to__sets(self) {
  const _bind = [];
  const by_root = _M0MPB3Map3MapGiiE(new _M0TPB9ArrayViewGUiiEE(_bind, 0, 0), undefined);
  const sets = new _M0TPB5ArrayGRPB5ArrayGiEE([], 0);
  const _bind$2 = self.parents.len;
  let _tmp = 0;
  while (true) {
    const element = _tmp;
    if (element < _bind$2) {
      const root = _M0MP312moonbitstack7moonstl4tree11DisjointSet4find(self, element);
      const _bind$3 = _M0MPB3Map3getGiiE(by_root, root);
      if (_bind$3 === undefined) {
        _M0MPB3Map3setGiiE(by_root, root, sets.len);
        _M0MPC15array5Array4pushGRP312moonbitstack7moonstl4text6OpcodeE(sets, new _M0TPB5ArrayGiE([element], 1));
      } else {
        const _Some = _bind$3;
        const _at = _Some;
        if (_at < 0 || _at >= sets.len) {
          $panic();
        }
        _M0MPC15array5Array4pushGiE(sets.buf[_at], element);
      }
      _tmp = element + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return sets;
}
function _M0FP223moonstl_2dsite_2dbridge4main7as__int(j) {
  if (j.$tag === 3) {
    const _Number = j;
    const _d = _Number._0;
    return _M0MPC16double6Double7to__int(_d);
  } else {
    return undefined;
  }
}
function _M0FP223moonstl_2dsite_2dbridge4main7as__str(j) {
  if (j.$tag === 4) {
    const _String = j;
    const _s = _String._0;
    return _s;
  } else {
    return undefined;
  }
}
function _M0FP223moonstl_2dsite_2dbridge4main8ints__of(j) {
  if (j.$tag === 5) {
    const _Array = j;
    const _a = _Array._0;
    const _p = new _M0TPB5ArrayGRPC14json4JsonE([], 0);
    const _p$2 = _a.len;
    const _p$3 = _a.buf;
    let _p$4;
    let _tmp = 0;
    while (true) {
      const _p$5 = _tmp;
      if (_p$5 < _p$2) {
        const _p$6 = _p$3[_p$5];
        if (_M0IP016_24default__implPB2Eq10not__equalGOiE(_M0FP223moonstl_2dsite_2dbridge4main7as__int(_p$6), undefined)) {
          _M0MPC15array5Array4pushGRP312moonbitstack7moonstl4text6OpcodeE(_p, _p$6);
        }
        _tmp = _p$5 + 1 | 0;
        continue;
      } else {
        _p$4 = _p;
        break;
      }
    }
    const _p$5 = _M0MPC15array5Array20unsafe__make__uninitGiE(_p$4.len);
    const _p$6 = _p$4.len;
    const _p$7 = _p$4.buf;
    let _tmp$2 = 0;
    while (true) {
      const _p$8 = _tmp$2;
      if (_p$8 < _p$6) {
        const _p$9 = _p$7[_p$8];
        const _p$10 = _M0MPC16option6Option10unwrap__orGiE(_M0FP223moonstl_2dsite_2dbridge4main7as__int(_p$9), 0);
        _p$5.buf[_p$8] = _p$10;
        _tmp$2 = _p$8 + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return _p$5;
  } else {
    return new _M0TPB5ArrayGiE([], 0);
  }
}
function _M0FP223moonstl_2dsite_2dbridge4main8strs__of(j) {
  if (j.$tag === 5) {
    const _Array = j;
    const _a = _Array._0;
    const _p = new _M0TPB5ArrayGRPC14json4JsonE([], 0);
    const _p$2 = _a.len;
    const _p$3 = _a.buf;
    let _p$4;
    let _tmp = 0;
    while (true) {
      const _p$5 = _tmp;
      if (_p$5 < _p$2) {
        const _p$6 = _p$3[_p$5];
        if (_M0IP016_24default__implPB2Eq10not__equalGOsE(_M0FP223moonstl_2dsite_2dbridge4main7as__str(_p$6), undefined)) {
          _M0MPC15array5Array4pushGRP312moonbitstack7moonstl4text6OpcodeE(_p, _p$6);
        }
        _tmp = _p$5 + 1 | 0;
        continue;
      } else {
        _p$4 = _p;
        break;
      }
    }
    const _p$5 = _M0MPC15array5Array20unsafe__make__uninitGRPC14json4JsonE(_p$4.len);
    const _p$6 = _p$4.len;
    const _p$7 = _p$4.buf;
    let _tmp$2 = 0;
    while (true) {
      const _p$8 = _tmp$2;
      if (_p$8 < _p$6) {
        const _p$9 = _p$7[_p$8];
        const _p$10 = _M0MPC16option6Option10unwrap__orGRPC14json4JsonE(_M0FP223moonstl_2dsite_2dbridge4main7as__str(_p$9), "");
        _p$5.buf[_p$8] = _p$10;
        _tmp$2 = _p$8 + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return _p$5;
  } else {
    return new _M0TPB5ArrayGsE([], 0);
  }
}
function _M0FP223moonstl_2dsite_2dbridge4main8get__str(j, key) {
  if (j.$tag === 6) {
    const _Object = j;
    const _m = _Object._0;
    return _M0MPC16option6Option10unwrap__orGRPC14json4JsonE(_M0FP223moonstl_2dsite_2dbridge4main7as__str(_M0MPC16option6Option10unwrap__orGRPC14json4JsonE(_M0MPB3Map3getGsRPC14json4JsonE(_m, key), _M0DTPC14json4Json4Null__)), "");
  } else {
    return "";
  }
}
function _M0FP223moonstl_2dsite_2dbridge4main8get__int(j, key) {
  if (j.$tag === 6) {
    const _Object = j;
    const _m = _Object._0;
    return _M0MPC16option6Option10unwrap__orGiE(_M0FP223moonstl_2dsite_2dbridge4main7as__int(_M0MPC16option6Option10unwrap__orGRPC14json4JsonE(_M0MPB3Map3getGsRPC14json4JsonE(_m, key), _M0DTPC14json4Json4Null__)), 0);
  } else {
    return 0;
  }
}
function _M0FP223moonstl_2dsite_2dbridge4main10get__field(j, key) {
  if (j.$tag === 6) {
    const _Object = j;
    const _m = _Object._0;
    return _M0MPC16option6Option10unwrap__orGRPC14json4JsonE(_M0MPB3Map3getGsRPC14json4JsonE(_m, key), _M0DTPC14json4Json4Null__);
  } else {
    return _M0DTPC14json4Json4Null__;
  }
}
function _M0FP223moonstl_2dsite_2dbridge4main17set__ints_2einner(j, key) {
  return _M0FP223moonstl_2dsite_2dbridge4main8ints__of(_M0FP223moonstl_2dsite_2dbridge4main10get__field(j, key));
}
function _M0FP223moonstl_2dsite_2dbridge4main17set__strs_2einner(j, key) {
  return _M0FP223moonstl_2dsite_2dbridge4main8strs__of(_M0FP223moonstl_2dsite_2dbridge4main10get__field(j, key));
}
function _M0FP223moonstl_2dsite_2dbridge4main5jints(a) {
  const _p = _M0MPC15array5Array20unsafe__make__uninitGRPC14json4JsonE(a.len);
  const _p$2 = a.len;
  const _p$3 = a.buf;
  let _tmp = 0;
  while (true) {
    const _p$4 = _tmp;
    if (_p$4 < _p$2) {
      const _p$5 = _p$3[_p$4];
      const _p$6 = _p$5 + 0;
      const _p$7 = undefined;
      const _p$8 = new _M0DTPC14json4Json6Number(_p$6, _p$7);
      _p.buf[_p$4] = _p$8;
      _tmp = _p$4 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _p$4 = _p;
  return new _M0DTPC14json4Json5Array(_p$4);
}
function _M0FP223moonstl_2dsite_2dbridge4main5jstrs(a) {
  const _p = _M0MPC15array5Array20unsafe__make__uninitGRPC14json4JsonE(a.len);
  const _p$2 = a.len;
  const _p$3 = a.buf;
  let _tmp = 0;
  while (true) {
    const _p$4 = _tmp;
    if (_p$4 < _p$2) {
      const _p$5 = _p$3[_p$4];
      const _p$6 = new _M0DTPC14json4Json6String(_p$5);
      _p.buf[_p$4] = _p$6;
      _tmp = _p$4 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _p$4 = _p;
  return new _M0DTPC14json4Json5Array(_p$4);
}
function _M0FP223moonstl_2dsite_2dbridge4main8indexmap(input) {
  const m = _M0MP312moonbitstack7moonstl3map8IndexMap3newGiiE(undefined, undefined);
  const _bind = _M0FP212moonbitstack8moonjson5loads(new _M0TPC16string10StringView(input, 0, input.length), _M0FP212moonbitstack8moonjson6strict);
  let _tmp;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    _tmp = _ok._0;
  } else {
    return _bind;
  }
  const _bind$2 = _M0FP223moonstl_2dsite_2dbridge4main17set__ints_2einner(_tmp, "set");
  const _bind$3 = _bind$2.len;
  const _bind$4 = _bind$2.buf;
  let _tmp$2 = 0;
  while (true) {
    const _ = _tmp$2;
    if (_ < _bind$3) {
      const e = _bind$4[_];
      _M0MP312moonbitstack7moonstl3map8IndexMap3setGiiE(m, e, Math.imul(e, 2) | 0);
      _tmp$2 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const ks = _M0MPB4Iter9to__arrayGiE(_M0MP312moonbitstack7moonstl3map8IndexMap4keysGiiE(m));
  const _bind$5 = [];
  const out = _M0MPB3Map3MapGsRPC14json4JsonE(new _M0TPB9ArrayViewGUsRPC14json4JsonEE(_bind$5, 0, 0), undefined);
  _M0MPB3Map3setGsRPC14json4JsonE(out, "keys", _M0FP223moonstl_2dsite_2dbridge4main5jints(ks));
  const _p = _M0MPC15array5Array20unsafe__make__uninitGiE(ks.len);
  const _p$2 = ks.len;
  const _p$3 = ks.buf;
  let _tmp$3 = 0;
  while (true) {
    const _p$4 = _tmp$3;
    if (_p$4 < _p$2) {
      const _p$5 = _p$3[_p$4];
      const _p$6 = _M0MPC16option6Option10unwrap__orGiE(_M0MP312moonbitstack7moonstl3map8IndexMap14get__index__ofGiiE(m, _p$5), -1);
      _p.buf[_p$4] = _p$6;
      _tmp$3 = _p$4 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0MPB3Map3setGsRPC14json4JsonE(out, "positions", _M0FP223moonstl_2dsite_2dbridge4main5jints(_p));
  return new _M0DTPC16result6ResultGsRPC15error5ErrorE2Ok(_M0FP212moonbitstack8moonjson13dumps_2einner(new _M0DTPC14json4Json6Object(out), 0, false, false));
}
function _M0FP223moonstl_2dsite_2dbridge4main4trie(input) {
  const _bind = _M0FP212moonbitstack8moonjson5loads(new _M0TPC16string10StringView(input, 0, input.length), _M0FP212moonbitstack8moonjson6strict);
  let j;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    j = _ok._0;
  } else {
    return _bind;
  }
  const t = _M0MP312moonbitstack7moonstl3map4Trie3newGiE();
  const _bind$2 = _M0FP223moonstl_2dsite_2dbridge4main17set__strs_2einner(j, "words");
  const _bind$3 = _bind$2.len;
  const _bind$4 = _bind$2.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$3) {
      const w = _bind$4[_];
      _M0MP312moonbitstack7moonstl3map4Trie6insertGiE(t, new _M0TPC16string10StringView(w, 0, w.length), 1);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const prefix = _M0FP223moonstl_2dsite_2dbridge4main8get__str(j, "prefix");
  const _bind$5 = [];
  const out = _M0MPB3Map3MapGsRPC14json4JsonE(new _M0TPB9ArrayViewGUsRPC14json4JsonEE(_bind$5, 0, 0), undefined);
  const _p = _M0MP312moonbitstack7moonstl3map4Trie9to__arrayGiE(t);
  const _p$2 = _M0MPC15array5Array20unsafe__make__uninitGRPC14json4JsonE(_p.len);
  const _p$3 = _p.len;
  const _p$4 = _p.buf;
  let _tmp$2 = 0;
  while (true) {
    const _p$5 = _tmp$2;
    if (_p$5 < _p$3) {
      const _p$6 = _p$4[_p$5];
      const _p$7 = _p$6._0;
      _p$2.buf[_p$5] = _p$7;
      _tmp$2 = _p$5 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0MPB3Map3setGsRPC14json4JsonE(out, "words", _M0FP223moonstl_2dsite_2dbridge4main5jstrs(_p$2));
  _M0MPB3Map3setGsRPC14json4JsonE(out, "prefix", new _M0DTPC14json4Json6String(prefix));
  _M0MPB3Map3setGsRPC14json4JsonE(out, "matches", _M0FP223moonstl_2dsite_2dbridge4main5jstrs(_M0MP312moonbitstack7moonstl3map4Trie18keys__with__prefixGiE(t, new _M0TPC16string10StringView(prefix, 0, prefix.length))));
  return new _M0DTPC16result6ResultGsRPC15error5ErrorE2Ok(_M0FP212moonbitstack8moonjson13dumps_2einner(new _M0DTPC14json4Json6Object(out), 0, false, false));
}
function _M0FP223moonstl_2dsite_2dbridge4main3lru(input) {
  const _bind = _M0FP212moonbitstack8moonjson5loads(new _M0TPC16string10StringView(input, 0, input.length), _M0FP212moonbitstack8moonjson6strict);
  let j;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    j = _ok._0;
  } else {
    return _bind;
  }
  const cap = _M0FP223moonstl_2dsite_2dbridge4main8get__int(j, "cap");
  const _bind$2 = _M0MP312moonbitstack7moonstl5cache8LruCache3newGiiE(cap, undefined, undefined);
  let c;
  if (_bind$2.$tag === 1) {
    const _ok = _bind$2;
    c = _ok._0;
  } else {
    return _bind$2;
  }
  const displaced = new _M0TPB5ArrayGiE([], 0);
  const _bind$3 = _M0FP223moonstl_2dsite_2dbridge4main17set__ints_2einner(j, "set");
  const _bind$4 = _bind$3.len;
  const _bind$5 = _bind$3.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$4) {
      const e = _bind$5[_];
      const _bind$6 = _M0MP312moonbitstack7moonstl5cache8LruCache3setGiiE(c, e, e);
      if (_bind$6 === undefined) {
      } else {
        const _Some = _bind$6;
        const _x = _Some;
        const _k = _x._0;
        _M0MPC15array5Array4pushGiE(displaced, _k);
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _bind$6 = [];
  const out = _M0MPB3Map3MapGsRPC14json4JsonE(new _M0TPB9ArrayViewGUsRPC14json4JsonEE(_bind$6, 0, 0), undefined);
  const _p = cap + 0;
  const _p$2 = undefined;
  _M0MPB3Map3setGsRPC14json4JsonE(out, "capacity", new _M0DTPC14json4Json6Number(_p, _p$2));
  _M0MPB3Map3setGsRPC14json4JsonE(out, "displaced", _M0FP223moonstl_2dsite_2dbridge4main5jints(displaced));
  _M0MPB3Map3setGsRPC14json4JsonE(out, "keys", _M0FP223moonstl_2dsite_2dbridge4main5jints(_M0MPB4Iter9to__arrayGiE(_M0MP312moonbitstack7moonstl5cache8LruCache4keysGiiE(c))));
  return new _M0DTPC16result6ResultGsRPC15error5ErrorE2Ok(_M0FP212moonbitstack8moonjson13dumps_2einner(new _M0DTPC14json4Json6Object(out), 0, false, false));
}
function _M0FP223moonstl_2dsite_2dbridge4main4heap(input) {
  const h = _M0IP312moonbitstack7moonstl4heap8DaryHeapPB7Default7defaultGiE();
  const _bind = _M0FP212moonbitstack8moonjson5loads(new _M0TPC16string10StringView(input, 0, input.length), _M0FP212moonbitstack8moonjson6strict);
  let _tmp;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    _tmp = _ok._0;
  } else {
    return _bind;
  }
  const _bind$2 = _M0FP223moonstl_2dsite_2dbridge4main17set__ints_2einner(_tmp, "set");
  const _bind$3 = _bind$2.len;
  const _bind$4 = _bind$2.buf;
  let _tmp$2 = 0;
  while (true) {
    const _ = _tmp$2;
    if (_ < _bind$3) {
      const v = _bind$4[_];
      _M0MP312moonbitstack7moonstl4heap8DaryHeap4pushGiE(h, v);
      _tmp$2 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const pops = new _M0TPB5ArrayGiE([], 0);
  const _bind$5 = h.items.len;
  let _tmp$3 = 0;
  while (true) {
    const _ = _tmp$3;
    if (_ < _bind$5) {
      const _bind$6 = _M0MP312moonbitstack7moonstl4heap8DaryHeap3popGiE(h);
      if (_bind$6 === undefined) {
      } else {
        const _Some = _bind$6;
        const _v = _Some;
        _M0MPC15array5Array4pushGiE(pops, _v);
      }
      _tmp$3 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _bind$6 = [];
  const out = _M0MPB3Map3MapGsRPC14json4JsonE(new _M0TPB9ArrayViewGUsRPC14json4JsonEE(_bind$6, 0, 0), undefined);
  _M0MPB3Map3setGsRPC14json4JsonE(out, "pops", _M0FP223moonstl_2dsite_2dbridge4main5jints(pops));
  return new _M0DTPC16result6ResultGsRPC15error5ErrorE2Ok(_M0FP212moonbitstack8moonjson13dumps_2einner(new _M0DTPC14json4Json6Object(out), 0, false, false));
}
function _M0FP223moonstl_2dsite_2dbridge4main7segment(input) {
  const _bind = _M0FP212moonbitstack8moonjson5loads(new _M0TPC16string10StringView(input, 0, input.length), _M0FP212moonbitstack8moonjson6strict);
  let j;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    j = _ok._0;
  } else {
    return _bind;
  }
  const vals = _M0FP223moonstl_2dsite_2dbridge4main17set__ints_2einner(j, "set");
  const st = _M0MP312moonbitstack7moonstl4tree11SegmentTree11from__arrayGiE(new _M0TPB9ArrayViewGiE(vals.buf, 0, vals.len), (x, y) => x + y | 0, 0);
  const _bind$2 = [];
  const out = _M0MPB3Map3MapGsRPC14json4JsonE(new _M0TPB9ArrayViewGUsRPC14json4JsonEE(_bind$2, 0, 0), undefined);
  _M0MPB3Map3setGsRPC14json4JsonE(out, "values", _M0FP223moonstl_2dsite_2dbridge4main5jints(vals));
  const _p = _M0MP312moonbitstack7moonstl4tree11SegmentTree10query__allGiE(st) + 0;
  const _p$2 = undefined;
  _M0MPB3Map3setGsRPC14json4JsonE(out, "total", new _M0DTPC14json4Json6Number(_p, _p$2));
  const prefix = new _M0TPB5ArrayGiE([], 0);
  const _bind$3 = vals.len;
  let _tmp = 0;
  let _tmp$2 = 0 <= _bind$3;
  while (true) {
    const i = _tmp;
    const _more = _tmp$2;
    if (_more) {
      _M0MPC15array5Array4pushGiE(prefix, _M0MP312moonbitstack7moonstl4tree11SegmentTree5queryGiE(st, 0, i));
      _tmp = i + 1 | 0;
      _tmp$2 = i < _bind$3;
      continue;
    } else {
      break;
    }
  }
  _M0MPB3Map3setGsRPC14json4JsonE(out, "prefix", _M0FP223moonstl_2dsite_2dbridge4main5jints(prefix));
  return new _M0DTPC16result6ResultGsRPC15error5ErrorE2Ok(_M0FP212moonbitstack8moonjson13dumps_2einner(new _M0DTPC14json4Json6Object(out), 0, false, false));
}
function _M0FP223moonstl_2dsite_2dbridge4main8disjoint(input) {
  const _bind = _M0FP212moonbitstack8moonjson5loads(new _M0TPC16string10StringView(input, 0, input.length), _M0FP212moonbitstack8moonjson6strict);
  let j;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    j = _ok._0;
  } else {
    return _bind;
  }
  const n = _M0FP223moonstl_2dsite_2dbridge4main8get__int(j, "n");
  const d = _M0MP312moonbitstack7moonstl4tree11DisjointSet3new();
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < n) {
      _M0MP312moonbitstack7moonstl4tree11DisjointSet3add(d);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const unions = _M0FP223moonstl_2dsite_2dbridge4main17set__ints_2einner(j, "set");
  const pairs = unions.len / 2 | 0;
  let _tmp$2 = 0;
  while (true) {
    const i = _tmp$2;
    if (i < pairs) {
      const _bind$2 = Math.imul(2, i) | 0;
      if (_bind$2 < 0 || _bind$2 >= unions.len) {
        $panic();
      }
      const _tmp$3 = unions.buf[_bind$2];
      const _bind$3 = (Math.imul(2, i) | 0) + 1 | 0;
      if (_bind$3 < 0 || _bind$3 >= unions.len) {
        $panic();
      }
      _M0MP312moonbitstack7moonstl4tree11DisjointSet5union(d, _tmp$3, unions.buf[_bind$3]);
      _tmp$2 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _bind$2 = [];
  const out = _M0MPB3Map3MapGsRPC14json4JsonE(new _M0TPB9ArrayViewGUsRPC14json4JsonEE(_bind$2, 0, 0), undefined);
  const _p = _M0MP312moonbitstack7moonstl4tree11DisjointSet8to__sets(d);
  const _p$2 = _M0MPC15array5Array20unsafe__make__uninitGRPC14json4JsonE(_p.len);
  const _p$3 = _p.len;
  const _p$4 = _p.buf;
  let _tmp$3 = 0;
  while (true) {
    const _p$5 = _tmp$3;
    if (_p$5 < _p$3) {
      const _p$6 = _p$4[_p$5];
      const _p$7 = _M0FP223moonstl_2dsite_2dbridge4main5jints(_p$6);
      _p$2.buf[_p$5] = _p$7;
      _tmp$3 = _p$5 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _p$5 = _p$2;
  _M0MPB3Map3setGsRPC14json4JsonE(out, "sets", new _M0DTPC14json4Json5Array(_p$5));
  const _p$6 = d.sets + 0;
  const _p$7 = undefined;
  _M0MPB3Map3setGsRPC14json4JsonE(out, "count", new _M0DTPC14json4Json6Number(_p$6, _p$7));
  return new _M0DTPC16result6ResultGsRPC15error5ErrorE2Ok(_M0FP212moonbitstack8moonjson13dumps_2einner(new _M0DTPC14json4Json6Object(out), 0, false, false));
}
function _M0FP223moonstl_2dsite_2dbridge4main5bloom(input) {
  const _bind = _M0FP212moonbitstack8moonjson5loads(new _M0TPC16string10StringView(input, 0, input.length), _M0FP212moonbitstack8moonjson6strict);
  let j;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    j = _ok._0;
  } else {
    return _bind;
  }
  const cap = _M0FP223moonstl_2dsite_2dbridge4main8get__int(j, "cap");
  const _bind$2 = _M0MP312moonbitstack7moonstl6sketch11BloomFilter3newGiE(cap, undefined, _M0FP223moonstl_2dsite_2dbridge4main5bloomN6constrS4442);
  let b;
  if (_bind$2.$tag === 1) {
    const _ok = _bind$2;
    b = _ok._0;
  } else {
    return _bind$2;
  }
  const _bind$3 = _M0FP223moonstl_2dsite_2dbridge4main17set__ints_2einner(j, "set");
  const _bind$4 = _bind$3.len;
  const _bind$5 = _bind$3.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$4) {
      const v = _bind$5[_];
      _M0MP312moonbitstack7moonstl6sketch11BloomFilter6insertGiE(b, v);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const query = _M0FP223moonstl_2dsite_2dbridge4main8get__int(j, "n");
  const _bind$6 = [];
  const out = _M0MPB3Map3MapGsRPC14json4JsonE(new _M0TPB9ArrayViewGUsRPC14json4JsonEE(_bind$6, 0, 0), undefined);
  const _p = _M0MP312moonbitstack7moonstl6sketch11BloomFilter12may__containGiE(b, query);
  _M0MPB3Map3setGsRPC14json4JsonE(out, "found", _p ? _M0DTPC14json4Json4True__ : _M0DTPC14json4Json5False__);
  const _p$2 = _M0MP312moonbitstack7moonstl6sketch11BloomFilter32estimated__false__positive__rateGiE(b);
  const _p$3 = undefined;
  _M0MPB3Map3setGsRPC14json4JsonE(out, "false_pos", new _M0DTPC14json4Json6Number(_p$2, _p$3));
  return new _M0DTPC16result6ResultGsRPC15error5ErrorE2Ok(_M0FP212moonbitstack8moonjson13dumps_2einner(new _M0DTPC14json4Json6Object(out), 0, false, false));
}
function _M0FP223moonstl_2dsite_2dbridge4main8countmin(input) {
  const _bind = _M0FP212moonbitstack8moonjson5loads(new _M0TPC16string10StringView(input, 0, input.length), _M0FP212moonbitstack8moonjson6strict);
  let j;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    j = _ok._0;
  } else {
    return _bind;
  }
  const _bind$2 = _M0MP312moonbitstack7moonstl6sketch14CountMinSketch11new_2einnerGiE(0.01, 0.99, 0);
  let s;
  if (_bind$2.$tag === 1) {
    const _ok = _bind$2;
    s = _ok._0;
  } else {
    return _bind$2;
  }
  const _bind$3 = _M0FP223moonstl_2dsite_2dbridge4main17set__ints_2einner(j, "set");
  const _bind$4 = _bind$3.len;
  const _bind$5 = _bind$3.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$4) {
      const v = _bind$5[_];
      _M0MP312moonbitstack7moonstl6sketch14CountMinSketch6insertGiE(s, v);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const q = _M0FP223moonstl_2dsite_2dbridge4main8get__int(j, "q");
  const _bind$6 = [];
  const out = _M0MPB3Map3MapGsRPC14json4JsonE(new _M0TPB9ArrayViewGUsRPC14json4JsonEE(_bind$6, 0, 0), undefined);
  const _p = _M0MP312moonbitstack7moonstl6sketch14CountMinSketch8estimateGiE(s, q) + 0;
  const _p$2 = undefined;
  _M0MPB3Map3setGsRPC14json4JsonE(out, "estimate", new _M0DTPC14json4Json6Number(_p, _p$2));
  return new _M0DTPC16result6ResultGsRPC15error5ErrorE2Ok(_M0FP212moonbitstack8moonjson13dumps_2einner(new _M0DTPC14json4Json6Object(out), 0, false, false));
}
function _M0FP223moonstl_2dsite_2dbridge4main3kmp(input) {
  const _bind = _M0FP212moonbitstack8moonjson5loads(new _M0TPC16string10StringView(input, 0, input.length), _M0FP212moonbitstack8moonjson6strict);
  let j;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    j = _ok._0;
  } else {
    return _bind;
  }
  const _bind$2 = _M0FP223moonstl_2dsite_2dbridge4main8get__str(j, "pattern");
  const k = _M0MP312moonbitstack7moonstl4text3Kmp3new(new _M0TPC16string10StringView(_bind$2, 0, _bind$2.length));
  const _bind$3 = [];
  const out = _M0MPB3Map3MapGsRPC14json4JsonE(new _M0TPB9ArrayViewGUsRPC14json4JsonEE(_bind$3, 0, 0), undefined);
  const _p = _M0FP223moonstl_2dsite_2dbridge4main8get__str(j, "text");
  _M0MPB3Map3setGsRPC14json4JsonE(out, "text", new _M0DTPC14json4Json6String(_p));
  const _p$2 = _M0FP223moonstl_2dsite_2dbridge4main8get__str(j, "pattern");
  _M0MPB3Map3setGsRPC14json4JsonE(out, "pattern", new _M0DTPC14json4Json6String(_p$2));
  const _bind$4 = _M0FP223moonstl_2dsite_2dbridge4main8get__str(j, "text");
  _M0MPB3Map3setGsRPC14json4JsonE(out, "hits", _M0FP223moonstl_2dsite_2dbridge4main5jints(_M0MPB4Iter9to__arrayGiE(_M0MP312moonbitstack7moonstl4text3Kmp11search__all(k, new _M0TPC16string10StringView(_bind$4, 0, _bind$4.length)))));
  return new _M0DTPC16result6ResultGsRPC15error5ErrorE2Ok(_M0FP212moonbitstack8moonjson13dumps_2einner(new _M0DTPC14json4Json6Object(out), 0, false, false));
}
function _M0FP223moonstl_2dsite_2dbridge4main4diff(input) {
  const _bind = _M0FP212moonbitstack8moonjson5loads(new _M0TPC16string10StringView(input, 0, input.length), _M0FP212moonbitstack8moonjson6strict);
  let j;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    j = _ok._0;
  } else {
    return _bind;
  }
  const _bind$2 = _M0MPB4Iter9to__arrayGcE(_M0MPC16string6String4iter(_M0FP223moonstl_2dsite_2dbridge4main8get__str(j, "a")));
  const _tmp = new _M0TPB9ArrayViewGcE(_bind$2.buf, 0, _bind$2.len);
  const _bind$3 = _M0MPB4Iter9to__arrayGcE(_M0MPC16string6String4iter(_M0FP223moonstl_2dsite_2dbridge4main8get__str(j, "b")));
  const m = _M0MP312moonbitstack7moonstl4text15SequenceMatcher3newGcE(_tmp, new _M0TPB9ArrayViewGcE(_bind$3.buf, 0, _bind$3.len), undefined);
  const ops = _M0MP312moonbitstack7moonstl4text15SequenceMatcher12get__opcodesGcE(m);
  const _bind$4 = [];
  const out = _M0MPB3Map3MapGsRPC14json4JsonE(new _M0TPB9ArrayViewGUsRPC14json4JsonEE(_bind$4, 0, 0), undefined);
  const _p = _M0FP223moonstl_2dsite_2dbridge4main8get__str(j, "a");
  _M0MPB3Map3setGsRPC14json4JsonE(out, "a", new _M0DTPC14json4Json6String(_p));
  const _p$2 = _M0FP223moonstl_2dsite_2dbridge4main8get__str(j, "b");
  _M0MPB3Map3setGsRPC14json4JsonE(out, "b", new _M0DTPC14json4Json6String(_p$2));
  const _p$3 = _M0MP312moonbitstack7moonstl4text15SequenceMatcher5ratioGcE(m);
  const _p$4 = undefined;
  _M0MPB3Map3setGsRPC14json4JsonE(out, "ratio", new _M0DTPC14json4Json6Number(_p$3, _p$4));
  const _p$5 = _M0MPC15array5Array20unsafe__make__uninitGRPC14json4JsonE(ops.len);
  const _p$6 = ops.len;
  const _p$7 = ops.buf;
  let _tmp$2 = 0;
  while (true) {
    const _p$8 = _tmp$2;
    if (_p$8 < _p$6) {
      const _p$9 = _p$7[_p$8];
      const _p$10 = _M0MP312moonbitstack7moonstl4text6Opcode3tag(_p$9);
      const _tmp$3 = new _M0DTPC14json4Json6String(_p$10);
      const _p$11 = _M0MP312moonbitstack7moonstl4text6Opcode2a1(_p$9) + 0;
      const _p$12 = undefined;
      const _tmp$4 = new _M0DTPC14json4Json6Number(_p$11, _p$12);
      const _p$13 = _M0MP312moonbitstack7moonstl4text6Opcode2a2(_p$9) + 0;
      const _p$14 = undefined;
      const _tmp$5 = new _M0DTPC14json4Json6Number(_p$13, _p$14);
      const _p$15 = _M0MP312moonbitstack7moonstl4text6Opcode2b1(_p$9) + 0;
      const _p$16 = undefined;
      const _tmp$6 = new _M0DTPC14json4Json6Number(_p$15, _p$16);
      const _p$17 = _M0MP312moonbitstack7moonstl4text6Opcode2b2(_p$9) + 0;
      const _p$18 = undefined;
      const _p$19 = new _M0TPB5ArrayGRPC14json4JsonE([_tmp$3, _tmp$4, _tmp$5, _tmp$6, new _M0DTPC14json4Json6Number(_p$17, _p$18)], 5);
      const _p$20 = new _M0DTPC14json4Json5Array(_p$19);
      _p$5.buf[_p$8] = _p$20;
      _tmp$2 = _p$8 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _p$8 = _p$5;
  _M0MPB3Map3setGsRPC14json4JsonE(out, "ops", new _M0DTPC14json4Json5Array(_p$8));
  return new _M0DTPC16result6ResultGsRPC15error5ErrorE2Ok(_M0FP212moonbitstack8moonjson13dumps_2einner(new _M0DTPC14json4Json6Object(out), 0, false, false));
}
function _M0FP223moonstl_2dsite_2dbridge4main3phf(input) {
  const _bind = _M0FP212moonbitstack8moonjson5loads(new _M0TPC16string10StringView(input, 0, input.length), _M0FP212moonbitstack8moonjson6strict);
  let j;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    j = _ok._0;
  } else {
    return _bind;
  }
  const builder = _M0MP312moonbitstack7moonstl3phf10PhfBuilder3newGsiE(undefined);
  const _bind$2 = _M0FP223moonstl_2dsite_2dbridge4main17set__strs_2einner(j, "set");
  const _bind$3 = _bind$2.len;
  const _bind$4 = _bind$2.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$3) {
      const e = _bind$4[_];
      const _bind$5 = _M0MP312moonbitstack7moonstl3phf10PhfBuilder5entryGsiE(builder, e, e.length);
      if (_bind$5.$tag === 1) {
        const _ok = _bind$5;
        _ok._0;
      } else {
        return _bind$5;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _bind$5 = _M0MP312moonbitstack7moonstl3phf10PhfBuilder5buildGsiE(builder);
  let map;
  if (_bind$5.$tag === 1) {
    const _ok = _bind$5;
    map = _ok._0;
  } else {
    return _bind$5;
  }
  const _bind$6 = [];
  const out = _M0MPB3Map3MapGsRPC14json4JsonE(new _M0TPB9ArrayViewGUsRPC14json4JsonEE(_bind$6, 0, 0), undefined);
  const _p = map.keys.len + 0;
  const _p$2 = undefined;
  _M0MPB3Map3setGsRPC14json4JsonE(out, "size", new _M0DTPC14json4Json6Number(_p, _p$2));
  _M0MPB3Map3setGsRPC14json4JsonE(out, "keys", _M0FP223moonstl_2dsite_2dbridge4main5jstrs(_M0MPB4Iter9to__arrayGRPC14json4JsonE(_M0MP312moonbitstack7moonstl3phf6PhfMap4keysGsiE(map))));
  return new _M0DTPC16result6ResultGsRPC15error5ErrorE2Ok(_M0FP212moonbitstack8moonjson13dumps_2einner(new _M0DTPC14json4Json6Object(out), 0, false, false));
}
function _M0FP223moonstl_2dsite_2dbridge4main4ring(input) {
  const _bind = _M0FP212moonbitstack8moonjson5loads(new _M0TPC16string10StringView(input, 0, input.length), _M0FP212moonbitstack8moonjson6strict);
  let j;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    j = _ok._0;
  } else {
    return _bind;
  }
  const cap = _M0FP223moonstl_2dsite_2dbridge4main8get__int(j, "cap");
  const _bind$2 = _M0MP312moonbitstack7moonstl3seq10RingBuffer11new_2einnerGiE(cap, 0);
  let r;
  if (_bind$2.$tag === 1) {
    const _ok = _bind$2;
    r = _ok._0;
  } else {
    return _bind$2;
  }
  const _bind$3 = _M0FP223moonstl_2dsite_2dbridge4main17set__ints_2einner(j, "set");
  const _bind$4 = _bind$3.len;
  const _bind$5 = _bind$3.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$4) {
      const v = _bind$5[_];
      _M0MP312moonbitstack7moonstl3seq10RingBuffer10push__backGiE(r, v);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _bind$6 = [];
  const out = _M0MPB3Map3MapGsRPC14json4JsonE(new _M0TPB9ArrayViewGUsRPC14json4JsonEE(_bind$6, 0, 0), undefined);
  const _p = cap + 0;
  const _p$2 = undefined;
  _M0MPB3Map3setGsRPC14json4JsonE(out, "capacity", new _M0DTPC14json4Json6Number(_p, _p$2));
  _M0MPB3Map3setGsRPC14json4JsonE(out, "values", _M0FP223moonstl_2dsite_2dbridge4main5jints(_M0MP312moonbitstack7moonstl3seq10RingBuffer9to__arrayGiE(r)));
  return new _M0DTPC16result6ResultGsRPC15error5ErrorE2Ok(_M0FP212moonbitstack8moonjson13dumps_2einner(new _M0DTPC14json4Json6Object(out), 0, false, false));
}
function _M0FP223moonstl_2dsite_2dbridge4main6bitset(input) {
  const _bind = _M0FP212moonbitstack8moonjson5loads(new _M0TPC16string10StringView(input, 0, input.length), _M0FP212moonbitstack8moonjson6strict);
  let j;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    j = _ok._0;
  } else {
    return _bind;
  }
  const b = _M0MP312moonbitstack7moonstl3seq6BitSet11new_2einner(0);
  const _bind$2 = _M0FP223moonstl_2dsite_2dbridge4main17set__ints_2einner(j, "set");
  const _bind$3 = _bind$2.len;
  const _bind$4 = _bind$2.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$3) {
      const v = _bind$4[_];
      _M0MP312moonbitstack7moonstl3seq6BitSet6insert(b, v);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const n = _M0FP223moonstl_2dsite_2dbridge4main8get__int(j, "n");
  const rank = new _M0TPB5ArrayGiE([], 0);
  let _tmp$2 = 0;
  while (true) {
    const i = _tmp$2;
    if (i < n) {
      _M0MPC15array5Array4pushGiE(rank, _M0MP312moonbitstack7moonstl3seq6BitSet4rank(b, i));
      _tmp$2 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _bind$5 = [];
  const out = _M0MPB3Map3MapGsRPC14json4JsonE(new _M0TPB9ArrayViewGUsRPC14json4JsonEE(_bind$5, 0, 0), undefined);
  _M0MPB3Map3setGsRPC14json4JsonE(out, "bits", _M0FP223moonstl_2dsite_2dbridge4main5jints(_M0MP312moonbitstack7moonstl3seq6BitSet9to__array(b)));
  _M0MPB3Map3setGsRPC14json4JsonE(out, "rank", _M0FP223moonstl_2dsite_2dbridge4main5jints(rank));
  const _p = _M0MPC16option6Option10unwrap__orGiE(_M0MP312moonbitstack7moonstl3seq6BitSet6select(b, 0), -1) + 0;
  const _p$2 = undefined;
  _M0MPB3Map3setGsRPC14json4JsonE(out, "select0", new _M0DTPC14json4Json6Number(_p, _p$2));
  return new _M0DTPC16result6ResultGsRPC15error5ErrorE2Ok(_M0FP212moonbitstack8moonjson13dumps_2einner(new _M0DTPC14json4Json6Object(out), 0, false, false));
}
function _M0FP223moonstl_2dsite_2dbridge4main5perms(input) {
  const _bind = _M0FP212moonbitstack8moonjson5loads(new _M0TPC16string10StringView(input, 0, input.length), _M0FP212moonbitstack8moonjson6strict);
  let j;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    j = _ok._0;
  } else {
    return _bind;
  }
  const pool = _M0FP223moonstl_2dsite_2dbridge4main17set__ints_2einner(j, "set");
  const r = _M0FP223moonstl_2dsite_2dbridge4main8get__int(j, "r");
  const _bind$2 = [];
  const out = _M0MPB3Map3MapGsRPC14json4JsonE(new _M0TPB9ArrayViewGUsRPC14json4JsonEE(_bind$2, 0, 0), undefined);
  let kind;
  let rows;
  _L: {
    if (r === 0) {
      const p = _M0MP312moonbitstack7moonstl4algo12Permutations3newGiE(new _M0TPB9ArrayViewGiE(pool.buf, 0, pool.len), undefined);
      kind = "permutations";
      rows = _M0MPB4Iter9to__arrayGRPC14json4JsonE(_M0MPB4Iter3mapGRPB5ArrayGiERPC14json4JsonE(_M0MP312moonbitstack7moonstl4algo12Permutations4iterGiE(p), (row) => _M0FP223moonstl_2dsite_2dbridge4main5jints(row)));
      break _L;
    } else {
      const c = _M0MP312moonbitstack7moonstl4algo12Combinations3newGiE(new _M0TPB9ArrayViewGiE(pool.buf, 0, pool.len), r);
      kind = "combinations";
      rows = _M0MPB4Iter9to__arrayGRPC14json4JsonE(_M0MPB4Iter3mapGRPB5ArrayGiERPC14json4JsonE(_M0MP312moonbitstack7moonstl4algo12Combinations4iterGiE(c), (row) => _M0FP223moonstl_2dsite_2dbridge4main5jints(row)));
      break _L;
    }
  }
  _M0MPB3Map3setGsRPC14json4JsonE(out, "kind", new _M0DTPC14json4Json6String(kind));
  _M0MPB3Map3setGsRPC14json4JsonE(out, "rows", new _M0DTPC14json4Json5Array(rows));
  return new _M0DTPC16result6ResultGsRPC15error5ErrorE2Ok(_M0FP212moonbitstack8moonjson13dumps_2einner(new _M0DTPC14json4Json6Object(out), 0, false, false));
}
function _M0FP223moonstl_2dsite_2dbridge4main3run(name, input) {
  let _try_err;
  _L: {
    switch (name) {
      case "indexmap": {
        const _bind = _M0FP223moonstl_2dsite_2dbridge4main8indexmap(input);
        if (_bind.$tag === 1) {
          const _ok = _bind;
          return _ok._0;
        } else {
          const _err = _bind;
          _try_err = _err._0;
          break _L;
        }
      }
      case "trie": {
        const _bind$2 = _M0FP223moonstl_2dsite_2dbridge4main4trie(input);
        if (_bind$2.$tag === 1) {
          const _ok = _bind$2;
          return _ok._0;
        } else {
          const _err = _bind$2;
          _try_err = _err._0;
          break _L;
        }
      }
      case "lru": {
        const _bind$3 = _M0FP223moonstl_2dsite_2dbridge4main3lru(input);
        if (_bind$3.$tag === 1) {
          const _ok = _bind$3;
          return _ok._0;
        } else {
          const _err = _bind$3;
          _try_err = _err._0;
          break _L;
        }
      }
      case "heap": {
        const _bind$4 = _M0FP223moonstl_2dsite_2dbridge4main4heap(input);
        if (_bind$4.$tag === 1) {
          const _ok = _bind$4;
          return _ok._0;
        } else {
          const _err = _bind$4;
          _try_err = _err._0;
          break _L;
        }
      }
      case "segment": {
        const _bind$5 = _M0FP223moonstl_2dsite_2dbridge4main7segment(input);
        if (_bind$5.$tag === 1) {
          const _ok = _bind$5;
          return _ok._0;
        } else {
          const _err = _bind$5;
          _try_err = _err._0;
          break _L;
        }
      }
      case "disjoint": {
        const _bind$6 = _M0FP223moonstl_2dsite_2dbridge4main8disjoint(input);
        if (_bind$6.$tag === 1) {
          const _ok = _bind$6;
          return _ok._0;
        } else {
          const _err = _bind$6;
          _try_err = _err._0;
          break _L;
        }
      }
      case "bloom": {
        const _bind$7 = _M0FP223moonstl_2dsite_2dbridge4main5bloom(input);
        if (_bind$7.$tag === 1) {
          const _ok = _bind$7;
          return _ok._0;
        } else {
          const _err = _bind$7;
          _try_err = _err._0;
          break _L;
        }
      }
      case "countmin": {
        const _bind$8 = _M0FP223moonstl_2dsite_2dbridge4main8countmin(input);
        if (_bind$8.$tag === 1) {
          const _ok = _bind$8;
          return _ok._0;
        } else {
          const _err = _bind$8;
          _try_err = _err._0;
          break _L;
        }
      }
      case "kmp": {
        const _bind$9 = _M0FP223moonstl_2dsite_2dbridge4main3kmp(input);
        if (_bind$9.$tag === 1) {
          const _ok = _bind$9;
          return _ok._0;
        } else {
          const _err = _bind$9;
          _try_err = _err._0;
          break _L;
        }
      }
      case "diff": {
        const _bind$10 = _M0FP223moonstl_2dsite_2dbridge4main4diff(input);
        if (_bind$10.$tag === 1) {
          const _ok = _bind$10;
          return _ok._0;
        } else {
          const _err = _bind$10;
          _try_err = _err._0;
          break _L;
        }
      }
      case "phf": {
        const _bind$11 = _M0FP223moonstl_2dsite_2dbridge4main3phf(input);
        if (_bind$11.$tag === 1) {
          const _ok = _bind$11;
          return _ok._0;
        } else {
          const _err = _bind$11;
          _try_err = _err._0;
          break _L;
        }
      }
      case "ring": {
        const _bind$12 = _M0FP223moonstl_2dsite_2dbridge4main4ring(input);
        if (_bind$12.$tag === 1) {
          const _ok = _bind$12;
          return _ok._0;
        } else {
          const _err = _bind$12;
          _try_err = _err._0;
          break _L;
        }
      }
      case "bitset": {
        const _bind$13 = _M0FP223moonstl_2dsite_2dbridge4main6bitset(input);
        if (_bind$13.$tag === 1) {
          const _ok = _bind$13;
          return _ok._0;
        } else {
          const _err = _bind$13;
          _try_err = _err._0;
          break _L;
        }
      }
      case "perms": {
        const _bind$14 = _M0FP223moonstl_2dsite_2dbridge4main5perms(input);
        if (_bind$14.$tag === 1) {
          const _ok = _bind$14;
          return _ok._0;
        } else {
          const _err = _bind$14;
          _try_err = _err._0;
          break _L;
        }
      }
      default: {
        return "{\"error\": \"unknown demo\"}";
      }
    }
  }
  return `{\"error\": \"${_M0FP15Error10to__string(_try_err)}\"}`;
}
function _M0FP223moonstl_2dsite_2dbridge4main5names() {
  const _p = "indexmap";
  const _tmp = new _M0DTPC14json4Json6String(_p);
  const _p$2 = "trie";
  const _tmp$2 = new _M0DTPC14json4Json6String(_p$2);
  const _p$3 = "lru";
  const _tmp$3 = new _M0DTPC14json4Json6String(_p$3);
  const _p$4 = "heap";
  const _tmp$4 = new _M0DTPC14json4Json6String(_p$4);
  const _p$5 = "segment";
  const _tmp$5 = new _M0DTPC14json4Json6String(_p$5);
  const _p$6 = "disjoint";
  const _tmp$6 = new _M0DTPC14json4Json6String(_p$6);
  const _p$7 = "bloom";
  const _tmp$7 = new _M0DTPC14json4Json6String(_p$7);
  const _p$8 = "countmin";
  const _tmp$8 = new _M0DTPC14json4Json6String(_p$8);
  const _p$9 = "kmp";
  const _tmp$9 = new _M0DTPC14json4Json6String(_p$9);
  const _p$10 = "diff";
  const _tmp$10 = new _M0DTPC14json4Json6String(_p$10);
  const _p$11 = "phf";
  const _tmp$11 = new _M0DTPC14json4Json6String(_p$11);
  const _p$12 = "ring";
  const _tmp$12 = new _M0DTPC14json4Json6String(_p$12);
  const _p$13 = "bitset";
  const _tmp$13 = new _M0DTPC14json4Json6String(_p$13);
  const _p$14 = "perms";
  const _p$15 = new _M0TPB5ArrayGRPC14json4JsonE([_tmp, _tmp$2, _tmp$3, _tmp$4, _tmp$5, _tmp$6, _tmp$7, _tmp$8, _tmp$9, _tmp$10, _tmp$11, _tmp$12, _tmp$13, new _M0DTPC14json4Json6String(_p$14)], 14);
  return _M0FP212moonbitstack8moonjson13dumps_2einner(new _M0DTPC14json4Json5Array(_p$15), 0, false, false);
}
(() => {
  _M0FP223moonstl_2dsite_2dbridge4main6expose(_M0FP223moonstl_2dsite_2dbridge4main3run, _M0FP223moonstl_2dsite_2dbridge4main5names);
})();
