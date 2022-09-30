//
//  UserSession.swift
//  GitHubApi
//
//  Created by Никита Мошенцев on 28.09.2022.
//

import Foundation

class UserSession {
    
    var token: String = ""
    var userID: Int = 0
    
   static let instance = UserSession()
    
    private init() {
        
    }
}
