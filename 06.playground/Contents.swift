import UIKit

let inputURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let input = try String(contentsOf: inputURL!)

var window = [Character]()
var markerIndex: Int?

// Part 1
for (i, char) in input.enumerated() {
  if window.count == 4 {
    window.popLast()
  }
  window.insert(char, at: 0)
  if Set(window).count == 4 {
    markerIndex = Int(i)
    break
  }
}

let packetMarker = (markerIndex ?? -1) + 1

// Part 2
window.removeAll()
for (i, char) in input.enumerated() {
  guard i > 13 else { continue }
  if window.count == 14 {
    window.popLast()
  }
  window.insert(char, at: 0)
  if Set(window).count == 14 {
    markerIndex = Int(i)
    break
  }
}

let messageMarker = (markerIndex ?? -1) + 1
