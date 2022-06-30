//
//  DogListViewController.swift
//  ViewDogsApp
//
//  Created by Анна Субботина on 30.06.2022.
//

import UIKit
import EmptyKit

class DogsListViewController: UITableViewController {

    enum Consts {
        enum CommonName {
            static let dogBreedDetailVC = "DogBreedViewController"
            static let doglistVC = "DogListViewController"
            static let title = "BREEDS"
        }

        enum SegueRouter: String {
            case showDog = "ShowDog"
            case showFavDog = "ShowFavDog"
        }
    }

    @IBOutlet weak var favPicturesButton: UIBarButtonItem!

    private let reuseIdentifierTable = "DogCell"
    var dataSource: [Dog] = []
    var worker: DogsApiManagerProtocol = DogsApiManager()

    var displayEmpty = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        fetchDogs()
    }

    func setupUI() {
        self.title = Consts.CommonName.title

        self.tableView.ept.dataSource = self
        self.tableView.ept.delegate = self
    }

    func fetchDogs() {
        startLoading()
        worker.fetchDogs { [weak self] (response) in
            self?.stopLoading()
            do {
                let dogs = try response()
                self?.dataSource = dogs
            } catch {
                self?.showError(error)
            }
            self?.displayEmpty = true
            self?.tableView.reloadData()
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Consts.SegueRouter.showDog.rawValue {
            let cell = sender as! UITableViewCell
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            let dog = dataSource[indexPath.row]
            let destination = segue.destination as! DogBreedViewController
            destination.theDog = dog
        }
    }

    @IBAction func showFavoritePicturesButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Consts.SegueRouter.showFavDog.rawValue, sender: self)

    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension DogsListViewController {
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierTable, for: indexPath)

        let dog = dataSource[indexPath.row]
        cell.textLabel?.text = dog.breed.capitalized

        return cell
    }
}

// MARK: - EmptyKit
extension DogsListViewController: EmptyDataSource {
    func imageForEmpty(in view: UIView) -> UIImage? {
        return UIImage(named: "DogApi")
    }

    func titleForEmpty(in view: UIView) -> NSAttributedString? {
        let title = "Cant fetch dogs"
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

extension DogsListViewController: EmptyDelegate {
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
        fetchDogs()
    }

    func emptyButton(_ button: UIButton, tappedIn view: UIView) {
        fetchDogs()
    }
}
