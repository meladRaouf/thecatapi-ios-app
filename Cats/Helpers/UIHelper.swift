//
//  UIHelper.swift
//  Cats
//
//  Created by imac on 8/2/20.
//  Copyright © 2020 gini. All rights reserved.
//

import Foundation
import UIKit
class UIHelper {
   static func toggleActivityIndicator(activityIndicator: UIActivityIndicatorView, isHidden: Bool) {
        activityIndicator.isHidden = isHidden
        if isHidden {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
    }
}
