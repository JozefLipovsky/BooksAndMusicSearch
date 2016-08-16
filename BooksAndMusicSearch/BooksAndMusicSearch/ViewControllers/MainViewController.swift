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

    var musicDataSource: [Song] = []
    var booksDataSource: [Book] = []
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
            return musicDataSource.count
        case 1:
            return booksDataSource.count
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
            
            let musicSearch = MusicSearchOperation.init(with: keyWord!)
            musicSearch.completion = { (songs, error) in
                self.musicDataSource = songs
                
                for song in songs {
                    print("Song: \(song.trackName), Author: \(song.artist)")
                }
            }
            
            
            let booksSearch = BooksSearchOperation.init(with: keyWord!)
            booksSearch.completion = { (books, error) in
                self.booksDataSource = books
                
                for book in books {
                    print("Book: \(book.title), Author: \(book.allAuthorsNames)")
                }
            }
            
            
            
            
            let searchCompletion = NSOperation()
            searchCompletion.completionBlock = {
                print("Both search operations finished")
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.tableView.reloadData()
                })
            }

            
            searchCompletion.addDependency(musicSearch)
            searchCompletion.addDependency(booksSearch)
            
        
            let queue = NSOperationQueue()
            queue.addOperation(searchCompletion)
            queue.addOperation(musicSearch)
            queue.addOperation(booksSearch)
        }
    }

    func willDismissSearchController(searchController: UISearchController) {
        // clean search results state, set empty state
        musicDataSource.removeAll()
        booksDataSource.removeAll()
        tableView.backgroundView?.hidden = false
        tableView.reloadData()
    }
    
    func willPresentSearchController(searchController: UISearchController) {
        // clean empty state, set search results state
        tableView.backgroundView?.hidden = true
        tableView.reloadData()
    }
}
