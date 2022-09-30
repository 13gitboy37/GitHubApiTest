//
//  ViewController.swift
//  GitHubApi
//
//  Created by Никита Мошенцев on 28.09.2022.
//

import UIKit
import WebKit

protocol GitHubLoginViewProtocol: AnyObject {
    func loadWebView(URLRequest: URLRequest)
    func presentRepositoriesView(viewController: UIViewController)
}

final class GitHubLoginViewController: UIViewController {
    
    //MARK: Properties
    var presenter: GitHubLoginPresenterProtocol?
  
    private var loginView: LoginView {
        return view as! LoginView
    }
    
    //MARK: Lifecucle
    override func loadView() {
        super.loadView()
        self.view = LoginView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.webView.navigationDelegate = self
        self.presenter?.createUrlRequest()
    }
}

//MARK: WebViewDelegate
extension GitHubLoginViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {            
            self.presenter?.startExchangeAccessToken(with: navigationResponse)
            decisionHandler(.cancel)
        }
}

//MARK: Release GitHubLoginProtocol
extension GitHubLoginViewController: GitHubLoginViewProtocol {
    
    func loadWebView(URLRequest: URLRequest) {
        loginView.webView.load(URLRequest)
    }
    
    func presentRepositoriesView(viewController: UIViewController) {
        self.present(viewController, animated: true)
    }
}
