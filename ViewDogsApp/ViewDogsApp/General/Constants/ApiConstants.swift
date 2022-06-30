//
//  ApiConstants.swift
//  ViewDogsApp
//
//  Created by Анна Субботина on 30.06.2022.
//

import Foundation

extension Constants.Api {
    static let baseURL: URL = URL(string: "https://dog.ceo")!
    static let apiURL: URL = baseURL.appendingPathComponent("api")

    static let breedsURL: URL = apiURL.appendingPathComponent("breeds/list")

    static func breedImagesURL(for breedName: String) -> URL {
        return apiURL.appendingPathComponent("/breed/\(breedName)/images")
    }
}
