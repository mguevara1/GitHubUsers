//
//  UserDetailsViewModel.swift
//  GitHubUsers
//
//  Created by Marco Guevara on 19/01/24.
//

import Foundation
import Combine

class UserDetailsViewModel {
    let gitHubClient: GitHubClientProtocol
    @Published var avatarUrl: URL
    @Published var selectedUser: User?
    @Published var isLoading: Bool = false
    @Published var error: GitHubUsersError?
    var detailItems: [UserDetailsItem]?
    let username: String

    init(gitHubClient: GitHubClientProtocol, username: String, avatarUrl: URL) {
        self.gitHubClient = gitHubClient
        self.username = username
        self.avatarUrl = avatarUrl
    }
    
    func getUserDetails(username: String) {
        isLoading = true
        Task {
            do {
                try await getUserDetails(username: username)
            } catch {
                debugPrint("\(CommonStrings.detailsError): \(error)")
                self.error = GitHubUsersError.ServerFailure(CommonStrings.detailsError)
            }
            isLoading = false
        }
    }
    
    private func getUserDetails(username: String) async throws {
        let user = try await gitHubClient.getUserDetails(username: username)
        self.selectedUser = user
    }
}
