//
//  RandomCatImagesApiService.swift
//  Cats
//
//  Created by Melad on 8/1/20.
//  Copyright © 2020 gini. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - RandomCatImagesApi
protocol RandomCatImagesApi {
    typealias GetRandomCatImagesApiResult = (Result<Cats, Error>) -> Void
    func getRandomCatImages(apiResult: @escaping GetRandomCatImagesApiResult)
}

// MARK: - RandomCatImagesApiService
class RandomCatImagesApiService: RandomCatImagesApi {
    func getRandomCatImages( apiResult: @escaping GetRandomCatImagesApiResult) {

        let parameters = [
            ApiConstants.Params.limit: ApiConstants.DefaultValues.imagesLimit,
            ApiConstants.Params.subId: ApiConstants.DefaultValues.subId
        ]
        AF.request(
            ApiConstants.EndPoints.randomImages,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding(destination: .queryString),
            headers: [ ApiConstants.authHeader ]
        ).responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                do {
                    let responseModel = try jsonDecoder.decode(Cats.self, from: data)
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
