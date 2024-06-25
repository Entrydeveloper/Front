//
//  User.swift
//  Cap_stone
//
//  Created by 박성민 on 6/21/24.
//

import Foundation

struct UserIdResponse: Codable {
    let success: Bool
    let body: Body
    
    struct Body: Codable {
        let userId: UserId
    }
    
    struct UserId: Codable {
        let payload: Int
    }
}

struct UserResponse: Codable {
    let success: Bool
    let body: UserBody
    
    struct UserBody: Codable {
        let id: Int
        let username: String
        let email: String
        let role: String
    }
}
