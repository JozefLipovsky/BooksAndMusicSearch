//
//  MainViewModel.swift
//  BooksAndMusicSearch
//
//  Created by JoLi on 2016-08-17.
//  Copyright © 2016 JoLi. All rights reserved.
//

import Foundation


public enum SectionType: String {
    case Songs, Books
}

public struct Section<T> {
    let type: SectionType
    var items: [T]
}

class MainViewModel {
    private var sections:[Section<SearchResult>]
    
    init(sections: [Section<SearchResult>]) {
        self.sections = sections
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRowsForSection(section: Int) -> Int {
        return sections[section].items.count
    }
    
    func searchResultAtIndexPath(indexPath: NSIndexPath) -> SearchResult {
        return sections[indexPath.section].items[indexPath.row]
    }
    
    func headerForSection(section: Int) -> String {
        return sections[section].items.count > 0 ? sections[section].type.rawValue : ""
    }
}


//private func performSearchOperationsWithKeyWord(keyWord: String) {
//    let musicSearch = MusicSearchOperation.init(with: keyWord)
//    musicSearch.completion = { (songs, error) in
//        self.musicDataSource = songs
//    }
//    
//    let booksSearch = BooksSearchOperation.init(with: keyWord)
//    booksSearch.completion = { (books, error) in
//        self.booksDataSource = books
//    }
//    
//    
//    let searchCompletion = NSOperation()
//    searchCompletion.completionBlock = {
//        dispatch_async(dispatch_get_main_queue(), {
//            self.tableView.reloadData()
//        })
//    }
//    
//    searchCompletion.addDependency(musicSearch)
//    searchCompletion.addDependency(booksSearch)
//    
//    searchManager.addOperations([searchCompletion, musicSearch, booksSearch])
//}
