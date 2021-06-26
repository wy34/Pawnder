//
//  UIViewController.swift
//  Paw_nder
//
//  Created by William Yeung on 4/22/21.
//

import UIKit
import Photos

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
    
    func showImageUploadOptions(notification: Notification? = nil, photoLibAction: @escaping () -> Void, cameraAction: @escaping () -> Void) {
        let optionSheet = UIAlertController(title: "Photo Selection", message: "How would you like to upload a photo?", preferredStyle: .actionSheet)
        let photoLibAction = UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.presentPhotoLibrary(notification: notification, photoLibAction: photoLibAction)
        })
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { _ in
            cameraAction()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionSheet.addAction(photoLibAction)
        optionSheet.addAction(cameraAction)
        optionSheet.addAction(cancelAction)
        present(optionSheet, animated: true, completion: nil)
    }
    
    private func presentPhotoLibrary(notification: Notification? = nil, photoLibAction: @escaping () -> Void) {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
            case .authorized: photoLibAction()
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { newStatus in
                    DispatchQueue.main.async {
                        if newStatus == .authorized { photoLibAction() }
                        else { self.showAlert(title: "Access Denied", message: "Please enable photo library access in settings.") }
                    }
                }
            case .restricted, .denied, .limited:
                showAlert(title: "Access Denied", message: "Please enable photo library access in settings.")
                break
            @unknown default:
                break
        }
    }
}
