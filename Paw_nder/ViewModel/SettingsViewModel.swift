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
    
    var userAge: String {
        if let age = user?.age {
            if age == 0 {
                return "N/A"
            } else if age > 1 {
                return "\(age)"
            } else {
                return "\(age)"
            }
        }
        
        return "N/A"
    }
    
    var userBreedAge: String {
        return "\(user?.breed?.uppercased() ?? "N/A")  •  \(userAge)"
    }
    
    var userGender: (text: String, textColor: UIColor, bgColor: UIColor) {
        let gender = user?.gender
        
        if gender == .male {
            return (gender!.rawValue, lightBlue, #colorLiteral(red: 0, green: 0.6040372252, blue: 1, alpha: 0.1472674251))
        } else {
            return (gender!.rawValue, lightRed, #colorLiteral(red: 1, green: 0.4016966522, blue: 0.4617980123, alpha: 0.1497695853))
        }
    }
    
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
    
    var settingOptions: [Setting] {
        guard let user = user else { return [] }
        
        return [
            Setting(index: 0, name: "Name", preview: user.name, emoji: "👤"),
            Setting(index: 1, name: "Breed", preview: user.breed, emoji: "🐶"),
            Setting(index: 2, name: "Age", preview: "\(user.age ?? 0)", emoji: "💯"),
            Setting(index: 3, name: "Gender", preview: user.gender.rawValue, emoji: "👫"),
            Setting(index: 4, name: "Country", preview: "United States", emoji: "📍"),
            Setting(index: 5, name: "Bio", preview: user.bio, emoji: "🧬")
        ]
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
    
    func updateUserImages(completion: @escaping (Error?) -> Void) {
        guard selectedImages.count > 0 else { completion(nil); return }

        var imageDict = user?.imageUrls
        
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
                        
                        imageDict?["\(imageKey)"] = url!.absoluteString

                        Firestore.firestore().collection("users").document(self.user!.uid).updateData(["imageUrls": imageDict ?? ["": ""]]) { error in
                            if let error = error {
                                completion(error)
                            }
                            
                            self.selectedImages.removeAll()
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
