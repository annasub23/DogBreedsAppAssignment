//
//  FavoriteDogsViewController.swift
//  ViewDogsApp
//
//  Created by Анна Субботина on 30.06.2022.
//

import Foundation
import UIKit
import Kingfisher
import Agrume
import EmptyKit

class FavoriteDogsViewController: UICollectionViewController {
    
    enum Consts {
        enum CommonName {
            static let title = "FAVORITE BREEDS"
        }
    }
    
    var dataSource: [URL] = FavoritesRepository.shared.storage.compactMap { path in
        URL(string: path)
    }
    
    var theDog: Dog?
    
    var worker: DogsApiManagerProtocol = DogsApiManager()
    
    var displayEmpty = false
    private let reuseIdentifierCol = "FavorImageCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchBreeds()
    }
    
    func setupUI() {
        self.title = Consts.CommonName.title.uppercased()
        
        self.collectionView?.ept.dataSource = self
        self.collectionView?.ept.delegate = self
        self.collectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let fullPhotoItem = NSCollectionLayoutItem(layoutSize: itemSize)
        fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(
            top: 2,
            leading: 2,
            bottom: 2,
            trailing: 2)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1/3))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: fullPhotoItem,
            count: 3
        )
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureCell(for cell: FavoriteImagesCollectionViewCell, indexPath: IndexPath) -> FavoriteImagesCollectionViewCell {
        let url = dataSource[indexPath.row]
        let resource = ImageResource(downloadURL: url, cacheKey: url.path)
        cell.favoriteBreedsImageView.kf.indicatorType = .activity
        cell.favoriteBreedsImageView.kf.setImage(with: resource)
        return cell
    }
    
    func fetchBreeds() {
        self.collectionView?.reloadData()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension FavoriteDogsViewController {
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    //    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierCol, for: indexPath) as! FavoriteImagesCollectionViewCell
        
        return configureCell(for: cell, indexPath: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! FavoriteImagesCollectionViewCell
        self.previewImage(for: cell)
    }
}

// MARK: - EmptyKit
extension FavoriteDogsViewController: EmptyDataSource {
    func imageForEmpty(in view: UIView) -> UIImage? {
        return UIImage(named: "DogApi")
    }
    
    func titleForEmpty(in view: UIView) -> NSAttributedString? {
        let title = "Cant fetch breed images"
        let font = UIFont.systemFont(ofSize: 14)
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black, .font: font]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    func buttonTitleForEmpty(forState state: UIControl.State, in view: UIView) -> NSAttributedString? {
        let title = "Load Again?"
        let font = UIFont.systemFont(ofSize: 17)
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .font: font]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    func buttonBackgroundColorForEmpty(in view: UIView) -> UIColor {
        return .black
    }
    
    func customViewForEmpty(in view: UIView) -> UIView? {
        return nil
    }
}

extension FavoriteDogsViewController: EmptyDelegate {
    func emptyShouldDisplay(in view: UIView) -> Bool {
        return displayEmpty
    }
    
    func emptyShouldAllowTouch(in view: UIView) -> Bool {
        return true
    }
    
    func emptyShouldEnableTapGesture(in view: UIView) -> Bool {
        return true
    }
    
    func emptyView(_ emptyView: UIView, tappedIn view: UIView) {
        fetchBreeds()
    }
    
    func emptyButton(_ button: UIButton, tappedIn view: UIView) {
        fetchBreeds()
    }
}
