//
//  User.swift
//  GitHubUsers
//
//  Created by Marco Guevara on 17/01/24.
//

import Foundation

struct User: Decodable {
    
    let login: String
    let id: Int
    let nodeId: String
    let avatarURL: URL
    let gravatarId: String
    let url, htmlURL, followersURL: URL
    let followingURL, gistsURL, starredURL: String
    let subscriptionsURL, organizationsURL, reposURL: URL
    let receivedEventsURL: String
    let siteAdmin: Bool
    let name: String?
    let company: String?
    let email: String?
    let publicRepos, publicGists, followers, following: Int?
    let createdAt, updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeId = "node_id"
        case avatarURL = "avatar_url"
        case gravatarId = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case receivedEventsURL = "received_events_url"
        case siteAdmin = "site_admin"
        case name, company, email
        case publicRepos = "public_repos"
        case publicGists = "public_gists"
        case followers, following
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
