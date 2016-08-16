//
//  SearchOperationsManger.swift
//  BooksAndMusicSearch
//
//  Created by JoLi on 2016-08-16.
//  Copyright © 2016 JoLi. All rights reserved.
//

import UIKit

class SearchOperationsManger {
    let queue: NSOperationQueue
    
    init() {
        queue = NSOperationQueue()
    }
    
    func addOperations(operations: [NSOperation]) {
        queue.addOperations(operations, waitUntilFinished: false)
    }
}
