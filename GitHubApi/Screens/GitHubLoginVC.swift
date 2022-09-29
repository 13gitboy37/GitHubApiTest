//
//  ViewController.swift
//  GitHubApi
//
//  Created by Никита Мошенцев on 28.09.2022.
//

import UIKit
import WebKit
import SnapKit

final class GitHubLoginVC: UIViewController {
    var webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        return webView
    } ()
    
    private var urlComponents: URLComponents = {
        var comp = URLComponents()
        comp.scheme = "https"
        comp.host = "github.com"
        comp.path = "/login/oauth/authorize"
        comp.queryItems = [
            URLQueryItem(name: "client_id", value: "a492a03a8a5db45e2c2b")
        ]
        return comp
    }()
    
    private func configureUI() {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        configureUI()
        guard
            let url = urlComponents.url
        else { return }
        webView.load(URLRequest(url: url))
        
    }
}

extension GitHubLoginVC: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            
            guard
                let url = navigationResponse.response.url,
                url.path == "/callback",
                let fragment = url.query
            else { return decisionHandler(.allow)}
            
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
            else { return decisionHandler(.allow) }
            
            let networkService = NetworkService()
            networkService.exchangeCodeForAccessToken(code: code) { result in
                switch result {
                case .success(let accessToken):
                    UserSession.instance.token = accessToken
                    DispatchQueue.main.async {
                        let repositoriesViewController = RepositoriesViewController()
                        repositoriesViewController.modalPresentationStyle = .fullScreen
                        self.present(repositoriesViewController, animated: true)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            decisionHandler(.cancel)
        }
}
