//
//  ViewModel.swift
//  GitHubUsers
//
//  Created by Marco Guevara on 17/01/24.
//

import Foundation

class UserSearchViewModel {
    let gitHubClient: GitHubClient
    @Published var users: [User]?

    init(gitHubClient: GitHubClient) {
        self.gitHubClient = gitHubClient
    }

    func searchUsers(query: String) {
        Task {
            do {
                try await fetchUsers(query: query)
            } catch {
                print("Error searching users: \(error)")
            }
        }
    }

    private func fetchUsers(query: String) async throws {
        let users = try await gitHubClient.searchUsers(query: query)
        self.users = users
    }
}
