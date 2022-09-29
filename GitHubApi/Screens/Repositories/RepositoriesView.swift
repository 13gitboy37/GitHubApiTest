//
//  RepositoriesView.swift
//  GitHubApi
//
//  Created by Никита Мошенцев on 29.09.2022.
//

import UIKit
import SnapKit

class RepositoriesView: UIView {
    private(set) lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 72.0
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 0.0)
        tableView.isHidden = true
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.backgroundColor = .white
        self.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.safeAreaLayoutGuide)
        }
        
        self.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).inset(5)
            make.bottom.left.right.equalToSuperview()
        }
    }
}
