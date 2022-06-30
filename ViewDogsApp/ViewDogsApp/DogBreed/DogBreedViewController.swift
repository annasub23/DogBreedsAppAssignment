//
//  DogBreedViewController.swift
//  ViewDogsApp
//
//  Created by Анна Субботина on 30.06.2022.
//

import UIKit
import Kingfisher
import Agrume
import EmptyKit

class DogBreedViewController: UICollectionViewController {
    
    var favoritesRepository: FavoritesRepositoryProtocol = FavoritesRepository.shared
    var theDog: Dog?
    
    var dataSource: [URL] = []
    var worker: DogsApiManagerProtocol = DogsApiManager()
    
    var displayEmpty = false
    private let reuseIdentifierCol = "ImagesCell"
    
    private var selectedImages : [(image: Dog, snapshot: UIImage)] = []
    private var shareEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchBreeds()
    }
    
    func setupUI() {
        self.title = theDog?.breed.uppercased()
        
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
    
    func configureCell(for cell: BreedImageCollectionViewCell, indexPath: IndexPath) -> BreedImageCollectionViewCell {
        let url = dataSource[indexPath.row]
        let resource = ImageResource(downloadURL: url, cacheKey: url.path)
        cell.breedImage.kf.indicatorType = .activity
        cell.breedImage.kf.setImage(with: resource)
        let isFavorite = favoritesRepository.contains(url: url.absoluteString)
        cell.likedBreedButton.isSelected = isFavorite
        cell.userTappedLikeButton = { [weak self] in
            isFavorite
            ? self?.favoritesRepository.removeFromFavorites(url: url.absoluteString)
            : self?.favoritesRepository.addToFavorites(url: url.absoluteString)
        }
        return cell
    }
    
    func fetchBreeds() {
        guard let dog = theDog else { return }
        
        startLoading()
        worker.fetchImages(for: dog) { [weak self] (response) in
            self?.stopLoading()
            do {
                let images = try response()
                self?.dataSource = images.compactMap { URL(string: $0.imageUrl) }
                
                self?.title = "\(dog.breed) (\(images.count))".uppercased()
            } catch {
                self?.showError(error)
            }
            self?.displayEmpty = true
            self?.collectionView?.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension DogBreedViewController {
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierCol, for: indexPath) as! BreedImageCollectionViewCell
        
        return configureCell(for: cell, indexPath: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! BreedImageCollectionViewCell
        self.previewImage(for: cell)
    }
}

// MARK: - EmptyKit
extension DogBreedViewController: EmptyDataSource {
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

extension DogBreedViewController: EmptyDelegate {
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
