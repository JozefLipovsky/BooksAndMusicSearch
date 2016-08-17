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

    var musicDataSource: [SearchResult] = []
    var booksDataSource: [SearchResult] = []
    var searchController: UISearchController = UISearchController(searchResultsController: nil)
    let searchManager = SearchOperationsManger()
    
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
    
    private func performSearchOperationsWithKeyWord(keyWord: String) {
        let musicSearch = MusicSearchOperation.init(with: keyWord)
        musicSearch.completion = { (songs, error) in
            self.musicDataSource = songs
        }
        
        let booksSearch = BooksSearchOperation.init(with: keyWord)
        booksSearch.completion = { (books, error) in
            self.booksDataSource = books
        }
        
        
        let searchCompletion = NSOperation()
        searchCompletion.completionBlock = {
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
        
        searchCompletion.addDependency(musicSearch)
        searchCompletion.addDependency(booksSearch)
        
        searchManager.addOperations([searchCompletion, musicSearch, booksSearch])
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
   
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
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("MusicCell", forIndexPath: indexPath) as! MusicTableViewCell
            let track = musicDataSource[indexPath.row]
            cell.trackTitleLabel.text = track.title
            cell.authorLabel.text = track.subTitle
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("BookCell", forIndexPath: indexPath) as! BookTableViewCell
            let book = booksDataSource[indexPath.row]
            cell.titleLabel.text = book.title
            cell.authorsLabel.text = book.subTitle
            return cell
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard searchController.active else {
            return ""
        }
        
        switch section {
        case 0:
            return "Songs"
        case 1:
            return "Books"
        default:
            return nil
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
}

// MARK: - UISearchControllerDelegate, UISearchBarDelegate

extension MainViewController:  UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if let searchedText = searchBar.text where !searchedText.isEmpty {
            let keyWord = searchedText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            performSearchOperationsWithKeyWord(keyWord!)
        }
    }

    func willDismissSearchController(searchController: UISearchController) {
        // clean search results state, set empty state
        searchManager.queue.cancelAllOperations()
        musicDataSource.removeAll()
        booksDataSource.removeAll()
        
        tableView.separatorStyle = .None
        tableView.backgroundView?.hidden = false
        tableView.reloadData()
    }
    
    func willPresentSearchController(searchController: UISearchController) {
        // clean empty state, set search results state
        tableView.separatorStyle = .SingleLine
        tableView.backgroundView?.hidden = true
        tableView.reloadData()
    }
}
