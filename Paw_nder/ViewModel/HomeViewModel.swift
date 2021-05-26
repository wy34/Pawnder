//
//  HomeViewModel.swift
//  Paw_nder
//
//  Created by William Yeung on 4/23/21.
//

import Foundation
import Firebase
import CoreLocation

class HomeViewModel {
    // MARK: - Properties
    var currentUser: User?
    var users = [User]()
    var cardViewModels = [CardViewModel(user: .init(dictionary: ["": ""]))]
    var swipes = [String: Int]()
    var fetchUserHandler: (() -> Void)?
    
    // MARK: - Helpers
    func fetchUsers() {
        FirebaseManager.shared.fetchCurrentUser { result in
            switch result {
                case .success(let user):
                    self.currentUser = user
                    self.fetchSwipes(for: user)
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func fetchSwipes(for user: User) {
        Firestore.firestore().collection("swipes").document(user.uid).getDocument { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            #warning("can refactor")
            if let swipes = snapshot?.data() as? [String: Int] {
                self.swipes = swipes
                self.fetchUsers(currentUser: user)
            } else {
                self.fetchUsers(currentUser: user)
            }
        }
    }
    
    func fetchUsers(currentUser: User) {
        FirebaseManager.shared.fetchUsers(currentUser: currentUser, swipes: self.swipes) { result in
            switch result {
                case .success(let cardViewModels):
                    self.cardViewModels = cardViewModels
                    self.fetchUserHandler?()
                case .failure(let error):
                   print(error)
            }
        }
    }
}
