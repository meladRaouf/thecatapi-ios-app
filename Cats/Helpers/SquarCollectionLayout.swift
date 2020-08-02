//
//  SquarCollectionLayout.swift
//  Cats
//
//  Created by Melad on 8/1/20.
//  Copyright © 2020 gini. All rights reserved.
//

import Foundation
import UIKit

class SquarCollectionLayout: UICollectionViewFlowLayout {
    var containerWidth: CGFloat  {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    convenience override init() {
        self.init()
        self.minimumLineSpacing = CGFloat(UIConstants.cellPadding)
        self.minimumInteritemSpacing = CGFloat(UIConstants.cellPadding)
        self.configLayout()
    }
    
    func configLayout() {
        var columns =  UIConstants.numberOfColumonsPortrait
        if UIWindow.isLandscape {
            columns = UIConstants.numberOfColumonsLandscape
        }
        self.scrollDirection = .vertical
        let spacing = CGFloat(columns - 1) * minimumLineSpacing
        let optimisedWidth = (containerWidth - spacing) / CGFloat(columns)
        self.itemSize = CGSize(width: optimisedWidth , height: optimisedWidth) // keep as square
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        self.configLayout()
    }
}

extension UIWindow {
    static var isLandscape: Bool {
        return UIApplication.shared.windows
            .first?
            .windowScene?
            .interfaceOrientation
            .isLandscape ?? false
    }
}
