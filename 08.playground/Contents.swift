import UIKit

let testInput = """
30373
25512
65332
33549
35390
"""

let inputURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let input = try String(contentsOf: inputURL!)
let lines = input.components(separatedBy: "\n").filter { !$0.isEmpty }

let map = lines
  .map {
    $0.compactMap { char in
      char.wholeNumberValue
    }
  }

let colCount = map.first!.count
let rowCount = map.count
let lastRow = rowCount - 1
let lastCol = colCount - 1

var numVisible = 0
var topScenicScore = 0

func visibleLeft(row: Int, col: Int, height: Int) -> (Bool, Int) {
  var isVisible = true
  var distance = 0
  for i in stride(from: col-1, through: 0, by: -1) {
    distance += 1
    if map[row][i] >= height {
      isVisible = false
      break
    }
  }
  return (isVisible, distance)
}

func visibleRight(row: Int, col: Int, height: Int) -> (Bool, Int) {
  var isVisible = true
  var distance = 0
  for i in stride(from: col+1, through: lastCol, by: 1) {
    distance += 1
    if map[row][i] >= height {
      isVisible = false
      break
    }
  }
  return (isVisible, distance)
}

func visibleUp(row: Int, col: Int, height: Int) -> (Bool, Int) {
  var isVisible = true
  var distance = 0
  for i in stride(from: row-1, through: 0, by: -1) {
    distance += 1
    if map[i][col] >= height {
      isVisible = false
      break
    }
  }
  return (isVisible, distance)
}

func visibleDown(row: Int, col: Int, height: Int) -> (Bool, Int) {
  var isVisible = true
  var distance = 0
  for i in stride(from: row+1, through: lastRow, by: 1) {
    distance += 1
    if map[i][col] >= height {
      isVisible = false
      break
    }
  }
  return (isVisible, distance)
}

for (rowIndex, row) in map.enumerated() {
  for (colIndex, height) in row.enumerated() {
    if rowIndex == 0 || colIndex == 0 || rowIndex == lastRow || colIndex == lastCol {
      numVisible += 1
      continue
    }
    
    let left = visibleLeft(row: rowIndex, col: colIndex, height: height)
    let right = visibleRight(row: rowIndex, col: colIndex, height: height)
    let up = visibleUp(row: rowIndex, col: colIndex, height: height)
    let down = visibleDown(row: rowIndex, col: colIndex, height: height)
    
    if left.0 ||
        right.0 ||
        up.0 ||
        down.0 {
      numVisible += 1
    }
    
    let scenicScore = left.1 * right.1 * up.1 * down.1
    topScenicScore = max(scenicScore, topScenicScore)
  }
}

// Part 1
numVisible

topScenicScore
