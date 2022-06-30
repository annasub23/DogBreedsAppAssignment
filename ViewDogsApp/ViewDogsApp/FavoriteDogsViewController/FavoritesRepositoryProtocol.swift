//
//  FavoritesRepositoryProtocol.swift
//  ViewDogsApp
//
//  Created by Анна Субботина on 30.06.2022.
//

import Foundation
protocol FavoritesRepositoryProtocol {

    func addToFavorites(url: String)
    func removeFromFavorites(url: String)
    func contains(url: String) -> Bool

}

final class FavoritesRepository: FavoritesRepositoryProtocol {

    static let shared = FavoritesRepository()

    private init() {}

    private (set) var storage: Set<String> = []

    func addToFavorites(url: String) {
        storage.insert(url)
    }

    func removeFromFavorites(url: String) {
        storage.remove(url)
    }

    func contains(url: String) -> Bool {
        return storage.contains(url)
    }
}
