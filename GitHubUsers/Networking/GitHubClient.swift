//
//  GitHubClient.swift
//  GitHubUsers
//
//  Created by Marco Guevara on 17/01/24.
//

import Foundation
import Combine

class GitHubClient {
    let baseURL = "https://api.github.com"
    let accessToken: String

    init(accessToken: String) {
        self.accessToken = accessToken
    }

    func searchUsers(query: String) async throws -> [User] {
        let endpoint = "/search/users"
        let params = ["q": query]
        let data = try await makeRequest(endpoint: endpoint, params: params)
        let users = try JSONDecoder().decode(UserSearchResponse.self, from: data).items
        return users
    }

    func getUserDetails(username: String) async throws -> User {
        let endpoint = "/users/\(username)"
        let data = try await makeRequest(endpoint: endpoint)
        let user = try JSONDecoder().decode(User.self, from: data)
        return user
    }
    
    func getRepositories(url: URL) async throws -> [Repository] {
        let data = try await makeRequestFullUrl(url: url)
        let repositories = try JSONDecoder().decode([Repository].self, from: data)
        return repositories
    }

    private func makeRequest(endpoint: String, params: [String: String]? = nil) async throws -> Data {
        var components = URLComponents(string: baseURL + endpoint)
        components?.queryItems = params?.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = components?.url else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.addValue("token \(accessToken)", forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
    
    private func makeRequestFullUrl(url: URL) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.addValue("token \(accessToken)", forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}
