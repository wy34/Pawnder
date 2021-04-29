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
    static let shared = SettingsViewModel()
    var user: User?
    var selectedImages = [Int: UIImage]()
    
    
    var ageSliderMinFloatValue: Float {
        return Float(user?.minAgePreference ?? 0) / 100
    }
    
    var ageSliderMinLabel: String {
        return "Min: \(user?.minAgePreference ?? 0)"
    }
    
    var ageSliderMaxFloatValue: Float {
        return Float(user?.maxAgePreference ?? 0) / 100
    }
    
    var ageSliderMaxLabel: String {
        return "Max: \(user?.maxAgePreference ?? 0)"
    }
    
    // MARK: - Helpers
    func updateUserInfo(completion: @escaping (Error?) -> Void) {
        FirebaseManager.shared.updateUser(user: self.user!) { (error) in
            if let _ = error {
                completion(error)
            }
            
            completion(nil)
        }
    }
    
    func updateUserInfoWithImages(completion: @escaping (Error?) -> Void) {
        var dict = user?.imageUrls
        
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
                        self.user!.imageUrls = dict
                        
                        self.updateUserInfo { [weak self] (error) in
                            if let _ = error {
                                completion(error)
                            }

                            self?.selectedImages.removeAll()
                            completion(nil)
                        }
                    }
                }
            }
        }
    }

    func logoutUser(completion: @escaping () -> Void) {
        try? Auth.auth().signOut()
        completion()
    }
}
