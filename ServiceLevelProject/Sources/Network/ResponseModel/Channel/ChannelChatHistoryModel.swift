//
//  ChannelChatHistoryModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/22/24.
//

import Foundation

struct ChannelChatHistoryModel: Decodable {
    let channelID: String
    let channelName: String
    let chatID: String
    let content: String
    let createdAt: String
    let files: [String]
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case chatID = "chat_id"
        case channelName, content, createdAt, files, user
    }
    
    struct User: Decodable {
        let userID: String
        let email: String
        let nickname: String
        let profileImage: String
        
        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case email, nickname, profileImage
        }
    }
}