//
//  SearchNetworkOperation.swift
//  BooksAndMusicSearch
//
//  Created by JoLi on 2016-08-16.
//  Copyright © 2016 JoLi. All rights reserved.
//

import Foundation


protocol SearchNetworkOperation {
    var url: NSURL { get }
    var keyWord: String { get }
    var request: NSURLRequest { get }
}


