//
//  message.swift
//  Cap_stone
//
//  Created by 박성민 on 6/27/24.
//

import Foundation

struct Message: Codable, Identifiable {
    var id: Int? // id는 옵셔널로 설정
    var chatId: Int
    var authorId: Int
    var content: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case chatId
        case authorId
        case content = "message"
    }
}

