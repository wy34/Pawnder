//
//  SettingsViewModel.swift
//  Paw_nder
//
//  Created by William Yeung on 4/26/21.
//

import UIKit
import Firebase

class SettingsViewModel {
    // MARK: - Properties
    var user: User?
    var selectedImages = [Int: UIImage]()
    
    // MARK: - Helpers
    func updateUserInfo(completion: @escaping (Error?) -> Void) {
        print(self.user!)
        FirebaseManager.shared.updateUser(user: self.user!) { (error) in
            if let _ = error {
                completion(error)
            }
            
            completion(nil)
        }
    }
    
    func updateUserInfoWithImages(completion: @escaping (Error?) -> Void) {
        var dict = user?.actualImageUrls
        
        for (imageKey, image) in selectedImages {
            let imageName = UUID().uuidString
            let storageRef = Storage.storage().reference().child("profileImages/\(imageName)")
            
            if let imageData = image.pngData() {
                storageRef.putData(imageData, metadata: nil) { [weak self] (metaData, error) in
                    guard let self = self else { return }
                    
                    if let error = error {
                        print(error)
                    }
                    
                    storageRef.downloadURL { (url, error) in
                        if let error = error {
                            completion(error)
                        }
                        
                        dict!["\(imageKey)"] = url!.absoluteString
                        self.user!.actualImageUrls = dict
                        
                        self.updateUserInfo { [weak self] (error) in
                            if let _ = error {
                                completion(error)
                            }

                            self?.selectedImages.removeAll()
                            completion(nil)
                        }
//                        
//                        FirebaseManager.shared.updateUser(user: self.user!) { [weak self] (error) in
//                            if let _ = error {
//                                completion(error)
//                            }
//
//                            self?.selectedImages.removeAll()
//                            completion(nil)
//                        }
                    }
                }
            }
        }
    }
}
