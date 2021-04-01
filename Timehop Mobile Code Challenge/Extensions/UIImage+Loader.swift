//
//  UIImage+Loader.swift
//  Timehop Mobile Code Challenge
//
//  Created by Brian Lim on 3/31/21.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImage(with urlStr: String) {
        guard let validURL = URL(string: urlStr) else { return }
        self.image = nil
        
        guard let cachedImage = imageCache.object(forKey: urlStr as NSString) else {
            URLSession.shared.dataTask(with: validURL) { (data, response, error) in
                guard error == nil, let data = data else { return }
                DispatchQueue.main.async {
                    if let downloadedImage = UIImage(data: data) {
                        imageCache.setObject(downloadedImage, forKey: urlStr as NSString)
                        self.image = downloadedImage
                    }
                }
            }
            .resume()
            return
        }
        self.image = cachedImage
    }
}
