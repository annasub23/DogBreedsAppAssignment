//
//  Helpers.swift
//  ViewDogsApp
//
//  Created by Анна Субботина on 30.06.2022.
//

import Foundation
import UIKit
import Kingfisher
import Agrume
import EmptyKit

extension DogBreedViewController {
    func previewImage(for cell: BreedImageCollectionViewCell) {
        if let image = cell.breedImage.image {
            let agrume = Agrume(image: image, background: .colored(.systemPink))
            agrume.hideStatusBar = false
            agrume.show(from: self)
        }
    }
}

extension FavoriteDogsViewController {
    func previewImage(for cell: FavoriteImagesCollectionViewCell) {
        if let image = cell.favoriteBreedsImageView.image {
            let agrume = Agrume(image: image, background: .colored(.systemPink))
            agrume.hideStatusBar = false
            agrume.show(from: self)
        }
    }
}

