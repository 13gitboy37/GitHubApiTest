//
//  GitHubLoginModuleBuilder.swift
//  GitHubApi
//
//  Created by Никита Мошенцев on 30.09.2022.
//

import UIKit

class GitHubLoginBuilder {
    static func build() -> UIViewController {
        
        let networkService = NetworkService()
        
        let interactor = GitHubLoginInteractor(networkService: networkService)
        let router = GitHubLoginRouter()
        let presenter = GitHubLoginPresenter(interactor: interactor,
                                             router: router)
        let viewController = GitHubLoginViewController()
        viewController.presenter = presenter
        presenter.gitHubLoginView = viewController
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
