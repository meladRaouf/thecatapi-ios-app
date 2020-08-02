//
//  RandomeCatImagesView.swift
//  Cats
//
//  Created by Melad on 8/1/20.
//  Copyright © 2020 gini. All rights reserved.
//

import Foundation

typealias RandomCatImagesCallBack = () -> Void
typealias ErrorCallback =  (Error) -> Void
typealias ToggleImageFavouritesCallBack = (Int, Bool) -> Void

protocol RandomCatImagesViewModelType {
    var randomCatImagesCallBack: RandomCatImagesCallBack? {get set}
    var toggleImageFavouritesCallBack: ToggleImageFavouritesCallBack? {get set}
    var errorCallback: ErrorCallback? { get set }
    var cats: Cats { get set }
    
    func getRandomCatImages()
    func toggleImageFavourites(imageIndex: Int)
}
class RandomCatImagesViewModel: RandomCatImagesViewModelType {
    private var randomCatImagesApi: RandomCatImagesApi
    private var deleteFromFavoriteAPI: DeleteFromFavouriteAPI
    private var saveToFavouriteAPI: SaveToFavouriteAPI
    private var deleteCachedFavoriteImageService: DeleteCachedFavoriteImageServiceType
    
    var randomCatImagesCallBack: RandomCatImagesCallBack?
    var toggleImageFavouritesCallBack: ToggleImageFavouritesCallBack?
    var errorCallback: ErrorCallback?
    var cats: Cats
    init(randomCatImagesApi: RandomCatImagesApi = RandomCatImagesApiService(),
         saveToFavouriteAPI: SaveToFavouriteAPI = SaveToFavouriteService(),
         deleteFromFavoriteAPI: DeleteFromFavouriteAPI = DeleteFromFavouriteService(),
         deleteCachedFavoriteImageService: DeleteCachedFavoriteImageServiceType = DeleteCachedFavoriteImageService()) {
        self.randomCatImagesApi = randomCatImagesApi
        self.saveToFavouriteAPI = saveToFavouriteAPI
        self.deleteFromFavoriteAPI = deleteFromFavoriteAPI
        self.deleteCachedFavoriteImageService = deleteCachedFavoriteImageService
        
        self.cats = []
    }
    func getRandomCatImages() {
        randomCatImagesApi.getRandomCatImages { [ weak self ] response in
            switch response {
            case .success(let cats):
                self?.cats = cats
                self?.randomCatImagesCallBack?()
            case .failure(let error):
                self?.errorCallback?(error)
            }
        }
    }
    func toggleImageFavourites(imageIndex: Int) {
        let cat = cats[imageIndex]
        if   cat.favourite == nil {
            saveToFavourite(imageIndex: imageIndex)
        } else {
            deleteFromFavourite(imageIndex: imageIndex)
        }
    }
}

// MARK: Save image to and delete image from favorite
extension RandomCatImagesViewModel {
    func deleteFromFavourite( imageIndex: Int ) {
        var cat = cats[imageIndex]
        guard let id = cat.favourite?.id else {
            return
        }
        deleteFromFavoriteAPI.deleteImageFromFavourite(id) { [ weak self ] result in
            switch result {
            case .success(let response):
                if response.message ==  ApiConstants.Status.success {
                    cat.setFavoriteId( nil)
                    self?.cats[imageIndex] = cat
                    self?.deleteCachedFavoriteImageService.deleteImageFromCache(url: cat.url)
                    self?.toggleImageFavouritesCallBack?(imageIndex, true)
                } else {
                    self?.toggleImageFavouritesCallBack?(imageIndex, false)
                }
            case .failure:
                self?.toggleImageFavouritesCallBack?(imageIndex, false)
            }
        }
    }
    func saveToFavourite(imageIndex: Int) {
        var cat = cats[imageIndex]
        guard let id = cat.id else {
            return
        }
        saveToFavouriteAPI.addImageToFavourite(id) { [ weak self ] result in
            switch result {
            case .success(let response):
                if response.message ==  ApiConstants.Status.success {
                    cat.setFavoriteId( response.id)
                    self?.cats[imageIndex] = cat
                    self?.toggleImageFavouritesCallBack?(imageIndex, true)
                } else {
                    self?.toggleImageFavouritesCallBack?(imageIndex, false)
                }
            case .failure:
                self?.toggleImageFavouritesCallBack?(imageIndex, false)
            }
        }
    }
}
