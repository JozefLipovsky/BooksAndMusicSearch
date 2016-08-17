//
//  MainViewModel.swift
//  BooksAndMusicSearch
//
//  Created by JoLi on 2016-08-17.
//  Copyright © 2016 JoLi. All rights reserved.
//

import Foundation

enum SectionType: String {
    case Songs, Books
}

struct Section<T> {
    let type: SectionType
    var items: [T]
}


// TODO: add error handling
class MainViewModel {
    private let searchManager = SearchOperationsManger()
    private var songsResults: Section<SearchResult>
    private var booksResults: Section<SearchResult>
    private var sections: [Section<SearchResult>] {
        return [songsResults, booksResults]
    }
    
    init() {
        songsResults = Section<SearchResult>(type: .Songs, items: [])
        booksResults = Section<SearchResult>(type: .Books, items: [])
    }
    
    // MARK: - Table setup
    
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
    
    // MARK: - Search
    
    func performSearchWithKeyWord(keyWord: String, completion: () -> Void) {
        let musicSearch = MusicSearchOperation(with: keyWord)
        musicSearch.completion = { (songs, error) in
            self.songsResults.items = (songs.count > 0) ? songs : [(SearchResult(title: "No results found for '\(keyWord)", subTitle: ""))]
        }
        
        let booksSearch = BooksSearchOperation(with: keyWord)
        booksSearch.completion = { (books, error) in
            self.booksResults.items = (books.count > 0) ? books : [(SearchResult(title: "No results found for '\(keyWord)'", subTitle: ""))]
        }
    
        let searchCompletion = NSBlockOperation {
            dispatch_async(dispatch_get_main_queue(), {
                completion()
            })
        }
        
        searchCompletion.addDependency(musicSearch)
        searchCompletion.addDependency(booksSearch)
        
        searchManager.addOperations([searchCompletion, musicSearch, booksSearch])
    }
    
    func cancelSearchOperations() {
        searchManager.queue.cancelAllOperations()
    }
    
    func resetSearchResults() {
        songsResults.items.removeAll()
        booksResults.items.removeAll()
    }
}




