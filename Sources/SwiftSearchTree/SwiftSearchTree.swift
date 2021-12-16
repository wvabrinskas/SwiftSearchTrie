//
//  Created by William Vabrinskas on 12/7/21.
//

import Foundation
import Combine

public protocol Searchable: Hashable {
  var searchKey: String { get }
}

public class SearchService<Item: Searchable> {
  
  @Published public var searchResults: NSOrderedSet = NSOrderedSet()
  
  private var rootNode: Node?
  private var multiwordDelimiter: Character = " "
  
  private class Node {
    let id: UUID = .init()
    var value: String = ""
    var children: [String: Node] = [:]
    let items: NSMutableOrderedSet = NSMutableOrderedSet()
  }
  
  public init(queriableItems: [Item], multiwordDelimiter: Character = " ") {
    self.multiwordDelimiter = multiwordDelimiter
    self.buildTrie(items: queriableItems)
  }
  
  private func buildTrie(items: [Item]) {
    let root = self.rootNode ?? Node()
    var nextNode = root
    
    for item in items {
      let splitWords = item.searchKey.lowercased().split(separator: self.multiwordDelimiter)
      
      splitWords.forEach { word in
        //before each word we reset to root
        nextNode = root
        
        var enumWord = word.makeIterator()
        
        while let char = enumWord.next() {
          let nextChar = String(char)
          
          if let contains = nextNode.children[nextChar] {
            nextNode = contains
          } else {
            let next = Node()
            nextNode.children[nextChar] = next
            nextNode = next
          }
          
          nextNode.value = nextChar
        }
        
        let index = nextNode.items.count
        nextNode.items.insert(item, at: index)
      }
    }
    
    self.rootNode = root
  }
  
  private func getItems(root node: Node) -> NSOrderedSet {
    var queue = [node]
    let items: NSMutableOrderedSet = NSMutableOrderedSet()
    
    while !queue.isEmpty {
      let popped = queue.removeFirst()
      
      items.addObjects(from: Array(popped.items))
      
      queue.append(contentsOf: popped.children.values)
    }
    
    return items
  }
  
  public func insert(items: [Item]) {
    self.buildTrie(items: items)
  }
  
  @discardableResult
  public func search(q: String) -> NSOrderedSet {
    guard let rootNode = rootNode else {
      return []
    }
    
    let trie = rootNode
    
    var queue = [trie]
    
    let words: NSMutableOrderedSet = []
    
    var workingWord: String = ""
    
    var wordIterator = q.lowercased().makeIterator()
    
    var nextChar = wordIterator.next()
    
    while !queue.isEmpty {
      
      let popped = queue.removeFirst()
      
      guard let next = nextChar else {
        let newWords = getItems(root: popped)
        newWords.forEach { word in
          words.add(word)
        }
        break
      }
      
      if let nextNode = popped.children[String(next)] {
        queue.append(nextNode)
        workingWord += String(next)
        nextChar = wordIterator.next()
        
      } else {
        return []
      }
    }
    
    self.searchResults = words
    
    return words
  }
}
