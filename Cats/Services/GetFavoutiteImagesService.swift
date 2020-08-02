//
//  GetFavoutitesAPIService.swift
//  Cats
//
//  Created by imac on 8/2/20.
//  Copyright © 2020 gini. All rights reserved.
//

import Foundation
import Alamofire

protocol  GetFavouriteImagesAPI {
    typealias GetFavouriteCatImagesApiResult = (Result<Favourites, Error>) -> Void
    func getFavouriteImages( apiResult: @escaping GetFavouriteCatImagesApiResult)
}
class GetFavouriteImagesService: GetFavouriteImagesAPI {
    func getFavouriteImages(apiResult: @escaping GetFavouriteCatImagesApiResult) {
        let parameters = [
            ApiConstants.Params.limit: ApiConstants.DefaultValues.imagesLimit,
            ApiConstants.Params.subId: ApiConstants.DefaultValues.subId
        ]
        AF.request(ApiConstants.EndPoints.favourites,
                   method: .get,
                   parameters: parameters,
                   headers: [ApiConstants.authHeader]
        ).responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                do {
                    let responseModel = try jsonDecoder.decode(Favourites.self, from: data)
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
