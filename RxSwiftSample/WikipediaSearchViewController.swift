//
//  WikipediaSearchViewController.swift
//  RxSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/07/27.
//  Copyright © 2016年 Hiroki Yoshifuji. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

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
        
        configureTableDataSource()
        configureKeyboardDismissesOnScroll()
        configureNavigateOnRowClick()
        configureActivityIndicatorsShow()
    }
    
    func configureTableDataSource() {
        resultsTableView.registerNib(UINib(nibName: "WikipediaSearchCell", bundle: nil),
                                     forCellReuseIdentifier: "WikipediaSearchCell")
        
        resultsTableView.rowHeight = 194
        
        let API = DefaultWikipediaAPI.sharedAPI
        
        resultsTableView.delegate = nil
        resultsTableView.dataSource = nil
        
        searchBar.rx_text
            .asDriver()
            .throttle(0.3)
            .distinctUntilChanged()
            .flatMapLatest { query in
                API.getSearchResults(query)
                    .retry(3)
                    .retryOnBecomesReachable([], reachabilityService: Dependencies.sharedDependencies.reachabilityService)
                    .startWith([])
                    .asDriver(onErrorJustReturn: [])
            }
            .map { results in
                results.map(SearchResultViewModel.init)
            }
            .drive(resultsTableView.rx_itemsWithCellIdentifier("WikipediaSearchCell", cellType: WikipediaSearchCell.self)) { (_, viewModel, cell) in
                cell.viewModel = viewModel
            }
            .addDisposableTo(disposeBag)
    }
    
    func configureKeyboardDismissesOnScroll() {
        let searchBar = self.searchBar
        let searchController = self.searchController
        
        resultsTableView.rx_contentOffset
            .asDriver()
            .filter { _ -> Bool in
                return !searchController.isBeingDismissed()
            }
            .driveNext { _ in
                if searchBar.isFirstResponder() {
                    _ = searchBar.resignFirstResponder()
                }
            }
            .addDisposableTo(disposeBag)
    }
    
    func configureNavigateOnRowClick() {
        let wireframe = DefaultWireframe.sharedInstance
        
        resultsTableView.rx_modelSelected(SearchResultViewModel.self)
            .asDriver()
            .driveNext { searchResult in
                wireframe.openURL(searchResult.searchResult.URL)
            }
            .addDisposableTo(disposeBag)
    }
    
    func configureActivityIndicatorsShow() {
        Driver.combineLatest(
            DefaultWikipediaAPI.sharedAPI.loadingWikipediaData,
            DefaultImageService.sharedImageService.loadingImage
        ) { $0 || $1 }
            .distinctUntilChanged()
            .drive(UIApplication.sharedApplication().rx_networkActivityIndicatorVisible)
            .addDisposableTo(disposeBag)
        
    }
}