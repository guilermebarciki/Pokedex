//
//  UIImageView+Extensions.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 29/07/24.
//

import Foundation
import UIKit

extension UIImageView {
    
    private static let cachedImage = NSCache<NSString,UIImage>()
    
    func loadImage(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let key = urlString as NSString
        
           if let image = UIImageView.cachedImage.object(forKey: key) {
            self.image = image
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
            if let data, let image = UIImage(data: data) {
                UIImageView.cachedImage.setObject(image, forKey: key)
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }.resume()
        
    }
}
