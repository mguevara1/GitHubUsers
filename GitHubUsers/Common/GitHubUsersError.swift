//
//  GitHubUsersError.swift
//  GitHubUsers
//
//  Created by Marco Guevara on 21/01/24.
//

enum GitHubUsersError: Error, Equatable {
    case ServerFailure(String)
    case UnhandledFailure
}
