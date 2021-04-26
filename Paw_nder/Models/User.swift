//
//  User.swift
//  Paw_nder
//
//  Created by William Yeung on 4/20/21.
//

import Foundation

struct User {
    var uid: String
    var name: String
    var age: String?
    var breed: String?
    var imageUrls: [String]?
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.name = dictionary["fullName"] as? String ?? ""
        self.age = dictionary["age"] as? String ?? "N/A"
        self.breed = dictionary["breed"] as? String ?? "N/A"
        self.imageUrls = dictionary["imageUrlString"] as? [String] ?? []
    }
    
    func toCardViewModel() -> CardViewModel {
        return CardViewModel(user: self)
    }
}
