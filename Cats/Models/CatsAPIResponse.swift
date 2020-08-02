//
//  Cat.swift
//  Cats
//
//  Created by Melad on 8/1/20.
//  Copyright © 2020 gini. All rights reserved.
//

import Foundation

// MARK: - Cat
struct Cat: Codable {
    let id: String?
    let url: String?
    var favourite: Favourite?
    mutating func setFavoriteId(_ favouriteId: Int?) {
        if favouriteId == nil {
            self.favourite = nil
        } else {
            self.favourite = Favourite(favouriteId, imageId: id)
        }
    }
}

// MARK: - Favourite
struct Favourite: Codable {
    let id: Int?
    let image: Image?
    let imageID: String?    
    init(_ id: Int?, imageId: String?) {
        self.id = id
        self.imageID = imageId
        self.image = nil
    }
    enum CodingKeys: String, CodingKey {
        case id, image
        case imageID
    }
}

// MARK: - Image
struct Image: Codable {
    let url: String?
    let id: String?
}
// MARK: - AddFavouriteResponse
struct AddFavouriteResponse: Codable {
    let id: Int?
    let message: String?
}

// MARK: - DeleteFavouriteResponse
struct DeleteFavouriteResponse: Codable {
    let message: String?
}

typealias Cats = [Cat]
typealias Favourites = [Favourite]
