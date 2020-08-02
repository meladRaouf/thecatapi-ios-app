//
//  CatImageCell.swift
//  Cats
//
//  Created by Melad on 8/1/20.
//  Copyright © 2020 gini. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class CatImageCell: UICollectionViewCell {
    @IBOutlet weak var favouriteLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func prepareForReuse() {
        imageView.image = nil
    }
    func bind(imageUrl: String?, isFavourite: Bool) {
        imageView.setImageFromUrl(imageUrl,shouldCache: isFavourite) // cache favorite images only
        if isFavourite {
            favouriteLabel.text = UIConstants.FavouriteText.unFavourite
        } else {
            favouriteLabel.text =  UIConstants.FavouriteText.addToFavourite
        }
    }
}
