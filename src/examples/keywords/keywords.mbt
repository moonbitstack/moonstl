///|
/// The words a small language reserves.
#derive(Eq, Debug)
enum Token {
  Fn
  Let
  Match
  If
  Else
  While
  Return
}

///|
fn Token::name(self : Token) -> String {
  match self {
    Fn => "Fn"
    Let => "Let"
    Match => "Match"
    If => "If"
    Else => "Else"
    While => "While"
    Return => "Return"
  }
}

///|
#phf.ordered_map
let keywords : Array[(String, Token)] = [
  ("fn", Fn),
  ("let", Let),
  ("match", Match),
  ("if", If),
  ("else", Else),
  ("while", While),
  ("return", Return),
]
