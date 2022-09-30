//
//  RepositoriesPresenter.swift
//  GitHubApi
//
//  Created by Никита Мошенцев on 29.09.2022.
//

import Foundation

protocol RepositoriesPresenterProtocol: AnyObject {
    
    func textDidChanged(searchText: String)
    func startPrefetching(indexPaths: [IndexPath], repositoriesCount: Int)
    func didLoadRepositories(repositories: [Repository])
    func openSafari(url: String)
    
}

class RepositoriesPresenter {
    
    weak var repositoriesView: RepositoriesViewProtocol?
    var router: RepositoriesRouterProtocol
    var interactor: RepositoriesInteractorProtocol
    
    init(interactor: RepositoriesInteractorProtocol,
         router: RepositoriesRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension RepositoriesPresenter: RepositoriesPresenterProtocol {
    
    func textDidChanged(searchText: String) {
        interactor.loadRepositories(text: searchText)
    }
    
    func startPrefetching(indexPaths: [IndexPath], repositoriesCount: Int) {
        interactor.loadRepositoriesForPrefatching(indexPaths: indexPaths, repositoriesCount: repositoriesCount)
    }
    
    func didLoadRepositories(repositories: [Repository]) {
        repositoriesView?.showRepositories(repositories: repositories)
    }
    
    func openSafari(url: String) {
        router.openSafari(url: url)
    }
}
