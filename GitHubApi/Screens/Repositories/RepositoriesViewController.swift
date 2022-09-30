//
//  RepositoriesViewController.swift
//  GitHubApi
//
//  Created by Никита Мошенцев on 28.09.2022.
//

import UIKit

protocol RepositoriesViewProtocol: AnyObject {
    func reloadTableView()
    func setAlertController()
}

class RepositoriesViewController: UIViewController {
    
    //MARK: Properties
    
    var presenter: RepositoriesPresenterProtocol?
    
    private var timer = Timer()
    
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
    
    func setAlertController() {
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
        self.presenter?.openSafari(indexPath: indexPath)
    }
}

extension RepositoriesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.presenter?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        presenter?.setCell(tableView, cellForRowAt: indexPath) ?? UITableViewCell()
    }
}

//MARK: Prefetching

extension RepositoriesViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        self.presenter?.startPrefetching(indexPaths: indexPaths)
    }
}

//MARK: Search Bar Delegate

extension RepositoriesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            self.presenter?.textDidChanged(searchText: searchText)
        })
    }
}

//MARK: Release RepositoriesViewProtocol

extension RepositoriesViewController: RepositoriesViewProtocol {
    func reloadTableView() {
        DispatchQueue.main.async {
            self.repositoriesView.tableView.reloadData()
        }
    }
}
