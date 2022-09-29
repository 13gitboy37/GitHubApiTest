//
//  Owner.swift
//  GitHubApi
//
//  Created by Никита Мошенцев on 29.09.2022.
//

import Foundation

struct Owner {
    let login: String
    let avatarUrl: String
}

extension Owner: Codable {
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
}
