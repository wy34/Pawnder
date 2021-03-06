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
        
        let docData: [String: Any] = [
            "fullName": credentials.fullName,
            "uid": currentUserId,
            "imageUrls": ["1": imageUrlString],
            "age": 0,
            "gender": credentials.gender,
            "tag": UUID().hashValue
        ]
        
        Firestore.firestore().collection(Firebase.users).document(currentUserId).setData(docData) { (error) in
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
            return otherUser.gender == currentUser.genderPreference
        } else {
            return true
        }
    }
    
    private func matchesBreedPref(_ currentUser: User, _ otherUser: User) -> Bool {
        if currentUser.breedPreference == noBreedPrefCaption { return true }
        return currentUser.breedPreference == otherUser.breed || otherUser.breed == noBreedPrefCaption
    }
    
    func fetchUsers(currentUser: User, swipes: [String: Int], completion: @escaping (Result<[CardViewModel], Error>) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        var users = [User]()
        let usersCollection = Firestore.firestore().collection(Firebase.users)
        
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
                let isValidUser = user.uid != currentUserId
                                  && self.matchesDistancePref(currentUser, user)
                                  && self.matchesGenderPref(currentUser, user)
                                  && self.matchesBreedPref(currentUser, user)
                                  && swipes[user.uid] == nil

                self.users[user.uid] = user

                if isValidUser {
                    users.append(user)
                }
            })

            let cardViewModels = users.map({ $0.toCardViewModel() })
            completion(.success(cardViewModels))
        }
    }
    
    func fetchCurrentUser(completion: @escaping (Result<User, Error>) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }

        currentUserListener = Firestore.firestore().collection(Firebase.users).document(currentUserId).addSnapshotListener { (snapshot, error) in
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
            "tag": user.tag,
            "fullName": user.name,
            "breed": user.breed ?? "",
            "age": user.age ?? "",
            "bio": user.bio ?? "",
            "location": ["name": user.locationName ?? "", "coord": coord],
            "imageUrls": user.imageUrls ?? [0: ""],
            "gender": user.gender.rawValue,
            "genderPreference": user.genderPreference?.rawValue ?? "",
            "breedPreference": user.breedPreference,
            "minAgePreference": user.minAgePreference ?? 0,
            "maxAgePreference": user.maxAgePreference ?? 0,
            "distancePreference": user.distancePreference ?? 0
        ]
        
        Firestore.firestore().collection(Firebase.users).document("\(currentUserId)").setData(docData) { (error) in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    // MARK: - Swiping
    private func handleIfOtherUserDidNotLikeUs(otherUserId: String, currentUser: User?, completion: @escaping (Error?) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let usersCollection = Firestore.firestore().collection(Firebase.usersWhoLikedMe).document(otherUserId).collection(Firebase.users)
            
        usersCollection.document(currentUserId).setData(currentUser!.dictionaryData!) { error in
            if let error = error { completion(error); return }
            
            Firestore.firestore().collection(Firebase.swipes).document(otherUserId).getDocument { snapshot, error in
                if let error = error { completion(error); return }
                
                if let data = snapshot?.data() as? [String: Int] {
                    if data[currentUserId] != nil && data[currentUserId] != 1 {
                        Firestore.firestore().collection(Firebase.usersWhoLikedMe).document(otherUserId).collection(Firebase.users).document(currentUserId).delete()
                    }
                }
            }
        }
    }
    
    func addUserSwipe(for otherUserId: String, like: Bool, currentUser: User?, completion: @escaping (Error?) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let swipeData = [otherUserId: (like ? 1 : 0)]
        
        if like == true {
            handleIfOtherUserDidNotLikeUs(otherUserId: otherUserId, currentUser: currentUser, completion: completion)
            checkMatchingUser(currentUserId: currentUserId, otherUserId: otherUserId, completion: completion)
        } else {
            Firestore.firestore().collection(Firebase.usersWhoLikedMe).document(currentUserId).collection(Firebase.users).document(otherUserId).delete()
        }
        
        Firestore.firestore().collection(Firebase.swipes).document(currentUserId).getDocument { snapshot, error in
            if snapshot?.exists == true {
                Firestore.firestore().collection(Firebase.swipes).document(currentUserId).updateData(swipeData) { error in
                    if let error = error {
                        completion(error)
                        return
                    }
                    
                    completion(nil)
                }
            } else {
                Firestore.firestore().collection(Firebase.swipes).document(currentUserId).setData(swipeData) { error in
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
        Firestore.firestore().collection(Firebase.swipes).document(otherUserId).getDocument { [weak self] snapshot, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = snapshot?.data() as? [String: Int] else { return }
            
            if data[currentUserId] == 1 {
                self?.addUserMatch(currentUserId: currentUserId, otherUserId: otherUserId, completion: completion)
                self?.addUserMatch(currentUserId: otherUserId, otherUserId: currentUserId, completion: completion)
                
                Firestore.firestore().collection(Firebase.usersWhoLikedMe).document(currentUserId).collection(Firebase.users).document(otherUserId).delete()
                Firestore.firestore().collection(Firebase.usersWhoLikedMe).document(otherUserId).collection(Firebase.users).document(currentUserId).delete()
            }
        }
    }
    
    private func handleUndoingDislikeAndDeletingSwipes(currentUserId: String, otherUserId: String, otherUser: User?) {
        Firestore.firestore().collection(Firebase.swipes).document(otherUserId).getDocument { snapshot, error in
            if snapshot!.exists {
                if let _ = error { return }
    
                if let likesDictionary = snapshot?.data() as? [String: Int] {
                    if likesDictionary[currentUserId] == 1 {
                        Firestore.firestore().collection(Firebase.usersWhoLikedMe).document(currentUserId).collection(Firebase.users).document(otherUserId).setData(otherUser!.dictionaryData!)
                    }
    
                    Firestore.firestore().collection(Firebase.swipes).document(currentUserId).updateData([otherUserId: FieldValue.delete()])
                }
            } else {
                Firestore.firestore().collection(Firebase.swipes).document(currentUserId).updateData([otherUserId: FieldValue.delete()])
            }
        }
    }
    
    func undoLastSwipe(otherUser: User?, otherUserId: String, completion: @escaping (Error?) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection(Firebase.matches_messages).document(currentUserId).collection(Firebase.matches).document(otherUserId).getDocument { snapshot, error in
            if let matchExisted = snapshot?.exists {
                if matchExisted == false {
                    self.handleUndoingDislikeAndDeletingSwipes(currentUserId: currentUserId, otherUserId: otherUserId, otherUser: otherUser)
                    Firestore.firestore().collection(Firebase.usersWhoLikedMe).document(otherUserId).collection(Firebase.users).document(currentUserId).delete()
                } else {
                    Firestore.firestore().collection(Firebase.swipes).document(currentUserId).updateData([otherUserId: FieldValue.delete()])
                    Firestore.firestore().collection(Firebase.usersWhoLikedMe).document(currentUserId).collection(Firebase.users).document(otherUserId).setData(otherUser!.dictionaryData!)
                    Firestore.firestore().collection(Firebase.matches_messages).document(currentUserId).collection(Firebase.matches).document(otherUserId).delete()
                    Firestore.firestore().collection(Firebase.matches_messages).document(otherUserId).collection(Firebase.matches).document(currentUserId).delete()
                }
            }
        }
        
        Firestore.firestore().collection(Firebase.matches_messages).document(currentUserId).collection(otherUserId).getDocuments { snapshots, error in
            if let error = error {
                completion(error)
                return
            }
            
            snapshots?.documents.forEach({
                $0.reference.delete()
            })
        }
        
        Firestore.firestore().collection(Firebase.matches_messages).document(otherUserId).collection(currentUserId).getDocuments { snapshots, error in
            if let error = error {
                completion(error)
                return
            }
            
            snapshots?.documents.forEach({
                $0.reference.delete()
            })
        }
        
        Firestore.firestore().collection(Firebase.matches_messages).document(currentUserId).collection(Firebase.recentMessages).document(otherUserId).delete()
        Firestore.firestore().collection(Firebase.matches_messages).document(otherUserId).collection(Firebase.recentMessages).document(currentUserId).delete()
    }
        
    // MARK: - Matches
    func addUserMatch(currentUserId: String, otherUserId: String, completion: @escaping (Error?) -> Void) {
        var data: [String: Any] = [
            "name": self.users[otherUserId]?.name ?? "",
            "imageUrlString": self.users[otherUserId]?.imageUrls?["1"] ?? "",
            "matchedUserId": otherUserId,
            "startedConversation": false
        ]
        
        Firestore.firestore().collection(Firebase.users).document(otherUserId).getDocument { snapshot, error in
            if let error = error { completion(error); return }
            
            if let dictionary = snapshot?.data() {
                data["matchedUser"] = dictionary
                
                Firestore.firestore().collection(Firebase.matches_messages).document(currentUserId).collection(Firebase.matches).document(otherUserId).setData(data) { error in
                    if let error = error {
                        completion(error)
                        return
                    }
                    
                    NotificationCenter.default.post(Notification(name: .didFindMatch))
                    completion(nil)
                }
            }
        }
    }
    
    func fetchMatches(completion: @escaping (Result<[Match], Error>) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        var matchesDictionary = [String: Match]()
        
        matchesListener = Firestore.firestore().collection(Firebase.matches_messages).document(currentUserId).collection(Firebase.matches).addSnapshotListener { snapshots, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            snapshots?.documentChanges.forEach({ change in
                let match = Match(dictionary: change.document.data())
                
                if change.type == .added || change.type == .modified {
                    matchesDictionary[match.matchedUserId] = match
                } else if change.type == .removed {
                    matchesDictionary[match.matchedUserId] = nil
                }
            })
            
            let matches = Array(matchesDictionary.values)
            completion(.success(matches))
        }
    }
    
    private func update(match: Match) {
        guard match.startedConversation == false else { return }
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection(Firebase.matches_messages).document(currentUserId).collection(Firebase.matches).document(match.matchedUserId).updateData(["startedConversation": true])
        Firestore.firestore().collection(Firebase.matches_messages).document(match.matchedUserId).collection(Firebase.matches).document(currentUserId).updateData(["startedConversation": true])
    }
    
    // MARK: - Messages
    func addMessage(text: String, match: Match, completion: @escaping (Error?) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }

        let data: [String: Any] = ["text": text,
                                   "fromId": currentUserId,
                                   "toId": match.matchedUserId,
                                   "timestamp": Timestamp(date: Date())
        ]

        Firestore.firestore().collection(Firebase.matches_messages).document(currentUserId).collection(match.matchedUserId).document().setData(data) { error in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
        
        Firestore.firestore().collection(Firebase.matches_messages).document(match.matchedUserId).collection(currentUserId).document().setData(data) { error in
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
        
        let matchedUser = Firestore.firestore().collection(Firebase.matches_messages).document(currentUserId).collection(match.matchedUserId)
        messagesListener = matchedUser.order(by: "timestamp").addSnapshotListener { snapshot, error in
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
        
        var fromData: [String: Any] = [
            "name": match.name,
            "profileImageUrl": match.imageUrlString,
            "timestamp": Timestamp(date: Date()),
            "message": message,
            "otherUserId": match.matchedUserId,
            "isRead": true
        ]
        
        Firestore.firestore().collection(Firebase.users).document(match.matchedUserId).getDocument { snapshot, error in
            if let error = error { completion(error); return }
            
            if let dictionary = snapshot?.data() {
                fromData["partner"] = dictionary
                
                Firestore.firestore().collection(Firebase.matches_messages).document(currentUserId).collection(Firebase.recentMessages).document(match.matchedUserId).setData(fromData) { error in
                    if let error = error {
                        completion(error)
                        return
                    }
                    
                    completion(nil)
                }
            }
        }
        
        let currentUserName = users[currentUserId]?.name ?? ""
        let currentUserImageUrl = users[currentUserId]?.imageUrls!["1"] ?? ""
        var toData: [String: Any] = [
            "name": currentUserName,
            "profileImageUrl": currentUserImageUrl,
            "timestamp": Timestamp(date: Date()),
            "message": message,
            "otherUserId": currentUserId,
            "isRead": false
        ]
        
        Firestore.firestore().collection(Firebase.users).document(currentUserId).getDocument { snapshot, error in
            if let error = error { completion(error); return }
            
            if let dictionary = snapshot?.data() {
                toData["partner"] = dictionary
                
                Firestore.firestore().collection(Firebase.matches_messages).document(match.matchedUserId).collection(Firebase.recentMessages).document(currentUserId).setData(toData) { error in
                    if let error = error {
                        completion(error)
                        return
                    }
                    
                    completion(nil)
                }
            }
        }
    }
    
    func fetchRecentMessages(completion: @escaping (Result<[RecentMessage], Error>) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        var recentMessagesDictionary = [String: RecentMessage]()
        
        recentMessagesListener = Firestore.firestore().collection(Firebase.matches_messages).document(currentUserId).collection(Firebase.recentMessages).addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            snapshot?.documentChanges.forEach({ change in
                let recentMessage = RecentMessage(dictionary: change.document.data())

                if change.type == .added || change.type == .modified {
                    recentMessagesDictionary[recentMessage.otherUserId] = recentMessage
                } else if change.type == .removed {
                    recentMessagesDictionary[recentMessage.otherUserId] = nil
                }
            })

            var recentMessages = Array(recentMessagesDictionary.values)
            recentMessages = recentMessages.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
            completion(.success(recentMessages))
        }
    }
}



