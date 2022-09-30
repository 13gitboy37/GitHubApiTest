//
//  RepositoriesRouter.swift
//  GitHubApi
//
//  Created by Никита Мошенцев on 29.09.2022.
//

import UIKit

protocol RepositoriesRouterProtocol: AnyObject {
    func openSafari(url: String)
}

class RepositoriesRouter: RepositoriesRouterProtocol {
    
    weak var viewController: RepositoriesViewController?
    
    func openSafari(url: String) {
        guard
            let url = URL(string: "\(url)")
        else { return }
        UIApplication.shared.open(url)
    }
}
