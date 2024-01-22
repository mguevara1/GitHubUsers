//
//  UserReposViewModel.swift
//  GitHubUsers
//
//  Created by Marco Guevara on 20/01/24.
//

import Foundation
import Combine

class UserReposViewModel {
    private let gitHubClient: GitHubClient
    let reposUrl: URL
    @Published var repositories: [Repository]?
    @Published var isLoading: Bool = false
    @Published var error: GitHubUsersError?

    init(gitHubClient: GitHubClient, reposUrl: URL) {
        self.gitHubClient = gitHubClient
        self.reposUrl = reposUrl
    }
    
    func getUserRepos(url: URL) {
        isLoading = true
        Task {
            do {
                try await getRepositories(url: url)
            } catch {
                debugPrint("\(CommonStrings.repositoriesError): \(error)")
                self.error = GitHubUsersError.ServerFailure(CommonStrings.repositoriesError)
            }
            isLoading = false
        }
    }
    
    private func getRepositories(url: URL) async throws {
        let repos = try await gitHubClient.getRepositories(url: url)
        self.repositories = repos
    }
}

