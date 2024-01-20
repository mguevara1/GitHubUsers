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
    @Published var searchText: String

    init(gitHubClient: GitHubClient) {
        self.gitHubClient = gitHubClient
        searchText = ""
    }

    func searchUsers(query: String) {
        if query.isEmpty {
            self.users = []
            return
        }
        
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
