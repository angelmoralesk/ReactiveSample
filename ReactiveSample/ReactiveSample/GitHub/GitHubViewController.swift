//
//  GitHubViewController.swift
//  ReactiveSample
//
//  Created by Angel Jesse Morales Karam Kairuz on 05/01/18.
//  Copyright © 2018 TheKairuz. All rights reserved.
//

import UIKit
import GitHub
import RxSwift
import RxDataSources

class GitHubViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        // Do any additional setup after loading the view.
    }

    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Ingresa GitHub NickName"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.isActive = true
    }

}

extension GitHubViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
     
        GitHubPresenter.getRepositories(gitHubID: searchController.searchBar.text!) { repos in
            let customRepos = repos
            customRepos.bind(to: self.tableView.rx.items(cellIdentifier: "GitHubCell")) { _, repo, cell in
                cell.textLabel?.text = repo.name
            }.disposed(by: self.disposeBag)
        }
    }
}

