//
//  LikeVCViewModel.swift
//  Paw_nder
//
//  Created by William Yeung on 6/22/21.
//

import Foundation
import Firebase

class LikesViewModel {
    func fetchUsersWhoLikedMe(addedCompletion: @escaping (Result<[User], Error>) -> Void, removedCompletion: @escaping (User?) -> Void) {
        let currentUserId = Auth.auth().currentUser!.uid
        var users = [User]()
        
        Firestore.firestore().collection(fsUsersWhoLikedMe).document(currentUserId).collection("users").addSnapshotListener { snapshot, error in
            if let error = error { print(error.localizedDescription); return }
                        
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
        Firestore.firestore().collection(fsMatches_Messages).document(currentUserId).collection(fsMatches).document(otherUserId).getDocument { snapshot, error in
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
