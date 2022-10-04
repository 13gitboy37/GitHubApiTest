//
//  GitHubLoginInteractor.swift
//  GitHubApi
//
//  Created by Никита Мошенцев on 30.09.2022.
//

import Foundation
import WebKit

protocol GitHubLoginInteractorProtocol: AnyObject {
    func loadWebView()
    
    func exchangeAccessToken(with navigationResponse: WKNavigationResponse)
}

class GitHubLoginInteractor: GitHubLoginInteractorProtocol {
    
    weak var presenter: GitHubLoginPresenterProtocol?
    
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func loadWebView()  {
        
        let urlComponents: URLComponents = {
            var comp = URLComponents()
            comp.scheme = "https"
            comp.host = "github.com"
            comp.path = "/login/oauth/authorize"
            comp.queryItems = [
                URLQueryItem(name: "client_id", value: "a492a03a8a5db45e2c2b")
            ]
            return comp
        }()
        
        guard
            let url = urlComponents.url ?? URL(string: "")
        else { return }
        
        self.presenter?.didCreateUrlRequest(URLRequest: URLRequest(url: url))
    }
    
    func exchangeAccessToken(with navigationResponse: WKNavigationResponse) {
        
        guard
            let url = navigationResponse.response.url,
            url.path == "/callback",
            let fragment = url.query
        else { return }
        
        let parameters = fragment
            .components(separatedBy: "&")
            .map{ $0.components(separatedBy: "=") }
            .reduce( [String: String]()){
                partialResult, params in
                var dict = partialResult
                let key = params[0]
                let value = params[1]
                dict[key] = value
                return dict
            }
        
        guard
            let code = parameters["code"]
        else { return }
        
        let networkService = NetworkService()
        networkService.exchangeCodeForAccessToken(code: code) { result in
            switch result {
            case .success(let accessToken):
                UserSession.instance.token = accessToken
                DispatchQueue.main.async {
                    self.presenter?.cancelNavigationWebView = true
                    self.presenter?.didExchangeAccessToken()
                }
            case .failure(let error):
                self.presenter?.cancelNavigationWebView = false
                print(error.localizedDescription)
            }
        }
    }
}
