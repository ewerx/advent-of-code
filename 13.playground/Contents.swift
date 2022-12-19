//
//  main.swift
//  thirteen
//
//  Created by Ehsan on 2022-12-18.
//

import Foundation

let testInput = """
[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]
"""

let inputURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let input = try String(contentsOf: inputURL!)
let pairLines = input.components(separatedBy: "\n\n").filter { !$0.isEmpty }

enum Packet: Decodable, CustomStringConvertible {
  var description: String {
    switch self {
    case .integer(let value):
      return "\(value)"
    case .array(let value):
      return "\(value)"
    }
  }
  
  case integer(Int)
  case array([Packet])
  
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    do {
      self = try .integer(container.decode(Int.self))
    } catch DecodingError.typeMismatch {
      do {
        self = try .array(container.decode([Packet].self))
      } catch DecodingError.typeMismatch {
        throw DecodingError.typeMismatch(Packet.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "unexpected type"))
      }
    }
  }
  
  func isSmaller(rhs: Packet) -> Bool? {
    if case let .integer(lhsValue) = self,
       case let .integer(rhsValue) = rhs {
      return lhsValue == rhsValue ? nil : lhsValue < rhsValue
    } else if case let .array(lhsValue) = self,
              case let .array(rhsValue) = rhs {
      if rhsValue.isEmpty {
        return lhsValue.isEmpty ? nil : false
      } else if lhsValue.isEmpty {
        return true
      } else {
        for i in 0..<lhsValue.count  {
          if i >= rhsValue.count {
            return false
          }
          if let result = lhsValue[i].isSmaller(rhs: rhsValue[i]) {
            return result
          }
        }
        return rhsValue.count > lhsValue.count ? true : nil
      }
    } else if case .integer = self,
              case .array = rhs {
      return Packet.array([self]).isSmaller(rhs: rhs)
    } else if case .array = self,
              case .integer = rhs {
      return isSmaller(rhs: .array([rhs]))
    } else {
      return nil
    }
  }
}

extension Packet: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(description)
  }
}

var pairs = pairLines.map {
  $0.components(separatedBy: "\n")
}.map {
  let decoder = JSONDecoder()
  let one = try! decoder.decode(Packet.self, from: $0[0].data(using: .utf8)!)
  let two = try! decoder.decode(Packet.self, from: $0[1].data(using: .utf8)!)
  return (one, two)
}

// part 1
//let sum = pairs.enumerated()
//  .map { $0.element.0.isSmaller(rhs: $0.element.1) == true ? $0.offset+1 : 0 }
//  .reduce(0, +)
//
//print(sum)

// part 2
var packets = pairs.flatMap { [$0.0, $0.1] }
let divider1 = Packet.array([.array([.integer(2)])])
let divider2 = Packet.array([.array([.integer(6)])])
packets.append(divider1)
packets.append(divider2)
packets.sort(
  by: {
    $0.isSmaller(rhs: $1) ?? false
  }
)

let index1 = packets.firstIndex(of: divider1)! + 1
let index2 = packets.firstIndex(of: divider2)! + 1
let key = index1 * index2

