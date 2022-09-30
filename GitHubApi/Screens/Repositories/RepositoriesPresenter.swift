//
//  RepositoriesPresenter.swift
//  GitHubApi
//
//  Created by Никита Мошенцев on 29.09.2022.
//

import Foundation
import UIKit

protocol RepositoriesPresenterProtocol: AnyObject {
    
    var repositories: [Repository] { get set }
    func textDidChanged(searchText: String)
    func startPrefetching(indexPaths: [IndexPath])
    func didLoadRepositories(repositories: [Repository])
    func numberOfRows() -> Int
    func setCell(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func openSafari(indexPath: IndexPath)
    
}

class RepositoriesPresenter {
    
    var repositories: [Repository] = [] {
        didSet {
            repositoriesView?.reloadTableView()
        }
    }
    
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
    
    func numberOfRows() -> Int {
        repositories.count
    }
    
    func setCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "reuseId", for: indexPath)
        
        let currentRepo = repositories[indexPath.row]
        
        guard
            let cell = dequeuedCell as? RepositriesCell
        else { return UITableViewCell()}
        
        cell.configure(with: currentRepo)
        return cell
    }
    
    func textDidChanged(searchText: String) {
        if searchText.isEmpty {
            repositories = []
        } else {
            interactor.loadRepositories(text: searchText)
        }
    }
    
    func startPrefetching(indexPaths: [IndexPath]) {
        interactor.loadRepositoriesForPrefatching(indexPaths: indexPaths)
    }
    
    func didLoadRepositories(repositories: [Repository]) {
        if repositories.isEmpty {
            DispatchQueue.main.async {
                self.repositoriesView?.setAlertController()
            }
        } else {
            self.repositories.append(contentsOf: repositories)
        }
    }
    
    func openSafari(indexPath: IndexPath) {
        router.openSafari(url: repositories[indexPath.row].htmlUrl)
    }
}
