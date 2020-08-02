//
//  FavouriteCatImagesViewModel.swift
//  Cats
//
//  Created by imac on 8/2/20.
//  Copyright © 2020 gini. All rights reserved.
//

import Foundation

typealias FavouriteCatImagesCallBack = () -> Void
typealias DelteImageFromFavouritesCallBack = (Int, Bool) -> Void

protocol FavouriteCatImagesViewModelType {
    var favouriteCatImagesCallBack: FavouriteCatImagesCallBack? {get set}
    var delteImageFromFavouritesCallBack: DelteImageFromFavouritesCallBack? {get set}
    var errorCallback: ErrorCallback? { get set }
    var favorites: Favourites { get set }
    func getFavouriteCatImages()
}
class FavouriteCatImagesViewModel: FavouriteCatImagesViewModelType {
    private var favouriteCatImagesApi: GetFavouriteImagesAPI
    private var deleteFromFavoriteAPI: DeleteFromFavouriteAPI
    private var deleteCachedFavoriteImageService: DeleteCachedFavoriteImageServiceType

    var favouriteCatImagesCallBack: FavouriteCatImagesCallBack?
    var delteImageFromFavouritesCallBack: DelteImageFromFavouritesCallBack?
    var errorCallback: ErrorCallback?
    var favorites: Favourites
    init(
        favouriteCatImagesApi: GetFavouriteImagesAPI = GetFavouriteImagesService(),
        deleteFromFavoriteAPI: DeleteFromFavouriteAPI = DeleteFromFavouriteService(),
        deleteCachedFavoriteImageService: DeleteCachedFavoriteImageServiceType = DeleteCachedFavoriteImageService()) {
        favorites = []
        self.favouriteCatImagesApi = favouriteCatImagesApi
        self.deleteFromFavoriteAPI = deleteFromFavoriteAPI
        self.deleteCachedFavoriteImageService = deleteCachedFavoriteImageService
    }
}
// MARK: get favourite images
extension FavouriteCatImagesViewModel {
    func getFavouriteCatImages() {
        favouriteCatImagesApi.getFavouriteImages { [ weak self ]result in
            switch result {
            case .success(let response):
                self?.favorites = response
                self?.favouriteCatImagesCallBack?()
            case .failure(let error):
                self?.errorCallback?(error)
            }
        }
    }
}
// MARK: Delete image from favourites
extension FavouriteCatImagesViewModel {
    func deleteImageFromFavourites(imageIndex: Int) {
        let cat = favorites[imageIndex]
        guard let id = cat.id else {
            return
        }
        deleteFromFavoriteAPI.deleteImageFromFavourite(id) { [weak self] result  in
            switch result {
            case .success(let response):
                if response.message ==  ApiConstants.Status.success {
                    self?.favorites.remove(at: imageIndex)
                    self?.deleteCachedFavoriteImageService.deleteImageFromCache(url: cat.image?.url)
                    self?.delteImageFromFavouritesCallBack?(imageIndex, true)
                } else {
                    self?.delteImageFromFavouritesCallBack?(imageIndex, false)
                }
            case .failure:
                self?.delteImageFromFavouritesCallBack?(imageIndex, false)
            }
        }
    }
}
