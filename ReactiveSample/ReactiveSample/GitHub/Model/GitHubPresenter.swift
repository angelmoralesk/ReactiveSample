//
//  GitHubPresenter.swift
//  ReactiveSample
//
//  Created by Angel Jesse Morales Karam Kairuz on 05/01/18.
//  Copyright © 2018 TheKairuz. All rights reserved.
//

import Foundation
import RxSwift
import GitHub

struct GitHubPresenter {

    let searchText = Variable("")
    let disposeBag = DisposeBag()

    static func getRepositories(gitHubID : String, completion : @escaping ((_ repos : Observable<[GHUserRepo]>) ->())) {
        GitHubProvider.fetchRepositories(userId: gitHubID) { (status, repos, error) in
            if status {
                let observableRepos = Observable.just(repos)
                completion(observableRepos)
            }
        }
        
    }
}
