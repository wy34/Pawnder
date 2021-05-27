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
    var currentUserListener: ListenerRegistration!
    var matchesListener: ListenerRegistration!
    var messagesListener: ListenerRegistration!
    var recentMessagesListener: ListenerRegistration!
    
    
    // MARK: - Init
    deinit {
        currentUserListener.remove()
        matchesListener.remove()
        messagesListener.remove()
        recentMessagesListener.remove()
    }
    
    // MARK: - Registering Users
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
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let docData: [String: Any] = ["fullName": credentials.fullName, "uid": currentUserId, "imageUrls": ["1": imageUrlString], "age": 0, "gender": credentials.gender]
        Firestore.firestore().collection("users").document(currentUserId).setData(docData) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(true))
        }
    }
    
    // MARK: - Fetching Users
    private func matchesDistancePref(_ currentUser: User, _ otherUser: User) -> Bool {
        let currentUserCoord = currentUser.coordinate
        let otherUserCoord = otherUser.coordinate
        let distanceMeters = currentUserCoord?.distance(from: otherUserCoord!)
        let distanceMiles = Int(distanceMeters! * 0.000621371)
        return currentUser.distancePreference! >= distanceMiles
    }
    
    private func matchesGenderPref(_ currentUser: User, _ otherUser: User) -> Bool {
        if currentUser.genderPreference != .all {
            if otherUser.gender == currentUser.genderPreference {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
    #warning("Pick up here")
    private func matchesBreedPref(_ currentUser: User, _ otherUser: User) -> Bool {
        var isMatch = false
        let currentUserPrefKeywords = currentUser.breedPreference?.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
        let otherUserBreed = otherUser.breed?.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
    
        for keyword in currentUserPrefKeywords! {
            if otherUserBreed?.contains(keyword) != nil {
                isMatch = true
                break
            }
        }
        
        return isMatch
    }
    
    func fetchUsers(currentUser: User, swipes: [String: Int], completion: @escaping (Result<[CardViewModel], Error>) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        var users = [User]()
        let usersCollection = Firestore.firestore().collection("users")
        
        usersCollection
            .whereField("age", isGreaterThanOrEqualTo: currentUser.minAgePreference ?? 0)
            .whereField("age", isLessThanOrEqualTo: (currentUser.maxAgePreference == 0 ? 100 : currentUser.maxAgePreference) ?? 100).getDocuments { [weak self] (snapshots, error) in
            
            guard let self = self else { return }
                
            if let error = error {
                completion(.failure(error))
                return
            }
            
            snapshots?.documents.forEach({ (snapshot) in
                let user = User(dictionary: snapshot.data())
                let isValidUser = user.uid != currentUserId && self.matchesDistancePref(currentUser, user) && self.matchesGenderPref(currentUser, user) && true
                self.users[user.uid] = user
                
                self.matchesBreedPref(currentUser, user)
//                swipes[user.uid] == nil
                if isValidUser {
//                    self?.lastFetchedUser = user
                    users.append(user)
                }
            })
            
            let cardViewModels = users.map({ $0.toCardViewModel() })
            completion(.success(cardViewModels))
        }
    }
    
    func fetchCurrentUser(completion: @escaping (Result<User, Error>) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }

        currentUserListener = Firestore.firestore().collection("users").document(currentUserId).addSnapshotListener { (snapshot, error) in
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
    
    // MARK: - Downloading Image
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
    
    // MARK: - Updating User
    func updateUser(user: User, completion: @escaping (Error?) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let coord = GeoPoint(latitude: user.coordinate?.coordinate.latitude ?? 0, longitude: user.coordinate?.coordinate.longitude ?? 0)
        
        let docData: [String: Any] = [
            "uid": currentUserId,
            "fullName": user.name,
            "breed": user.breed ?? "",
            "age": user.age ?? "",
            "bio": user.bio ?? "",
            "location": ["name": user.locationName ?? "", "coord": coord],
            "imageUrls": user.imageUrls ?? [0: ""],
            "gender": user.gender.rawValue,
            "genderPreference": user.genderPreference?.rawValue ?? "",
            "breedPreference": user.breedPreference ?? "",
            "minAgePreference": user.minAgePreference ?? 0,
            "maxAgePreference": user.maxAgePreference ?? 0,
            "distancePreference": user.distancePreference ?? 0
        ]
        
        Firestore.firestore().collection("users").document("\(currentUserId)").setData(docData) { (error) in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    func updateUserImages() {
        
    }
    
    // MARK: - Swiping
    func addUserSwipe(for otherUserId: String, like: Bool, completion: @escaping (Error?) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
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
        
    // MARK: - Matches
    func addUserMatch(currentUserId: String, otherUserId: String, completion: @escaping (Error?) -> Void) {
        let data: [String: Any] = ["name": self.users[otherUserId]?.name ?? "", "imageUrlString": self.users[otherUserId]?.imageUrls?["1"] ?? "", "matchedUserId": otherUserId, "startedConversation": false]
        
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
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        var matchesDictionary = [String: Match]()
        
        matchesListener = Firestore.firestore().collection("matches_messages").document(currentUserId).collection("matches").addSnapshotListener { snapshots, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
                return
            }
            
            snapshots?.documentChanges.forEach({ change in
                if change.type == .added || change.type == .modified {
                    let match = Match(dictionary: change.document.data())
                    matchesDictionary[match.matchedUserId] = match
                }
            })
            
            let matches = Array(matchesDictionary.values)
            completion(.success(matches))
        }
    }
    
    func update(match: Match) {
        guard match.startedConversation == false else { return }
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("matches_messages").document(currentUserId).collection("matches").document(match.matchedUserId).updateData(["startedConversation": true])
        Firestore.firestore().collection("matches_messages").document(match.matchedUserId).collection("matches").document(currentUserId).updateData(["startedConversation": true])
    }
    
    // MARK: - Messages
    func addMessage(text: String, match: Match, completion: @escaping (Error?) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }

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

        update(match: match)
        saveToRecentMessages(message: text, match: match, completion: completion)
    }
    
    func fetchMessages(match: Match, completion: @escaping (Result<[Message], Error>) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }

        var messages = [Message]()
        
        messagesListener = Firestore.firestore().collection("matches_messages").document(currentUserId).collection(match.matchedUserId).order(by: "timestamp").addSnapshotListener { snapshot, error in
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
    
    // MARK: - Recent Messages
    func saveToRecentMessages(message: String, match: Match, completion: @escaping (Error?) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let fromData: [String: Any] = ["name": match.name, "profileImageUrl": match.imageUrlString, "timestamp": Timestamp(date: Date()), "message": message, "otherUserId": match.matchedUserId]
        
        Firestore.firestore().collection("matches_messages").document(currentUserId).collection("recent_messages").document(match.matchedUserId).setData(fromData) { error in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
        
        let currentUserName = users[currentUserId]?.name ?? ""
        let currentUserImageUrl = users[currentUserId]?.imageUrls!["1"] ?? ""
        let toData: [String: Any] = ["name": currentUserName, "profileImageUrl": currentUserImageUrl, "timestamp": Timestamp(date: Date()), "message": message, "otherUserId": currentUserId]
        
        Firestore.firestore().collection("matches_messages").document(match.matchedUserId).collection("recent_messages").document(currentUserId).setData(toData) { error in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    func fetchRecentMessages(completion: @escaping (Result<[RecentMessage], Error>) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        var recentMessagesDictionary = [String: RecentMessage]()
        
        recentMessagesListener = Firestore.firestore().collection("matches_messages").document(currentUserId).collection("recent_messages").addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            snapshot?.documentChanges.forEach({ change in
                if change.type == .added || change.type == .modified {
                    let data = change.document.data()
                    let recentMessage = RecentMessage(dictionary: data)
                    recentMessagesDictionary[recentMessage.otherUserId] = recentMessage
                }
            })

            var recentMessages = Array(recentMessagesDictionary.values)
            recentMessages = recentMessages.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
            completion(.success(recentMessages))
        }
    }
}



