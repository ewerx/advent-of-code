import UIKit

let inputURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let input = try String(contentsOf: inputURL!)
let lines = input.components(separatedBy: "\n")

class Directory {
  let name: String
  var files = [String: Int]()
  var dirs: [Directory] = []
  func size() -> Int {
    let fileSize = files.values.reduce(0, +)
    let subDirSize = dirs.reduce(0) { partialResult, dir in
      partialResult + dir.size()
    }
    return fileSize + subDirSize
  }
  
  init(name: String) {
    self.name = name
  }
}

var root = Directory(name: "/")
var path: [Directory] = []

for line in lines {
  if line.first == "$" {
    // command
    let args = line.components(separatedBy: " ")
    let command = args[1]
    
    if command == "cd" {
      let arg = args[2]
      if arg == ".." {
        path.popLast()
      } else if arg == "/" {
        path.append(root)
      } else {
        if let dir = path[path.count-1].dirs.first(where: { $0.name == arg }) {
          path.append(dir)
        }
      }
    } else if command == "ls" {
      
    }
  } else {
    // ls output
    guard !line.isEmpty else { continue }
    let components = line.components(separatedBy: " ")
    assert(components.count == 2)
    if components[0] == "dir" {
      let name = components[1]
      path[path.count-1].dirs.append(Directory(name: name))
    } else {
      let size = Int(components[0]) ?? 0
      let name = components[1]
      path[path.count-1].files[name] = size
    }
  }
}

var totalSize: Int = 0

func traverse(_ dir: Directory, level: Int = 0) {
  let size = dir.size()
  if size <= 100000 {
    totalSize += size
  }
  for dir in dir.dirs {
    traverse(dir, level: level + 1)
  }
}

traverse(root)

// Part 1
totalSize

// Part 2
let maxSpace = 70000000
let minSpace = 30000000

let unusedSpace = maxSpace - root.size()
let spaceRequired = minSpace - unusedSpace

var candidates = [Int]()
func findCandidates(_ dir: Directory) {
  let size = dir.size()
  if size >= spaceRequired {
    candidates.append(size)
  }
  for dir in dir.dirs {
    findCandidates(dir)
  }
}
findCandidates(root)

let sizeOfDirToDelete = candidates.min()


