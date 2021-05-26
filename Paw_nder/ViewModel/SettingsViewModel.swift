//
//  SettingsViewModel.swift
//  Paw_nder
//
//  Created by William Yeung on 4/26/21.
//

import UIKit
import Firebase
import CoreLocation

class SettingsViewModel {
    // MARK: - Properties
    static let shared = SettingsViewModel()
    
    var user: User?
    var userCopy: User?
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
    
    var distanceSliderValue: Float {
        return Float(user?.distancePreference ?? 0) / 150
    }
    
    var preferredDistanceLabel: String {
        return "\(user?.distancePreference ?? 0) mi"
    }
    
    var settingOptions: [Setting] {
        guard let user = user else { return [] }
        
        return [
            Setting(index: 0, title: .name, preview: user.name, emoji: "👤"),
            Setting(index: 1, title: .breed, preview: user.breed, emoji: "🐶"),
            Setting(index: 2, title: .age, preview: "\(user.age ?? 0)", emoji: "💯"),
            Setting(index: 3, title: .gender, preview: user.gender.rawValue, emoji: "👫"),
            Setting(index: 4, title: .bio, preview: user.bio, emoji: "🧬"),
            Setting(index: 5, title: .location, preview: user.locationName, emoji: "📍"),
            Setting(index: 6, title: .preference, preview: "", emoji: "⚙️")
        ]
    }
    
    var locationName: String {
        return user?.locationName ?? ""
    }
    
    // MARK: - Helpers
    func updateUserInfo(completion: @escaping (Error?) -> Void) {
        userCopy = user
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
