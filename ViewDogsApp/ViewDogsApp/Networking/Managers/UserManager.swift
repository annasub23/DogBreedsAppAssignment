//
//  UserManager.swift
//  ViewDogsApp
//
//  Created by Анна Субботина on 30.06.2022.
//

import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class UserManager {
    fileprivate let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = TimeInterval(90)
        
        return SessionManager(configuration: configuration)
    }()
    
    fileprivate func request<T: Mappable>(_ type: T.Type, url: URLConvertible,
                                          method: HTTPMethod,
                                          parameters: Parameters? = nil,
                                          encoding: ParameterEncoding = URLEncoding.default,
                                          headers: HTTPHeaders? = nil,
                                          validStatusCodes: [Int],
                                          onSuccess: @escaping ((Result<T>) -> Void)) {
        sessionManager
            .request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .validate(statusCode: validStatusCodes)
            .responseObject { (data: DataResponse<T>) in
                onSuccess(data.result)
            }
    }
    
    func get<T: Mappable>(_ type: T.Type, url: URLConvertible, onSuccess: @escaping ((Result<T>) -> Void)) {
        request(type, url: url, method: .get, validStatusCodes: [200], onSuccess: onSuccess)
    }
}

extension UserManager {
    func getBreeds(response: @escaping (Result<DogsResponse>) -> Void) {
        let url = Constants.Api.breedsURL
        
        get(DogsResponse.self, url: url) { (result) in
            response(result)
        }
    }
    
    func getBreedImages(dog: Dog, response: @escaping (Result<BreedsResponse>) -> Void) {
        let url = Constants.Api.breedImagesURL(for: dog.breed)
        
        get(BreedsResponse.self, url: url) { (result) in
            response(result)
        }
    }
}
