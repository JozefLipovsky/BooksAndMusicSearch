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

    var searchController: UISearchController = UISearchController(searchResultsController: nil)
    let searchManager = SearchOperationsManger()
    var viewModel = MainViewModel()
    
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
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0

        let backgroundLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
        backgroundLabel.text = "Tap on search bar and start typing to begin new search..."
        backgroundLabel.textAlignment = .Center
        backgroundLabel.numberOfLines = 0
        tableView.backgroundView = backgroundLabel
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsForSection(section)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchResultCell", forIndexPath: indexPath) as! SearchResultCell
        let searchResult = viewModel.searchResultAtIndexPath(indexPath)
        cell.titleLabel.text = searchResult.title
        cell.subTitleLabel.text = searchResult.subTitle
        return cell
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.headerForSection(section)
    }
}

// MARK: - UISearchControllerDelegate, UISearchBarDelegate

extension MainViewController:  UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if let searchedText = searchBar.text where !searchedText.isEmpty {
            let keyWord = searchedText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            viewModel.performSearchWithKeyWord(keyWord!, completion: { [weak self] in
                if let tableView = self?.tableView  {
                    tableView.reloadData()
                }
            })
        }
    }

    func willDismissSearchController(searchController: UISearchController) {
        viewModel.cancelSearchOperations()
        viewModel.resetSearchResults()
        
        tableView.separatorStyle = .None
        tableView.backgroundView?.hidden = false
        tableView.reloadData()
    }
    
    func willPresentSearchController(searchController: UISearchController) {
        tableView.separatorStyle = .SingleLine
        tableView.backgroundView?.hidden = true
        tableView.reloadData()
    }
}
