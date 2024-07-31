//
//  UIImageView+Extensions.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 29/07/24.
//

import Foundation
import UIKit

extension UIImageView {
    
    private static let cachedImage = NSCache<NSString, UIImage>()
    
    func loadImage(urlString: String, placeholder: UIImage? = nil) {
        guard let url = URL(string: urlString) else {
            self.image = placeholder
            return
        }
        
        let key = urlString as NSString
        
        if let image = UIImageView.cachedImage.object(forKey: key) {
            self.image = image
            return
        }
        
        self.image = placeholder
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
            if let data, let image = UIImage(data: data) {
                UIImageView.cachedImage.setObject(image, forKey: key)
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }.resume()
    }
    
    func applySilhouette(isSilhouette: Bool) {
          guard let currentImage = self.image else { return }
          
          if isSilhouette {
              self.image = currentImage.silhouette
          } else {
              self.image = currentImage
          }
      }
    
}

extension UIImage {
    
    var silhouette: UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        
        let context = CIContext()
        let ciImage = CIImage(cgImage: cgImage)
        
        guard let filter = CIFilter(name: "CIColorMonochrome") else { return nil }
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(CIColor(color: .black), forKey: kCIInputColorKey)
        filter.setValue(1.0, forKey: kCIInputIntensityKey)
        
        guard let outputImage = filter.outputImage,
              let cgImageResult = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImageResult)
    }
}
