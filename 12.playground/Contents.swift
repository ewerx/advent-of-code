import UIKit

let testInput = """
Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
"""

let inputURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let input = try String(contentsOf: inputURL!)
let lines = input.components(separatedBy: "\n").filter { !$0.isEmpty }

struct Position: Hashable {
  let x, y: Int
  
  var neighbours: [Position] {
    [Position(x: x-1, y: y),
     Position(x: x+1, y: y),
     Position(x: x, y: y-1),
     Position(x: x, y: y+1)]
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(x)
    hasher.combine(y)
  }
}

var map = [[Int]](repeating: [], count: lines.count)
var start = Position(x: 0, y: 0)
var target = Position(x: 0, y: 0)
var allStarts = Set<Position>()

func height(_ char: Character) -> Int {
  Int(char.asciiValue! - Character("a").asciiValue!)
}

func height(at pos: Position) -> Int {
  map[pos.y][pos.x]
}

func withinBounds(pos: Position) -> Bool {
  pos.x >= 0 && pos.x < map.first!.count && pos.y >= 0 && pos.y < map.count
}

func parse() {
  for (y, line) in lines.enumerated() {
    for (x, char) in line.enumerated() {
      if char == "S" {
        start = Position(x: x, y: y)
        map[y].append(0)
        allStarts.insert(start)
      } else if char == "E" {
        target = Position(x: x, y: y)
        map[y].append(height(Character("z")))
      } else {
        let height = height(char)
        if height == 0 {
          allStarts.insert(Position(x: x, y: y))
        }
        map[y].append(height)
      
      }
    }
  }
}

var adjacents: [Position: [Position]] = [:]
func buildGraph() {
  for (y, row) in map.enumerated() {
    for (x, value) in row.enumerated() {
      let pos = Position(x: x, y: y)
      adjacents[pos] = pos.neighbours
        .filter({ withinBounds(pos: $0) && (height(at: $0) + 1) >= value })
    }
  }
}


func bfs(adjacents: [Position: [Position]], start: Position, end: Position) -> [Int] {
  var queue: [(pos: Position, cost: Int)] = [(start, 0)]
  var visited: Set<Position> = Set([start])
  var results = [Int]()
  
  while !queue.isEmpty {
    let node = queue.removeFirst()
    if allStarts.contains(node.pos) {
      results.append(node.cost)
    }
    adjacents[node.pos]?.forEach {
      if !visited.contains($0) {
        queue.append(($0, node.cost + 1))
        visited.insert($0)
      }
    }
  }
  return results
}

parse()
buildGraph()

// part 1
//let shortestPathCost = bfs(adjacents: adjacents, start: target, end: start)

// part 2
let allPathCosts = bfs(adjacents: adjacents, start: target, end: start)
let shortestPathCost = allPathCosts.reduce(Int.max, min)

