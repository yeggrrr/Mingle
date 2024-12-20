//
//  APIQuery.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/11/24.
//

import UIKit

// MARK: ValidationEmail
struct ValidationEmailQuery: Encodable {
    let email: String
}

// MARK: SignUp
struct SignUpQuery: Encodable {
    let email: String
    let password: String
    let nickname: String
    let phone: String
    let deviceToken: String
}

// MARK: WorkspaceCreate
struct WorkspaceCreateQuery: Encodable {
    let name: String?
    let description: String?
    let image: Data?
}
// MARK: WorkspaceMember Invite
struct WorkspaceMemberQuery: Encodable {
    let email: String
}

// MARK: WorkspaceOwner Change & ChannelOwner Change
struct OwnerQuery: Encodable {
    let owner_id: String
}

// MARK: Login
struct LoginQuery: Encodable {
    let email: String
    let password: String
    let deviceToken: String
}

// MARK: Add & Edit
struct ChannelQuery: Encodable {
    let name: String
    let description: String?
    let image: Data?
}

// MARK: EditProfileImage
struct ProfileImageQuery: Encodable {
    let image: Data
}

// MARK: EditNickname
struct EditNicknameQuery: Encodable {
    let nickname: String
}

// MARK: EditPhoneNumber
struct EditPhoneNumberQuery: Encodable {
    let phone: String
}

// MARK: Chatting
struct ChattingQuery: Encodable {
    let content: String
    let files: [Data?]
}

// MARK: Create DM
struct CreateDMQuery: Encodable {
    let opponent_id: String
}
