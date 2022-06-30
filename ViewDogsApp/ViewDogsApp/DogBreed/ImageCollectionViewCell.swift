//
//  ImageCollectionViewCell.swift
//  ViewDogsApp
//
//  Created by Анна Субботина on 30.06.2022.
//

import Foundation
import UIKit

class BreedImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var likedBreedButton: UIButton!
    @IBOutlet weak var breedImage: UIImageView!
    
    var userTappedLikeButton: (() -> Void)?
    
    @IBAction func likedSomeBreedButtonTouchUpInside(_ sender:UIButton) {
        guard let imageNormalState = UIImage(systemName: "suit.heart") else { return }
        guard let ImageSelectedState = UIImage(systemName: "suit.heart.fill") else { return }
        
        likedBreedButton.setImage(imageNormalState, for: .normal)
        likedBreedButton.setImage(ImageSelectedState, for: .selected)
        likedBreedButton.isSelected.toggle()
        userTappedLikeButton?()
    }
}
