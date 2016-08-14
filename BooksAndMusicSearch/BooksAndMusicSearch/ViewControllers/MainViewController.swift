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

    var musicDataSource = [String]()
    var booksDataSource = [String]()
    var searchController: UISearchController!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.placeholder = "Search"
        definesPresentationContext = true
        searchBarPlaceholderView.addSubview(searchController.searchBar)
        
        tableView.separatorStyle = .None

        let backgroundLabel = UILabel(frame: CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height))
        backgroundLabel.text = "Tap on search bar and start typing to begin new search..."
        backgroundLabel.textAlignment = .Center
        backgroundLabel.numberOfLines = 0
        tableView.backgroundView = backgroundLabel
    }
}


extension MainViewController: UITableViewDataSource {
   
    // MARK: - TableView Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard searchController.active else {
            return 0
        }
        
        switch section {
        case 0:
            // music data source count
            return 1
        case 1:
            // music data source count
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
            return "Music"
        case 1:
            return "Books"
        default:
            return nil
        }
    }
}


extension MainViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    // MARK: - SearchResults Updating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let keyWord = searchController.searchBar.text where !keyWord.isEmpty {
            // search request
        }
    }
    
    // MARK: - SearchResults Delegate
    
    func willDismissSearchController(searchController: UISearchController) {
        // clean search results state, set empty state
    }
    
    func willPresentSearchController(searchController: UISearchController) {
        // clean empty state, set search results state
    }
    
}
