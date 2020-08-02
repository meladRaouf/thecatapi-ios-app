//
//  SaveToFavouriteAPIService.swift
//  Cats
//
//  Created by Melad on 8/1/20.
//  Copyright © 2020 gini. All rights reserved.
//

import Foundation
import Alamofire

protocol  SaveToFavouriteAPI {
    typealias AddFavouriteCatImagesApiResult = (Result<AddFavouriteResponse, Error>) -> Void
    func addImageToFavourite( _ imageId: String, apiResult: @escaping AddFavouriteCatImagesApiResult)
}

class SaveToFavouriteService: SaveToFavouriteAPI {
    func addImageToFavourite(_ imageId: String, apiResult: @escaping AddFavouriteCatImagesApiResult) {
        let paramters = [
            ApiConstants.Params.imageId: imageId,
            ApiConstants.Params.subId: ApiConstants.DefaultValues.subId
        ]
        AF.request(
            ApiConstants.EndPoints.favourites,
            method: .post,
            parameters: paramters,
            encoding: JSONEncoding.default,
            headers: [ApiConstants.authHeader]
        ).responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                do {
                    let responseModel = try jsonDecoder.decode(AddFavouriteResponse.self, from: data)
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
