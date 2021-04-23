//
//  RegisterViewModel.swift
//  Paw_nder
//
//  Created by William Yeung on 4/22/21.
//

import UIKit
import Firebase

//enum AuthError: String, Error {
//    case registerError = "This email is already in use or is badly formatted."
//    case imageStorageError = "There was an error storing your image."
//    case imageUrlError = "There was an error getting your image url."
//}

class RegisterViewModel {
    // MARK: - Properties
    var bindableImage = Bindable<UIImage>()
    var fullName = ""
    var email = ""
    var password = ""
    
    var isFormValid: Bool {
        return fullName != "" && email != "" && password != ""
    }
    
    func registerUser(completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            self.storeProfileImage(completion: completion)
        }
    }
    
    func storeProfileImage(completion: @escaping (Result<Bool, Error>) -> Void) {
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("profileImages/\(imageName)")
        var imageData: Data?
        
        if let pickedImage = bindableImage.value {
            imageData = pickedImage.pngData()
        } else {
            imageData = UIImage(named: "profile")?.pngData()
        }
        
        storageRef.putData(imageData!, metadata: nil) { [weak self] (metadata, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            storageRef.downloadURL { (url, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                self?.saveUserToDB(imageUrlString: url?.absoluteString, completion: completion)
            }
        }
    }
    
    func saveUserToDB(imageUrlString: String?, completion: @escaping (Result<Bool, Error>) -> Void) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData = ["fullName": fullName, "uid": uid, "imageUrlString": imageUrlString ?? ""]
        Firestore.firestore().collection("users").document(uid).setData(docData) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(true))
        }
    }
}
