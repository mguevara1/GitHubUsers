//
//  UIImageView+Extensions.swift
//  GitHubUsers
//
//  Created by Marco Guevara on 19/01/24.
//

import UIKit

extension UIImageView {
    
    func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error)")
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
}
