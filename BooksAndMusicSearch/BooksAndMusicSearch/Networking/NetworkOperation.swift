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
            willChangeValueForKey("isFinished")
        }
        didSet {
            didChangeValueForKey("isFinished")
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
    
    
    // MARK: - Execute
    
    override init() {
        _ready = true
        _executing = false
        _finished = false
        _cancelled = false
        super.init()
        print("Network Operation Ready")
    }

    
    override func start() {
        if !_executing {
            _executing = true
            _ready = false
            _finished = false
            _cancelled = false
            print("Network Operation Started")
        }
    }
    
    
    override func cancel() {
        _cancelled = true
        _executing = false
        print("Network Operation Cancelled")
    }
    
    func finish () {
        _finished = true
        _executing = false
        print("Network Operation Finished")
    }
}
