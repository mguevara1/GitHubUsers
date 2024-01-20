//
//  UserReposTableViewCell.swift
//  GitHubUsers
//
//  Created by Marco Guevara on 20/01/24.
//

import UIKit

class UserReposTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var starsLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.numberOfLines = 0
        }
    }
    
    
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
