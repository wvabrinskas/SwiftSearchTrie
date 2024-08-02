# SwiftSearchTrie

[![Tests](https://github.com/wvabrinskas/SwiftSearchTrie/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/wvabrinskas/SwiftSearchTrie/actions/workflows/tests.yml)

A swift package that utilizes a trie data structure to build and provide quick and efficient search algorithm. 

# Introduction 

[Trie](https://en.wikipedia.org/wiki/Trie) is a data structure typically used for word search because of its quick lookup times compared to other alogrithms. To build a trie the complexity is O(N * M) where N is the all the terms and M is the length of the key. However lookup is typically O(M) where M is the length of the search term. 

For searching, inserting, and deleting some strings of length n in a trie, we need to follow at most n number of pointers from the root to the node for strings, if it exists. Each pointer can be looked up in O(1) time. So overall
time complexity = n * O(1) = O(n), which is only dependent on the length of the string and independent of the
number of strings in the trie.

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
