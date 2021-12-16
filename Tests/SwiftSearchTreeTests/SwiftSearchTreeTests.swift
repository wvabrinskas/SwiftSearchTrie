import XCTest
@testable import SwiftSearchTree

struct Item: Searchable {
  var searchKey: String
}

final class SwiftSearchTreeTests: XCTestCase {
  let terms: [String] = [ "tennis",
                          "sports",
                          "burgers",
                          "hotdog",
                          "hot sandwhich",
                          "cold sandwhich",
                          "turkey",
                          "pizza",
                          "pepperoni pizza",
                          "salami",
                          "sushi"
  ]

  lazy var service: SearchService = SearchService(queriableItems: self.items)

  lazy var items: [Item] = {
    return terms.map { Item(searchKey: $0) }
  }()

  func test_letterSearch() {
    let query = "s"
    let results = self.service.search(q: query)
    XCTAssert(results.count == 5)
  }
  
  func test_startingWordSearch() {
    let query = "hot"
    let results = self.service.search(q: query)
    XCTAssert(results.count == 2)
  }
  
  func test_endingWordSearch() {
    let query = "sandwhich"
    let results = self.service.search(q: query)
    XCTAssert(results.count == 2)
    
    let query2 = "pizza"
    let results2 = self.service.search(q: query2)
    XCTAssert(results2.count == 2)
  }
  
  func test_customDelimiterSearch() {
    
    let termsWithCustomDelimiter: [String] = [ "tennis",
                                               "sports",
                                               "burgers",
                                               "hotdog",
                                               "hot_sandwhich",
                                               "cold_sandwhich",
                                               "turkey",
                                               "pizza",
                                               "pepperoni_pizza",
                                               "salami",
                                               "sushi"
    ]
    
    let items: [Item] = termsWithCustomDelimiter.map { Item(searchKey: $0) }
    
    let localService = SearchService(queriableItems: items, multiwordDelimiter: "_")
    
    let query = "s"
    let results = localService.search(q: query)
    XCTAssert(results.count == 5)
  }
  
  func test_insertItems() {
    let insertKey = "zzzzzz"
    let item = Item(searchKey: insertKey)
    
    let itemsToInsert = [item]
    let query = "zz"
    
    service.insert(items: itemsToInsert)
    
    let results = service.search(q: query)
    
    XCTAssert(results.count == 1)
    XCTAssert(results.contains(item) == true)
  }
}
