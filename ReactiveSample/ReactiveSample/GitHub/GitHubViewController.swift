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

    @IBOutlet weak var tableView: UITableView!  {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    let disposeBag = DisposeBag()
    var repos : [GHUserRepo] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.isActive = true
    }

    
    func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Ingresa GitHub NickName"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.rx
                                  .text
                                  .throttle(0.3, scheduler: MainScheduler.instance)
                                  .asObservable()
                                  .subscribe({_ in
                                        self.fetchRepos(userID: self.searchController.searchBar.text!)
                                  }).disposed(by: disposeBag)
       
    }
    
    func fetchRepos(userID : String) {
        
        GitHubPresenter.getRepositories(gitHubID: userID) { [weak self] repos in
            guard let strongSelf = self else { return }
            let customRepos = repos
            strongSelf.repos = customRepos
            strongSelf.tableView.reloadData()
        }
    }
    
}

extension GitHubViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GitHubCell", for: indexPath)
        let repo = repos[indexPath.row]
        cell.textLabel?.text = repo.name
        return cell
    }
    
}

