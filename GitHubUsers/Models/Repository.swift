//
//  Repository.swift
//  GitHubUsers
//
//  Created by Marco Guevara on 20/01/24.
//

import Foundation

struct Repository: Codable {
    let name: String
    let fullName: String
    let description: String?
    let htmlURL: URL
    let stargazersCount: Int
    let forksCount: Int
    let language: String?

    enum CodingKeys: String, CodingKey {
        case name
        case fullName = "full_name"
        case description
        case htmlURL = "html_url"
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
        case language
    }
}
