import SwiftUI

let testInput = """
R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20
"""

let inputURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let input = try String(contentsOf: inputURL!)
let lines = input.components(separatedBy: "\n").filter { !$0.isEmpty }

enum Move {
  // right: +, left: -
  // up: +, down: -
  case v(Int)
  case h(Int)
  
  init(values: [String]) {
    switch values[0] {
    case "R":
      self = .h(Int(values[1]) ?? 0)
    case "L":
      self = .h(-(Int(values[1]) ?? 0))
    case "U":
      self = .v(Int(values[1]) ?? 0)
    default:
      self = .v(-(Int(values[1]) ?? 0))
    }
  }
  
  var split: [Move] {
    switch self {
    case let .h(x):
      return [Move](repeating: .h(x.signum()), count: abs(x))
    case let .v(y):
      return [Move](repeating: .v(y.signum()), count: abs(y))
    }
  }
}

enum Distance {
  case touching
  case straight(Move)
  case diagonal(Move, Move)
}

struct Position: Hashable {
  let x: Int
  let y: Int
  
  func distance(to: Position) -> Distance {
    let deltaX = to.x - self.x
    let deltaY = to.y - self.y
    
    if abs(deltaX) <= 1 && abs(deltaY) <= 1 {
      return .touching
    } else if deltaX == 0 {
      return .straight(.v(deltaY.signum()))
    } else if deltaY == 0 {
      return .straight(.h(deltaX.signum()))
    } else {
      return .diagonal(.h(deltaX.signum()), .v(deltaY.signum()))
    }
  }
  
  func closing(distance: Distance) -> Position {
    switch distance {
    case .touching:
      return self
    case let .straight(move):
      return self.applying(move: move)
    case let .diagonal(move1, move2):
      return self
        .applying(move: move1)
        .applying(move: move2)
    }
  }
  
  func applying(move: Move) -> Position {
    switch move {
    case let .h(delta):
      return Position(x: x + delta, y: y)
    case let .v(delta):
      return Position(x: x, y: y + delta)
    }
  }
  
  func following(head: Position) -> Position {
    closing(distance: self.distance(to: head))
  }
}

let moves = lines.map { Move(values: $0.components(separatedBy: " ")) }
var rope = [Position](repeating: Position(x: 0, y: 0), count: 10)

func findVisits() -> Int {
  var visits = Set<Position>()
  
  visits.insert(rope.last!)
  
  for move in moves {
    for step in move.split {
      rope[0] = rope[0].applying(move: step)
      for i in 1..<rope.count {
        rope[i] = rope[i].following(head: rope[i-1])
      }
      visits.insert(rope.last!)
    }
  }
  
  return visits.count
}

let visits = findVisits()
