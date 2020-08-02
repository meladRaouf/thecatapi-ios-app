//
//  ApiConstants.swift
//  Cats
//
//  Created by Melad on 8/1/20.
//  Copyright © 2020 gini. All rights reserved.
//

import Foundation
import Alamofire
struct ApiConstants {
    static let baseURL = "https://api.thecatapi.com/v1"
    static let apiKey = "ea83bf0d-fda5-4979-bdb1-f064ad815821"
    static let authHeader = HTTPHeader(name: "x-api-key", value: apiKey)
    struct EndPoints {
        static let randomImages =  "\(baseURL)/images/search"
        static let favourites = "\(baseURL)/favourites/"
    }
    struct DefaultValues {
        static let imagesLimit = "20"
        static let subId = "demo_account"
    }
    struct Params {
        static let limit = "limit"
        static let imageId = "image_id"
        static let subId = "sub_id"
    }
    struct Status {
        static let success = "SUCCESS"
    }
}
struct UIConstants {
    static let catImageCell = "CatImageCell"
    static let numberOfColumonsPortrait = 2
    static let numberOfColumonsLandscape = 4
    static let cellPadding = 6
    struct  FavouriteText {
        static let addToFavourite = "Favourite 👍"
        static let unFavourite = "Unfavourite 👎"
    }
}
