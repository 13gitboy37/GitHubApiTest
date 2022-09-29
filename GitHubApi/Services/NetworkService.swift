//
//  NetworkService.swift
//  GitHubApi
//
//  Created by Никита Мошенцев on 29.09.2022.
//

import Foundation

final class NetworkService {
    
    lazy var mySession = URLSession(configuration: configuration)
    
    let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10.0
        return config
    }()
    
    private var urlConstructor: URLComponents = {
        var constructor = URLComponents()
        constructor.scheme = "https"
        constructor.host = "github.com"
        return constructor
    }()
    
    func exchangeCodeForAccessToken(code: String,
                                    completion: @escaping (Result<String,Error>) -> Void) {
        
        //            https://github.com/login/oauth/access_token
        
        urlConstructor.path = "/login/oauth/access_token"
        urlConstructor.queryItems = [
            URLQueryItem(name: "client_id", value: "a492a03a8a5db45e2c2b"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "client_secret", value: "affb09b18f3d51eef826c5d9c9a3229609fa2fb0")
        ]
        guard
            let url = urlConstructor.url
        else { return }
        let task = mySession.dataTask(with: url) { data, response, error in
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
            guard
                error == nil,
                let data = data
            else { return }
            do {
                let string = String(data: data, encoding: .utf8)
                let parameters = string?
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
                completion(.success(parameters?["access_token"] ?? ""))
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func searchRepos(searchText: String,
                     page: String,
                     completion: @escaping (Result<Items,Error>) -> Void) {
        
        //            https://api.github.com/search/repositories?q=repo&per_page=2&page=1
        urlConstructor.host = "api.github.com"
        urlConstructor.path = "/search/repositories"
        urlConstructor.queryItems = [
            URLQueryItem(name: "q", value: searchText),
            URLQueryItem(name: "per_page", value: "20"),
            URLQueryItem(name: "page", value: page)
        ]
        guard
            let url = urlConstructor.url
        else { return }
        let task = mySession.dataTask(with: url) { data, response, error in
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
            guard
                error == nil,
                let data = data
            else { return }
            do {
                let repoResponse = try JSONDecoder().decode(Items.self, from: data)
                completion(.success(repoResponse))
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

