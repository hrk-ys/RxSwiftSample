//
//  WikipediaSearchViewController.swift
//  RxSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/07/27.
//  Copyright © 2016年 Hiroki Yoshifuji. All rights reserved.
//

import UIKit

class WikipediaSearchViewController: ViewController {
    @IBOutlet var searchBarContainer: UIView!
    
    private let searchController = UISearchController(searchResultsController: UITableViewController())
    private var searchBar: UISearchBar {
        return self.searchController.searchBar
    }
    private var resultsViewController: UITableViewController {
        return (self.searchController.searchResultsController as? UITableViewController)!
    }
    private var resultsTableView: UITableView {
        return self.resultsViewController.tableView!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchBar = self.searchBar
        let searchBarController = self.searchBarContainer
        
        searchBarController.addSubview(searchBar)
        searchBar.frame = searchBarContainer.bounds
        searchBar.autoresizingMask = .FlexibleWidth
        
        resultsViewController.edgesForExtendedLayout = UIRectEdge.None
        
    }
    
    func configureTableDataSource() {
        resultsTableView.registerNib(UINib(nibName: "WikipediaSearchCell", bundle: nil),
                                     forCellReuseIdentifier: "WikipediaSearchCell")
    }
}