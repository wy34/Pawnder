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
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["fullName"] as? String ?? ""
        self.age = dictionary["age"] as? Int ?? 0
        self.breed = dictionary["breed"] as? String ?? ""
        self.imageNames = [dictionary["imageUrlString"] as? String ?? ""]
    }
    
    func toCardViewModel() -> CardViewModel {
        return CardViewModel(user: self)
    }
}
