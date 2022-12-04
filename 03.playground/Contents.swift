import UIKit

let inputURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let input = try String(contentsOf: inputURL!)

func priority(from char: Character) -> Int {
  guard let value = char.asciiValue else { return 0 }
  let lowercaseOffset = Character("a").asciiValue!
  let uppercaseOffset = Character("A").asciiValue!
  if value > lowercaseOffset {
    return Int(value - lowercaseOffset) + 1
  } else {
    return Int(value - uppercaseOffset) + 27
  }
}

let lines = input.components(separatedBy: "\n").filter {
  !$0.isEmpty
}

// Part 1

var dupes = [Character]()

for line in lines {
  let mid = line.index(line.startIndex, offsetBy: Int(line.count/2))
  let c1 = Array(String(line.prefix(upTo: mid)))
  let c2 = Array(String(line.suffix(from: mid)))
  
  let set1 = Set(c1)
  let set2 = Set(c2)

  for item in set1 {
    if set2.contains(item) {
      dupes.append(item)
      break
    }
  }
}

let priorities = dupes.map {
  priority(from: $0)
}

let total = priorities.reduce(0, +)

// Part 2

var badgesTotal = 0

for i in stride(from: 0, to: lines.count, by: 3) {
  let e1 = Set(Array(lines[i]))
  let e2 = Set(Array(lines[i+1]))
  let e3 = Set(Array(lines[i+2]))
  
  let common = e1.intersection(e2).intersection(e3)
  assert(common.count == 1)
  badgesTotal += priority(from: common.first!)
}

badgesTotal
