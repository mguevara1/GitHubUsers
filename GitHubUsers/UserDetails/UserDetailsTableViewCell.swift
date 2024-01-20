//
//  UserDetailsTableViewCell.swift
//  GitHubUsers
//
//  Created by Marco Guevara on 19/01/24.
//

import UIKit

class UserDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 0
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
