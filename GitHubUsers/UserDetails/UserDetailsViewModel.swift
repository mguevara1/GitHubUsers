//
//  UserDetailsViewModel.swift
//  GitHubUsers
//
//  Created by Marco Guevara on 19/01/24.
//

import Foundation
import Combine

class UserDetailsViewModel {
    private let gitHubClient: GitHubClient
    @Published var avatarUrl: URL
    @Published var selectedUser: User?
    var detailItems: [UserDetailsItem]?
    let username: String

    init(gitHubClient: GitHubClient, username: String, avatarUrl: URL) {
        self.gitHubClient = gitHubClient
        self.username = username
        self.avatarUrl = avatarUrl
    }
    
    func getUserDetails(username: String) {
        Task {
            do {
                try await getUserDetails(username: username)
            } catch {
                print("Error searching users: \(error)")
            }
        }
    }
    
    private func getUserDetails(username: String) async throws {
        let user = try await gitHubClient.getUserDetails(username: username)
        self.selectedUser = user
    }
}
