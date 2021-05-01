//
//  HomeViewModel.swift
//  Paw_nder
//
//  Created by William Yeung on 4/23/21.
//

import Foundation
import Firebase

class HomeViewModel {
    // MARK: - Properties
    var users = [User]()
    var cardViewModels = [CardViewModel(user: .init(dictionary: ["": ""]))]
    var fetchUserHandler: (() -> Void)?
    
    // MARK: - Helpers
    func fetchUsers() {
        FirebaseManager.shared.fetchCurrentUser { result in
            switch result {
                case .success(let user):
                    FirebaseManager.shared.fetchUsers(currentUser: user) { result in
                        switch result {
                            case .success(let cardViewModels):
                                self.cardViewModels = cardViewModels
                                self.fetchUserHandler?()
                            case .failure(let error):
                               print(error)
                        }
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
}