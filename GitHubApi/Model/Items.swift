//
//  Items.swift
//  GitHubApi
//
//  Created by Никита Мошенцев on 29.09.2022.
//

import Foundation


struct Items {
    let items: [Repository]?
}

extension Items: Codable {
    enum CodingKeys: String, CodingKey {
        case items
    }
}
