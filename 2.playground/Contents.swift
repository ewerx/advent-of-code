import UIKit

let inputURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let input = try String(contentsOf: inputURL!)
let lines = input.components(separatedBy: "\n")

enum Shape {
  case rock
  case paper
  case scissors
  
  var score: Int {
    switch self {
    case .rock:     return 1
    case .paper:    return 2
    case .scissors: return 3
    }
  }
  
  init?(opponent: String) {
    switch opponent {
    case "A": self = .rock
    case "B": self = .paper
    case "C": self = .scissors
    default: return nil
    }
  }
  
  init?(player: String) {
    switch player {
    case "X": self = .rock
    case "Y": self = .paper
    case "Z": self = .scissors
    default: return nil
    }
  }
  
  init(for outcome: Outcome, against opponent: Shape) {
    switch outcome {
    case .win:
      self = (opponent == .rock) ? .paper
      : (opponent == .paper) ? .scissors
      : .rock
    case .draw:
      self = opponent
    case .lose:
      self = (opponent == .rock) ? .scissors
      : (opponent == .paper) ? .rock
      : .paper
    }
  }
  
  func outcome(against opponent: Shape) -> Outcome {
    switch self {
    case .rock:
      return (opponent == .rock) ? .draw
      : (opponent == .paper) ? .lose
      : .win
    case .paper:
      return (opponent == .rock) ? .win
      : (opponent == .paper) ? .draw
      : .lose
    case .scissors:
      return (opponent == .rock) ? .lose
      : (opponent == .paper) ? .win
      : .draw
    }
  }
}

enum Outcome: Int {
  case win = 6
  case lose = 0
  case draw = 3
  
  init(opponent: Shape, player: Shape) {
    self = player.outcome(against: opponent)
  }
  
  init?(expected: String) {
    switch expected {
    case "X": self = .lose
    case "Y": self = .draw
    case "Z": self = .win
    default: return nil
    }
  }
}

func roundScore(opponent: Shape, player: Shape) -> Int {
  let outcome = Outcome(opponent: opponent, player: player)
  return outcome.rawValue + player.score
}

func roundScore(opponent: Shape, outcome: Outcome) -> Int {
  let player = Shape(for: outcome, against: opponent)
  return outcome.rawValue + player.score
}

var totalScorePart1 = 0
var totalScorePart2 = 0

let testLines = [
"A Y",
"B X",
"C Z",
]

for line in lines {
  guard !line.isEmpty else { continue }
  let strategy = line.components(separatedBy: " ")
  let opponent = Shape(opponent: strategy[0])!
  let player = Shape(player: strategy[1])!
  
  totalScorePart1 += roundScore(opponent: opponent,
                                player: player)
  
  let outcome = Outcome(expected: strategy[1])!
  totalScorePart2 += roundScore(opponent: opponent,
                                outcome: outcome)
}

totalScorePart1
totalScorePart2

