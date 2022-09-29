//
//  AccessToken.swift
//  GitHubApi
//
//  Created by Никита Мошенцев on 29.09.2022.
//

import Foundation

struct Repository {
    let name: String
    let owner: Owner
    let language: String?
    let htmlUrl: String
}

extension Repository: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case owner
        case language
        case htmlUrl = "html_url"
    }
}
