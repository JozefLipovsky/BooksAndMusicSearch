//
//  BooksSearchOperation.swift
//  BooksAndMusicSearch
//
//  Created by JoLi on 2016-08-16.
//  Copyright © 2016 JoLi. All rights reserved.
//

import Foundation

class BooksSearchOperation: NetworkOperation, SearchNetworkOperation {
    var keyWord: String
    var completion: (([Book], NSError?) -> Void) = { _ in }
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
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            if let error = error {
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
        task.resume()
    }
}

extension BooksSearchOperation {
    func booksFromJSON(data: NSData) -> [Book] {
        var books: [Book] = []
        do {
            if let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String: AnyObject],
                let items = json["items"] as? [[String: AnyObject]] {
                for item in items {
                    if let volumeInfo = item["volumeInfo"] as? [String: AnyObject],
                        let title = volumeInfo["title"] as? String,
                        let authors = volumeInfo["authors"] as? [String] {
                        let book = Book.init(title: title, authors: authors)
                        books.append(book)
                    }
                }
            }
        } catch {
            print(error)
        }
        return books;
    }
}
