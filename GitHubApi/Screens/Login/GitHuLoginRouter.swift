//
//  GitHuLoginRouter.swift
//  GitHubApi
//
//  Created by Никита Мошенцев on 30.09.2022.
//

import Foundation

protocol GitHubLoginRouterProtocol: AnyObject {
    func goToRepositoriesView()
}

class GitHubLoginRouter: GitHubLoginRouterProtocol {
    
    weak var viewController: GitHubLoginViewController?
    
    func goToRepositoriesView() {
        let repositoriesViewController = RepositoriesBuilder.build()
        repositoriesViewController.modalPresentationStyle = .fullScreen
        
        self.viewController?.presentRepositoriesView(viewController: repositoriesViewController)
    }
    
    
}
