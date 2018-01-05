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
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Ingresa GitHub NickName"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.rx
                                  .searchButtonClicked
                                  .asObservable()
                                  .subscribe(onNext: {
                                        self.fetchRepos(userID: self.searchController.searchBar.text!)
                                  }).disposed(by: disposeBag)
       
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.isActive = true
    }

    func fetchRepos(userID : String) {
        
        GitHubPresenter.getRepositories(gitHubID: userID) { [weak self] repos in
            guard let strongSelf = self else { return }
            let customRepos = repos
            customRepos
            .bind(to: strongSelf.tableView.rx.items(cellIdentifier: "GitHubCell")) { _, repo, cell in
                        cell.textLabel?.text = repo.name
                    }
            .disposed(by: strongSelf.disposeBag)
        }
    }
    
}

