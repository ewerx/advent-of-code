import UIKit

let inputURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let input = try String(contentsOf: inputURL!)
let lines = input.components(separatedBy: "\n").filter {
  !$0.isEmpty
}

extension ClosedRange {
  func contains(_ other: ClosedRange) -> Bool {
    lowerBound <= other.lowerBound && upperBound >= other.upperBound
  }
}

var contained = 0
var overlaps = 0

for line in lines {
  let ranges = line.components(separatedBy: ",")
  let values1 = ranges[0].components(separatedBy: "-").compactMap(Int.init)
  let values2 = ranges[1].components(separatedBy: "-").compactMap(Int.init)
  let range1 = values1[0]...values1[1]
  let range2 = values2[0]...values2[1]
  
  if range1.contains(range2) || range2.contains(range1) {
    contained += 1
  }
  
  if range1.overlaps(range2) || range2.overlaps(range1) {
    overlaps += 1
  }
}

contained
overlaps
