//
//  UserSearchResponse.swift
//  GitHubUsers
//
//  Created by Marco Guevara on 20/01/24.
//

struct UserSearchResponse: Decodable {
    let items: [User]
}
