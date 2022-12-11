import UIKit

let testData = """
Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1
"""

let inputURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let input = try String(contentsOf: inputURL!)
let lines = input.components(separatedBy: "\n").filter { !$0.isEmpty }

class Monkey {
  struct Operation {
    let lhs: String
    let rhs: String
    let op: String
    
    func execute(_ old: Int) -> Int {
      let lhsValue = old
      let rhsValue = Int(rhs) ?? old
      if op == "*" {
        return lhsValue * rhsValue
      } else {
        return lhsValue + rhsValue
      }
    }
  }
  
  var items: [Int] = []
  var operation: Operation? = nil
  var testDivisor = 0
  var trueDestination = 0
  var falseDestination = 0
  var inspections = 0
  
  init() {
  }
}

var monkeys: [Monkey] = []

for line in lines {
  if line.starts(with: "Monkey") {
    monkeys.append(Monkey())
  } else if line.starts(with: "  Starting items:") {
    guard let start = line.firstIndex(of: ":") else { continue }
    let items = line.suffix(from: start)
      .replacingOccurrences(of: ",", with: "")
      .components(separatedBy: " ")
      .compactMap(Int.init)
    monkeys.last!.items = items
  } else if line.starts(with: "  Operation:") {
    guard let start = line.firstIndex(of: "=") else { continue }
    let operation = line.suffix(from: line.index(start, offsetBy: 1))
      .trimmingCharacters(in: .whitespaces)
      .components(separatedBy: " ")
    
    monkeys.last!.operation = Monkey.Operation(lhs: operation[0], rhs: operation[2], op: operation[1])
  } else if line.starts(with: "  Test:") {
    guard let valueIndex = line.firstIndex(where: { $0.isNumber }) else { continue }
    monkeys.last!.testDivisor = Int(line.suffix(from: valueIndex))!
  } else if line.starts(with: "    If true:") {
    guard let valueIndex = line.firstIndex(where: { $0.isNumber }) else { continue }
    monkeys.last!.trueDestination = Int(line.suffix(from: valueIndex))!
  } else if line.starts(with: "    If false:") {
    guard let valueIndex = line.firstIndex(where: { $0.isNumber }) else { continue }
    monkeys.last!.falseDestination = Int(line.suffix(from: valueIndex))!
  }
}

let commonMultiple = monkeys.map { $0.testDivisor }.reduce(1, *)
commonMultiple

func playRound() {
  for monkey in monkeys {
    let inspected = monkey.items
    for item in inspected {
      var newItem = monkey.operation!.execute(item)
//      newItem /= 3 // part 1
      newItem = newItem % commonMultiple
      if newItem % monkey.testDivisor == 0 {
        monkeys[monkey.trueDestination].items.append(newItem)
      } else {
        monkeys[monkey.falseDestination].items.append(newItem)
      }
    }
    monkey.items.removeFirst(inspected.count)
    monkey.inspections += inspected.count
  }
}

for _ in 0..<10_000 {
  playRound()
}

monkeys

let topMonkeys = monkeys.sorted { $0.inspections > $1.inspections }.prefix(2)
let monkeyBusiness = topMonkeys.map { $0.inspections }.reduce(1, *)

monkeyBusiness
