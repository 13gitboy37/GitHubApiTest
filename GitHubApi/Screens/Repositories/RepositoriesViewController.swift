//
//  RepositoriesViewController.swift
//  GitHubApi
//
//  Created by Никита Мошенцев on 28.09.2022.
//

import UIKit

protocol RepositoriesViewProtocol: AnyObject {
    func showRepositories(repositories: [Repository])
}

class RepositoriesViewController: UIViewController {
    
    //MARK: Properties
    
    var presenter: RepositoriesPresenterProtocol?
    
    private var timer = Timer()
    
    private var repositories = [Repository]() {
        didSet {
            DispatchQueue.main.async {
                self.repositoriesView.tableView.reloadData()
            }
        }
    }
    
    private var repositoriesView: RepositoriesView {
        return view as! RepositoriesView
    }
    
    //MARK: Lifecycle
    
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
    
    //MARK: Methods
    
    private func setAlertController() {
        let alertController = UIAlertController(
            title:
                "No results",
            message:
                "No repositories found. Enter your request again.",
            preferredStyle: .alert)
        
        let alertOK = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(alertOK)
        present(alertController, animated: true, completion: nil)
    }
}


//MARK: Table View Delegate and Data Source

extension RepositoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter?.openSafari(url: "\(repositories[indexPath.row].htmlUrl)")
    }
}

extension RepositoriesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repositories.count
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

//MARK: Prefetching

extension RepositoriesViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        self.presenter?.startPrefetching(indexPaths: indexPaths, repositoriesCount: repositories.count)
    }
}

//MARK: Search Bar Delegate

extension RepositoriesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            
            if !searchText.isEmpty {
                self.presenter?.textDidChanged(searchText: searchText)
            } else {
                self.repositories = []
            }
        })
    }
}

extension RepositoriesViewController: RepositoriesViewProtocol {
    
    func showRepositories(repositories: [Repository]) {
        DispatchQueue.main.async {
            self.repositories.append(contentsOf: repositories)
            if repositories.isEmpty {
                self.setAlertController()
            }
        }
    }
}
