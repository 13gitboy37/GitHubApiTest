//
//  RepositoriesInteractor.swift
//  GitHubApi
//
//  Created by Никита Мошенцев on 29.09.2022.
//

import Foundation

protocol RepositoriesInteractorProtocol: AnyObject {

    var searchText: String { get set }
    func loadRepositories(text: String)
    func loadRepositoriesForPrefatching(indexPaths: [IndexPath])
    
}

class RepositoriesInteractor: RepositoriesInteractorProtocol {

    weak var presenter: RepositoriesPresenterProtocol?
    
    let networkService: NetworkService
    
    var searchText: String = ""
    
    private var isLoading: Bool = false
    
    private var countPageForSearch: Int = 1
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func loadRepositories(text: String) {
        
        self.networkService.searchRepos(searchText: text, page: "\(self.countPageForSearch)") { [weak self] result in
            
            self?.searchText = text
            
            self?.countPageForSearch = 1
            
            switch result {
            case .success(let repos):
                
                guard let repositories = repos.items else { return }
                
                if !text.isEmpty {
                    self?.repositories = repositories
                } else {
                    self?.repositories = []
                }
                
                self?.presenter?.didLoadRepositories(repositories: repositories)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func loadRepositoriesForPrefatching(indexPaths: [IndexPath]) {
        guard let maxRow = indexPaths.map({ $0.row }).max() else { return }
        
        if maxRow > (self.presenter?.repositories.count ?? 0) - 3, !isLoading {
            isLoading = true
            self.countPageForSearch += 1
            networkService.searchRepos(searchText: self.searchText, page: "\(self.countPageForSearch)") { result in
                switch result {
                case .success(let repos):
                    
                    guard let repositories = repos.items else { return }
                    self.presenter?.repositories.append(contentsOf: repositories)
                    
                    self.presenter?.didLoadRepositories(repositories: repos.items ?? [])
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        isLoading = false
    }
}
