///|
fn main {
  for word in ["let", "loop", "match"] {
    match keywords_phf.get(word) {
      Some(token) =>
        println(
          "\{word}: \{token.name()}, keyword \{keywords_phf.index(word).unwrap()}",
        )
      None => println("\{word}: not a keyword")
    }
  }
}
