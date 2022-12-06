import UIKit

let inputURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let input = try String(contentsOf: inputURL!)
let lines = input.components(separatedBy: "\n")

typealias Move = (count: Int, from: Int, to: Int)

var stacks: [[Character]] = []
var moves: [Move] = []

var parseMoves = false
for line in lines {
  if parseMoves {
    if line.isEmpty {
      break
    }
    let components = line.components(separatedBy: " ").compactMap(Int.init)
    assert(components.count == 3)
    moves.append((components[0], components[1], components[2]))
  } else {
    if line.isEmpty {
      parseMoves = true
      continue
    }
    
    var stackIndex = 0
    for i in stride(from: 1,
                    to: line.count,
                    by: 4) {
      if stacks.count <= stackIndex {
        stacks.append([Character]())
      }
      let lineIndex = line.index(line.startIndex, offsetBy: i)
      if line[lineIndex].isLetter {
        stacks[stackIndex].append(line[lineIndex])
      }
      stackIndex += 1
    }
  }
}

stacks

moves

func doMove1(_ move: Move) {
  for _ in 0..<move.count {
    let item = stacks[move.from-1].removeFirst()
    stacks[move.to-1].insert(item, at: 0)
  }
}

func doMove2(_ move: Move) {
  let items = stacks[move.from-1][0..<move.count]
  stacks[move.from-1].removeFirst(move.count)
  stacks[move.to-1].insert(contentsOf: items, at: 0)
}


moves.forEach {
  doMove2($0)
}

stacks

let topItems = stacks.map { $0.first! }
print(String(topItems))



