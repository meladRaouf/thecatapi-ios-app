//
//  ImageHelper.swift
//  Cats
//
//  Created by Melad on 8/1/20.
//  Copyright © 2020 gini. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView{
    func setImageFromUrl(_ imageUrl: String?,shouldCache:Bool) {
        guard let url = imageUrl  else {
            return
        }
        var options: KingfisherOptionsInfo? =  [.transition(.fade(0.2))]
        if !shouldCache {
            options?.append(.cacheMemoryOnly) // if shouldn't cache the image then use memory cache only
        }
        self.kf.setImage(with: URL(string: url), options:options)
        
    }
}

