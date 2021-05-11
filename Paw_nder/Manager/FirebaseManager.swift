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
//    var lastFetchedUser: User?
    var users = [String: User]()
    let currentUserId = Auth.auth().currentUser?.uid ?? ""
    var listenerRegistration: ListenerRegistration!
    
    // MARK: - Init
    deinit {
        listenerRegistration.remove()
    }
    
    // MARK: - Helpers
    func registerUser(credentials: Credentials, completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { [weak self] (result, error) in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            self.storeProfileImage(credentials: credentials, completion: completion)
        }
    }
    
    func storeProfileImage(credentials: Credentials, completion: @escaping (Result<Bool, Error>) -> Void) {
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("profileImages/\(imageName)")
        var imageData: Data?
        
        if let pickedImage = credentials.profileImage {
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

                self?.saveUserToDB(credentials: credentials, imageUrlString: url!.absoluteString, completion: completion)
            }
        }
    }
    
    func saveUserToDB(credentials: Credentials, imageUrlString: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData: [String: Any] = ["fullName": credentials.fullName, "uid": uid, "imageUrls": ["1": imageUrlString], "age": 0, "gender": credentials.gender]
        Firestore.firestore().collection("users").document(uid).setData(docData) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(true))
        }
    }
    
    func fetchUsers(currentUser: User, swipes: [String: Int], completion: @escaping (Result<[CardViewModel], Error>) -> Void) {
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
                
                self?.users[user.uid] = user
                
//                swipes[user.uid] == nil
                if user.uid != currentUserId && true {
//                    self?.lastFetchedUser = user
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
        let docData: [String: Any] = [
            "uid": currentUserId,
            "fullName": user.name,
            "breed": user.breed ?? "",
            "age": user.age ?? "",
            "bio": user.bio ?? "",
            "imageUrls": user.imageUrls ?? [0: ""],
            "gender": user.gender.rawValue,
            "minAgePreference": user.minAgePreference ?? 0,
            "maxAgePreference": user.maxAgePreference ?? 0
        ]
        
        Firestore.firestore().collection("users").document("\(currentUserId)").setData(docData) { (error) in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    func addUserSwipe(for otherUserId: String, like: Bool, completion: @escaping (Error?) -> Void) {
        let currentUserId = Auth.auth().currentUser?.uid ?? ""
        let swipeData = [otherUserId: (like ? 1 : 0)]
        
        if like == true {
            checkMatchingUser(currentUserId: currentUserId, otherUserId: otherUserId, completion: completion)
        }
        
        Firestore.firestore().collection("swipes").document(currentUserId).getDocument { snapshot, error in
            if snapshot?.exists == true {
                Firestore.firestore().collection("swipes").document(currentUserId).updateData(swipeData) { error in
                    if let error = error {
                        completion(error)
                        return
                    }
                    
                    completion(nil)
                }
            } else {
                Firestore.firestore().collection("swipes").document(currentUserId).setData(swipeData) { error in
                    if let error = error {
                        completion(error)
                        return
                    }
                    
                    completion(nil)
                }
            }
        }
    }
    
    func checkMatchingUser(currentUserId: String, otherUserId: String, completion: @escaping (Error?) -> Void) {
        Firestore.firestore().collection("swipes").document(otherUserId).getDocument { [weak self] snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = snapshot?.data() as? [String: Int] else { return }
            
            if data[currentUserId] == 1 {
                self?.addUserMatch(currentUserId: currentUserId, otherUserId: otherUserId, completion: completion)
                self?.addUserMatch(currentUserId: otherUserId, otherUserId: currentUserId, completion: completion)
            }
        }
    }
    
    func addUserMatch(currentUserId: String, otherUserId: String, completion: @escaping (Error?) -> Void) {
        let data = ["name": self.users[otherUserId]?.name ?? "", "imageUrlString": self.users[otherUserId]?.imageUrls?["1"] ?? "", "matchedUserId": otherUserId]
        
        Firestore.firestore().collection("matches_messages").document(currentUserId).collection("matches").document(otherUserId).setData(data) { error in
            if let error = error {
                print(error.localizedDescription)
                completion(error)
                return
            }
            
            NotificationCenter.default.post(Notification(name: .didFindMatch))
            completion(nil)
        }
    }
    
    func fetchMatches(completion: @escaping (Result<[Match], Error>) -> Void) {
        let currentUserId = Auth.auth().currentUser?.uid ?? ""
        var matches = [Match]()
        
        Firestore.firestore().collection("matches_messages").document(currentUserId).collection("matches").getDocuments { snapshots, error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(.failure(error))
                    return
                }
                
                snapshots?.documents.forEach({ doc in
                    let match = Match(dictionary: doc.data())
                    matches.append(match)
                })
                
                completion(.success(matches))
            }
    }
    
    func addMessage(text: String, match: Match, completion: @escaping (Error?) -> Void) {
        let data: [String: Any] = ["text": text, "fromId": currentUserId, "toId": match.matchedUserId, "timestamp": Timestamp(date: Date())]

        Firestore.firestore().collection("matches_messages").document(currentUserId).collection(match.matchedUserId).document().setData(data) { error in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
        
        Firestore.firestore().collection("matches_messages").document(match.matchedUserId).collection(currentUserId).document().setData(data) { error in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    func fetchMessages(match: Match, completion: @escaping (Result<[Message], Error>) -> Void) {
        var messages = [Message]()
        
        listenerRegistration = Firestore.firestore().collection("matches_messages").document(currentUserId).collection(match.matchedUserId).order(by: "timestamp").addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            snapshot?.documentChanges.forEach({ change in
                let data = change.document.data()
                messages.append(.init(dictionary: data))
            })
            
            completion(.success(messages))
        }
    }
}



