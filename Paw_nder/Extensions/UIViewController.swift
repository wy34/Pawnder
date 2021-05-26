//
//  UIViewController.swift
//  Paw_nder
//
//  Created by William Yeung on 4/22/21.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String, leftButtonTitle: String, rightButtonTitle: String, completion: @escaping (UIAlertAction) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: leftButtonTitle, style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: rightButtonTitle, style: .default, handler: completion))
        present(alertController, animated: true, completion: nil)
    }
}
