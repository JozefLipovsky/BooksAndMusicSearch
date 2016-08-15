//
//  NetworkOperation.swift
//  BooksAndMusicSearch
//
//  Created by JoLi on 2016-08-15.
//  Copyright © 2016 JoLi. All rights reserved.
//

import UIKit

class NetworkOperation: NSOperation {
    
    // MARK: - Properties
    override var ready: Bool { return _ready }
    private var _ready = false {
        willSet {
            willChangeValueForKey("isReady")
        }
        didSet {
            didChangeValueForKey("isReady")
        }
    }
    
    override var executing: Bool { return _executing }
    private var _executing = false {
        willSet {
            willChangeValueForKey("isExecuting")
        }
        didSet {
            didChangeValueForKey("isExecuting")
        }
    }
    
    override var finished: Bool { return _finished }
    private var _finished: Bool {
        willSet {
            willChangeValueForKey("isExecuting")
        }
        didSet {
            didChangeValueForKey("isExecuting")
        }
    }
    
    override var cancelled: Bool { return _cancelled }
    private var _cancelled = false {
        willSet {
            willChangeValueForKey("isCancelled")
        }
        didSet {
            didChangeValueForKey("isCancelled")
        }
    }
    
    override var asynchronous: Bool { return true }
    
    
    
    override init() {
        _ready = true
        _executing = false
        _finished = false
        _cancelled = false
        super.init()
    }

    
    override func start() {
        _executing = true
        _ready = false
        _finished = false
        _cancelled = false
    }
    
    
    override func cancel() {
        _cancelled = true
        _executing = false
    }
    
    func finish () {
        _finished = true
        _executing = false
    }
}
