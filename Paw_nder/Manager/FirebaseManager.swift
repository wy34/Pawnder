//
//  FirebaseManager.swift
//  Paw_nder
//
//  Created by William Yeung on 4/23/21.
//

import UIKit
import Firebase

class FirebaseManager {
    // MARK: - Properties
    static let shared = FirebaseManager()
    var imageCache = NSCache<NSString, UIImage>()
    var lastFetchedUser: User?
    
    // MARK: - Helpers
    func registerUser(credentials: Credentials, completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { [weak self] (result, error) in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            self.storeProfileImage(fullName: credentials.fullName, image: credentials.profileImage, completion: completion)
        }
    }
    
    func storeProfileImage(fullName: String, image: UIImage?, completion: @escaping (Result<Bool, Error>) -> Void) {
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("profileImages/\(imageName)")
        var imageData: Data?
        
        if let pickedImage = image {
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

                self?.saveUserToDB(fullName: fullName, imageUrlString: url?.absoluteString, completion: completion)
            }
        }
    }
    
    func saveUserToDB(fullName: String, imageUrlString: String?, completion: @escaping (Result<Bool, Error>) -> Void) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData: [String: Any] = ["fullName": fullName, "uid": uid, "imageUrls": ["1": imageUrlString], "age": 0]
        Firestore.firestore().collection("users").document(uid).setData(docData) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(true))
        }
    }
    
    func fetchUsers(currentUser: User, completion: @escaping (Result<[CardViewModel], Error>) -> Void) {
        var users = [User]()
        let usersCollection = Firestore.firestore().collection("users")
        let currentUserId = Auth.auth().currentUser?.uid
        
        usersCollection
            .whereField("age", isGreaterThanOrEqualTo: currentUser.minAgePreference ?? 0)
            .whereField("age", isLessThanOrEqualTo: (currentUser.maxAgePreference == 0 ? 100 : currentUser.maxAgePreference) ?? 100).getDocuments { [weak self] (snapshots, error) in
                
            if let error = error {
                completion(.failure(error))
                return
            }
            
            snapshots?.documents.forEach({ (snapshot) in
                let snapshotData = snapshot.data()
                let user = User(dictionary: snapshotData)
                if user.uid != currentUserId {
                    self?.lastFetchedUser = user
                    users.append(user)
                }
            })
            
            let cardViewModels = users.map({ $0.toCardViewModel() })
            completion(.success(cardViewModels))
        }
    }
    
    func fetchCurrentUser(completion: @escaping (Result<User, Error>) -> Void) {
        let currentUserId = Auth.auth().currentUser?.uid
        
        Firestore.firestore().collection("users").document("\(currentUserId ?? "")").getDocument { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let dictionary = snapshot?.data() {
                let user = User(dictionary: dictionary)
                completion(.success(user))
            }
        }
    }
    
    func downloadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let cachedImage = imageCache.object(forKey: cacheKey) {
            completion(cachedImage)
            return
        }
        
        guard let url = URL(string: urlString) else { completion(nil); return }
        
        DispatchQueue.global().async {
            if let imageData = try? Data(contentsOf: url) {
                let image = UIImage(data: imageData) ?? UIImage()
                self.imageCache.setObject(image, forKey: cacheKey)
                completion(image)
            } else {
                completion(nil)
            }
        }
    }
    
    func updateUser(user: User, completion: @escaping (Error?) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let docData: [String: Any] = ["uid": currentUserId, "fullName": user.name, "breed": user.breed ?? "", "age": user.age ?? "", "bio": user.bio ?? "", "imageUrls": user.imageUrls ?? [0: ""], "minAgePreference": user.minAgePreference ?? 0, "maxAgePreference": user.maxAgePreference ?? 0]
        
        Firestore.firestore().collection("users").document("\(currentUserId)").setData(docData) { (error) in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
}



