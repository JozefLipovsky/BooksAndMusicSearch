//
//  MainViewController.swift
//  BooksAndMusicSearch
//
//  Created by JoLi on 2016-08-11.
//  Copyright © 2016 JoLi. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var searchBarPlaceholderView: UIView!
    @IBOutlet weak var tableView: UITableView!

    var musicDataSource: [String] = []
    var booksDataSource: [String] = []
    var searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Helpers

    func setupUI() {
        searchController.dimsBackgroundDuringPresentation = false
        searchController.delegate = self
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchBarPlaceholderView.addSubview(searchController.searchBar)
        
        tableView.separatorStyle = .None

        
        let backgroundLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
        backgroundLabel.text = "Tap on search bar and start typing to begin new search..."
        backgroundLabel.textAlignment = .Center
        backgroundLabel.numberOfLines = 0
        tableView.backgroundView = backgroundLabel
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
   
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard searchController.active else {
            return 0
        }
        
        switch section {
        case 0:
            // Song data source count
            return 1
        case 1:
            // Song data source count
            return 3
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCellWithIdentifier("MusicCell", forIndexPath: indexPath) as UITableViewCell
            
        case 1:
            cell = tableView.dequeueReusableCellWithIdentifier("BookCell", forIndexPath: indexPath) as UITableViewCell
            
        default:
            break
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard searchController.active else {
            return ""
        }
        
        switch section {
        case 0:
            return "Song"
        case 1:
            return "Books"
        default:
            return nil
        }
    }
}

// MARK: - UISearchControllerDelegate, UISearchBarDelegate

extension MainViewController:  UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if let searchedText = searchBar.text where !searchedText.isEmpty {
            let keyWord = searchedText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())

//            NetworkManager.fetchSongs(withKeyWord: keyWord!) { (songs, error) in
//                for song in songs {
//                    print("Song: \(song.trackName), Author: \(song.artist)")
//                }
//            }
//    
//            NetworkManager.fetchBooks(withKeyWord: keyWord!) { (books, error) in
//                for book in books {
//                    print("Book: \(book.title), Authors: \(book.allAuthorsNames)")
//                }
//            }
            
            
            
            // test
            let url = NSURL(string: "https://itunes.apple.com/search?media=music&entity=song&attribute=songTerm&limit=10&term=\(keyWord!)")
            let request = NSURLRequest(URL: url!)
            
            let songsOperation = DownloadRequestOperation.init(withRequest: request)
            
            songsOperation.completion = { (songs, error) in
                for song in songs {
                    print("Song: \(song.trackName), Author: \(song.artist)")
                }
            }
            
            let queue = NSOperationQueue()
            queue.addOperation(songsOperation)
        }
    }

    func willDismissSearchController(searchController: UISearchController) {
        // clean search results state, set empty state
        
    }
    
    func willPresentSearchController(searchController: UISearchController) {
        // clean empty state, set search results state
        
    }
}
