//
//  BooksSearchOperation.swift
//  BooksAndMusicSearch
//
//  Created by JoLi on 2016-08-16.
//  Copyright © 2016 JoLi. All rights reserved.
//

import Foundation

class BooksSearchOperation: NetworkOperation, SearchNetworkOperation {
    private var task: NSURLSessionDataTask?
    var keyWord: String
    var completion: (([SearchResult], NSError?) -> Void) = { _ in }
    var url: NSURL {
        return NSURL(string: "https://www.googleapis.com/books/v1/volumes?key=AIzaSyDu60vE57CKAVcZKI0tdrgpQTVOea3PcTo&maxResults=10&q=\(keyWord)+intitle")!
    }
    
    var request: NSURLRequest {
        return NSURLRequest(URL: url)
    }

    init(with keyWord: String) {
        self.keyWord = keyWord
        super.init()
    }
    
    override func start() {
        super.start()
        task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            if let error = error {
                print("Books search error: \(error.localizedDescription)")
                self.completion([], error)
                self.finish()
            }
            
            if let data = data {
                let books = self.booksFromJSON(data)
                self.completion(books, error)
                self.finish()
            } else {
                self.completion([], error)
                self.finish()
            }
        }
        task!.resume()
    }
    
    override func cancel() {
        if let task = task { task.cancel() }
        super.cancel()
    }
}

extension BooksSearchOperation {
    func booksFromJSON(data: NSData) -> [SearchResult] {
        var books: [SearchResult] = []
        do {
            if let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String: AnyObject],
                let items = json["items"] as? [[String: AnyObject]] {
                for item in items {
                    if let volumeInfo = item["volumeInfo"] as? [String: AnyObject], let title = volumeInfo["title"] as? String, let authors = volumeInfo["authors"] as? [String] {
                        let allAuthors = authors.joinWithSeparator(", ");
                        let searchResult = SearchResult(title: title, subTitle: allAuthors)
                        books.append(searchResult)
                    }
                }
            }
        } catch {
            print(error)
        }
        return books;
    }
}
