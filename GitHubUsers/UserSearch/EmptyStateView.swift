//
//  EmptyStateView.swift
//  GitHubUsers
//
//  Created by Marco Guevara on 20/01/24.
//

import Foundation
import UIKit

class EmptyStateView: UIView {
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "No users found. Start searching!"
        label.textAlignment = .center
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func setMessage(_ message: String) {
        messageLabel.text = message
    }
}
