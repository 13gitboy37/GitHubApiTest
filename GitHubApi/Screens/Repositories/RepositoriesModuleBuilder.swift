//
//  RepositoriesBuilder.swift
//  GitHubApi
//
//  Created by Никита Мошенцев on 29.09.2022.
//

import UIKit

class RepositoriesBuilder {
    static func build() -> UIViewController {
        let networkService = NetworkService()
        
        let interactor = RepositoriesInteractor(networkService: networkService)
        let router = RepositoriesRouter()
        let presenter = RepositoriesPresenter(interactor: interactor,
                                              router: router)
        let viewController = RepositoriesViewController()
        viewController.presenter = presenter
        presenter.repositoriesView = viewController
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
