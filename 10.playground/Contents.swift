import UIKit

let inputURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let input = try String(contentsOf: inputURL!)
let lines = input.components(separatedBy: "\n").filter { !$0.isEmpty }

enum Instruction {
  case noop
  case addx(Int)
  
  init(input: String) {
    let components = input.components(separatedBy: " ")
    switch components[0] {
    case "addx": self = .addx(Int(components[1])!)
    default: self = .noop
    }
  }
}

let instructions = lines.map(Instruction.init)

var x = 1
var cycle = 0
var sumStrength = 0
let height = 6
let width = 40
var outputLines = [[Character]](repeating: [], count: height)

func tick() {
  let row = cycle / width
  let pos = cycle % width
  
  if pos == (x-1) || pos == (x+1) || pos == x {
    outputLines[row].append("#")
  } else {
    outputLines[row].append(".")
  }
  
  cycle += 1
  
  if (cycle+20) % 40 == 0 {
    sumStrength += cycle * x
  }
}

for instruction in instructions {
  switch instruction {
  case .noop:
    tick()
  case .addx(let value):
    tick()
    tick()
    x += value
  }
}

// part 1
sumStrength

// part 2
outputLines.forEach {
  print(String($0))
}
