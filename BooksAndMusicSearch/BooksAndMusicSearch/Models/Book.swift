//
//  Book.swift
//  BooksAndMusicSearch
//
//  Created by JoLi on 2016-08-15.
//  Copyright © 2016 JoLi. All rights reserved.
//

import Foundation

class Book {
    var title: String
    var authors: [String]
    var allAuthorsNames: String {
        return authors.joinWithSeparator(", ")
    }
    
    init(title: String, authors: [String]) {
        self.title = title
        self.authors = authors
    }
}