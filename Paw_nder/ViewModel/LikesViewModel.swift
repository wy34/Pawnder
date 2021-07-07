//
//  LikeVCViewModel.swift
//  Paw_nder
//
//  Created by William Yeung on 6/22/21.
//

import Foundation
import Firebase

class LikesViewModel {
    // MARK: - Helpers
    func fetchUsersWhoLikedMe(addedCompletion: @escaping (Result<[User], Error>) -> Void, removedCompletion: @escaping (User?) -> Void) {
        let currentUserId = Auth.auth().currentUser!.uid
        var users = [User]()
        
        Firestore.firestore().collection(Firebase.usersWhoLikedMe).document(currentUserId).collection(Firebase.users).addSnapshotListener { snapshot, error in
            if let _ = error { return }
                        
            snapshot?.documentChanges.forEach({ change in
                let user = User(dictionary: change.document.data())
                
                if change.type == .added {
                    self.checkIfAlreadyMatch(currentUserId: currentUserId, otherUserId: user.uid) { match in
                        if !match {
                            users.removeAll()
                            users.append(user)
                            addedCompletion(.success(users))
                        }
                    }
                } else if change.type == .removed {
                    removedCompletion(user)
                }
            })
        }
    }
    
    private func checkIfAlreadyMatch(currentUserId: String, otherUserId: String, completion: @escaping (Bool) -> Void) {
        Firestore.firestore().collection(Firebase.matches_messages).document(currentUserId).collection(Firebase.matches).document(otherUserId).getDocument { snapshot, error in
            if let snapshot = snapshot {
                if snapshot.exists {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
}
