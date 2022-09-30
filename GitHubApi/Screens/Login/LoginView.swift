//
//  LoginView.swift
//  GitHubApi
//
//  Created by Никита Мошенцев on 28.09.2022.
//

import UIKit
import WebKit

class LoginView: UIView {
    
    private(set) lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        return webView
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
