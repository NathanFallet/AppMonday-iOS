//
//  UIImageExtension.swift
//  AppMonday
//
//  Created by Nathan FALLET on 12/02/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    static var cache = NSCache<NSString, UIImage>()
    
    func loadImage(url: String) {
        let imageUrl = URL(string: url)!
        
        if let imageFromCache = UIImageView.cache.object(forKey: imageUrl.absoluteString as NSString) {
            self.image = imageFromCache
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let imageData:NSData = NSData(contentsOf: imageUrl) else {
                DispatchQueue.main.async {
                    let image = UIImage(named: "NoLogo")!
                    UIImageView.cache.setObject(image, forKey: imageUrl.absoluteString as NSString)
                    self.image = image
                }
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: imageData as Data)!
                UIImageView.cache.setObject(image, forKey: imageUrl.absoluteString as NSString)
                self.image = image
            }
        }
    }
    
}
