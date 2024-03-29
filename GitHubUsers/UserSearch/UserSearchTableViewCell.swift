//
//  UserSearchTableViewCell.swift
//  GitHubUsers
//
//  Created by Marco Guevara on 19/01/24.
//

import UIKit

class UserSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.layer.cornerRadius = avatarImageView.bounds.width/2
        }
    }
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var arrowImageView: UIImageView! {
        didSet {
            let arrowImage = UIImage(systemName: "chevron.right")
            arrowImageView.image = arrowImage
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
