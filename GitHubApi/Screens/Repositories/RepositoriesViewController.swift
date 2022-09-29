//
//  RepositoriesViewController.swift
//  GitHubApi
//
//  Created by Никита Мошенцев on 28.09.2022.
//

import UIKit

class RepositoriesViewController: UIViewController {
    
    private let networkService = NetworkService()
    
    private var timer = Timer()
    
    private var isLoading: Bool = false
    
    private var searchText = ""
    
    private var countPageForSearch = 0
    
    private var repositories = [Repository]() {
        didSet {
            DispatchQueue.main.async {
                self.repositoriesView.tableView.isHidden = false
                self.repositoriesView.tableView.reloadData()
            }
        }
    }
    
    private var repositoriesView: RepositoriesView {
        return view as! RepositoriesView
    }
    
    override func loadView() {
        super.loadView()
        self.view = RepositoriesView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repositoriesView.tableView.delegate = self
        repositoriesView.tableView.dataSource = self
        repositoriesView.searchBar.delegate = self
        repositoriesView.tableView.prefetchDataSource = self
        
        repositoriesView.tableView.register(RepositriesCell.self,
                                            forCellReuseIdentifier: "reuseId")
        
    }
}

extension RepositoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(1)
    }
}

extension RepositoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
//        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentRepo = repositories[indexPath.row]
        
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "reuseId", for: indexPath)
        
        guard let cell = dequeuedCell as? RepositriesCell else {
            return dequeuedCell
        }
        
        cell.configure(with: currentRepo)
        return cell
    }
}

extension RepositoriesViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        guard let maxRow = indexPaths.map({ $0.row }).max() else { return }
        
        if maxRow > repositories.count - 3, !isLoading {
            isLoading = true
            self.countPageForSearch += 1
            networkService.searchRepos(searchText: self.searchText, page: "\(self.countPageForSearch)") { result in
                switch result {
                case .success(let repos):
                    
                    self.repositories.append(contentsOf: repos.items ?? [])
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        isLoading = false
    }
    }
    
    

extension RepositoriesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.countPageForSearch = 1
        self.searchText = searchText
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {_ in
            
            self.networkService.searchRepos(searchText: searchText, page: "\(self.countPageForSearch)") { result in
                switch result {
                case .success(let repos):
                    self.repositories = repos.items ?? []
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        })
    }
}
