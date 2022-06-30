//
//  UIViewController+Extensions.swift
//  ViewDogsApp
//
//  Created by Анна Субботина on 30.06.2022.
//

import Foundation
import UIKit
import PKHUD

extension UIViewController {
    func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: UIAlertController.Style.alert
        )
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    func startLoading() {
        HUD.show(.labeledProgress(title: "Loading...", subtitle: ""))
    }

    func stopLoading() {
        HUD.hide()
    }
}
