# SwiftSearchTrie

[![Tests](https://github.com/wvabrinskas/SwiftSearchTrie/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/wvabrinskas/SwiftSearchTrie/actions/workflows/tests.yml)

A swift package that utilizes a trie data structure to build and provide quick and efficient search algorithm. 

# Introduction 

[Trie](https://en.wikipedia.org/wiki/Trie) is a data structure typically used for word search because of its quick lookup times compared to other alogrithms. To build a trie the complexity is O(N * M) where N is the all the terms and M is the length of the key. However lookup is typically O(1) in complexity but at worst it's O(M) where M is the length of the search term. 

# Implementation

Create an object that conforms to `Searchable` protocol. 

```
struct Item: Searchable {
  var searchKey: String
}
```

Create an array of those items and instantiate the `SearchService` with those items. 
- `queriableItems`: the list of items to search against 
- `multiwordDelimiter`: The delimiter that separates keys with multiple terms. ex: *hot sandwhich* or *hot_sandwhich*. It defaults to a space character. This allows the algorithm to accurately separate out the terms to build the proper search tree since it searches based on prefix. 

```
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

  let items: [Item] = terms.map { Item(searchKey: $0) }}

  let service: SearchService = SearchService(queriableItems: items, multiwordDelimiter: " ")

  ```

This will build the trie tree. 

To search simply call `search` on your `SearchService`

```
  let query = "sandwhich"
  let results = service.search(q: query)
```

This will return the results as an `NSOrderedSet` of types `Item`
