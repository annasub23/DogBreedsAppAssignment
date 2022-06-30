//
//  DogApiManager.swift
//  ViewDogsApp
//
//  Created by Анна Субботина on 30.06.2022.
//

import Foundation
protocol DogsApiManagerProtocol {
    func fetchDogs(response: @escaping (() throws -> ([Dog])) -> Void)
    func fetchImages(for dog: Dog, response: @escaping (() throws -> ([Breed])) -> Void)
}

class DogsApiManager: DogsApiManagerProtocol {
    let manager = UserManager()
    
    func fetchDogs(response: @escaping (() throws -> ([Dog])) -> Void) {
        manager.getBreeds { (apiResponse) in
            switch apiResponse {
            case .success(let dogsResponse):
                let dogs = dogsResponse.breeds
                response { return dogs }
            case .failure(let error):
                response { throw error }
            }
        }
    }
    
    func fetchImages(for dog: Dog, response: @escaping (() throws -> ([Breed])) -> Void) {
        manager.getBreedImages(dog: dog) { (apiResponse) in
            switch apiResponse {
            case .success(let breedResponse):
                let images = breedResponse.images
                response { return images }
            case .failure(let error):
                response { throw error }
            }
        }
    }
}
