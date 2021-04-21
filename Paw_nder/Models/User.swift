//
//  User.swift
//  Paw_nder
//
//  Created by William Yeung on 4/20/21.
//

import Foundation

struct User {
    var name: String
    var age: Int
    var breed: String
    let imageNames: [String]
    
    func toCardViewModel() -> CardViewModel {
        return CardViewModel(user: self)
    }
}
