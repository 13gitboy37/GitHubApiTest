//
//  GitHubLoginPresenter.swift
//  GitHubApi
//
//  Created by Никита Мошенцев on 30.09.2022.
//

import Foundation
import WebKit

protocol GitHubLoginPresenterProtocol: AnyObject {
    var cancelNavigationWebView: Bool { get set }
    func createUrlRequest()
    func didCreateUrlRequest(URLRequest: URLRequest)
    func startExchangeAccessToken(with navigationResponse: WKNavigationResponse)
    func didExchangeAccessToken()
}

class GitHubLoginPresenter: GitHubLoginPresenterProtocol {
    
    var cancelNavigationWebView: Bool = false
    
    weak var gitHubLoginView: GitHubLoginViewProtocol?
    var router: GitHubLoginRouterProtocol
    var interactor: GitHubLoginInteractorProtocol
    
    init(interactor: GitHubLoginInteractorProtocol,
         router: GitHubLoginRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func createUrlRequest() {
        self.interactor.loadWebView()
    }
    
    func didCreateUrlRequest(URLRequest: URLRequest) {
        self.gitHubLoginView?.loadWebView(URLRequest: URLRequest)
    }
    
    func startExchangeAccessToken(with navigationResponse: WKNavigationResponse) {
        self.interactor.exchangeAccessToken(with: navigationResponse)
    }
    
    func didExchangeAccessToken() {
        self.router.goToRepositoriesView()
    }
}
