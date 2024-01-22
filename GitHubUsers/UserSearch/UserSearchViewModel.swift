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
    @Published var isLoading: Bool = false
    @Published var error: GitHubUsersError?

    init(gitHubClient: GitHubClient) {
        self.gitHubClient = gitHubClient
        searchText = ""
    }

    func searchUsers(query: String) {
        if query.isEmpty {
            self.users = []
            return
        }
        
        isLoading = true
        
        Task {
            do {
                try await fetchUsers(query: query)
            } catch {
                debugPrint("\(CommonStrings.searchError): \(error)")
                self.error = GitHubUsersError.ServerFailure(CommonStrings.searchError)
            }
            isLoading = false
        }
    }

    private func fetchUsers(query: String) async throws {
        let users = try await gitHubClient.searchUsers(query: query)
        self.users = users
    }
}
