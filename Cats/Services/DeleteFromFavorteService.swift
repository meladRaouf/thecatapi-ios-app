//
//  SaveAndDeleteFavouritesApiService.swift
//  Cats
//
//  Created by Melad on 8/1/20.
//  Copyright © 2020 gini. All rights reserved.
//
import Foundation
import Alamofire
import Kingfisher

protocol DeleteFromFavouriteAPI {
    typealias DeleteFavouriteCatImagesApiResult = (Result<DeleteFavouriteResponse, Error>) -> Void
    func deleteImageFromFavourite(_ favouriteId: Int, apiResult: @escaping DeleteFavouriteCatImagesApiResult)
}

class DeleteFromFavouriteService :DeleteFromFavouriteAPI {
    func deleteImageFromFavourite(_ favouriteId: Int, apiResult: @escaping DeleteFavouriteCatImagesApiResult) {
        let url =  "\(ApiConstants.EndPoints.favourites)\(favouriteId)"
        AF.request(url, method: .delete, headers: [ApiConstants.authHeader]
        ).responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                do {
                    let responseModel = try jsonDecoder.decode(DeleteFavouriteResponse.self, from: data)
                    apiResult(.success(responseModel))
                } catch let error {
                    apiResult(.failure(error))
                }
            case .failure(let error ):
                apiResult(.failure(error))
            }
        }
    }
}

protocol DeleteCachedFavoriteImageServiceType {
    func deleteImageFromCache(url: String?)
}
class DeleteCachedFavoriteImageService: DeleteCachedFavoriteImageServiceType {
    func deleteImageFromCache(url: String?) {
        guard let cacheKey = url else {
            return
        }
        DispatchQueue.global(qos: .background).async {
            let cache = ImageCache.default
            let cached = cache.isCached(forKey: cacheKey)
            if cached {
                cache.removeImage(forKey: cacheKey)
            }
        }
    }
    
    
}
