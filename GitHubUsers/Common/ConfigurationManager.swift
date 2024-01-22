//
//  ConfigurationManager.swift
//  GitHubUsers
//
//  Created by Marco Guevara on 19/01/24.
//

import Foundation

struct Configuration: Decodable {
    let githubToken: String
}

class ConfigurationManager {
    static func loadConfig() -> Configuration? {
        
        if let url = Bundle.main.url(forResource: "config", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let config = try? JSONDecoder().decode(Configuration.self, from: data) {
            return config
        }
        
        return nil
    }
}
