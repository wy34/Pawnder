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
    var age: Int?
    var breed: String?
    var bio: String?
    var imageUrls: [String: String]?
    var minAgePreference: Int?
    var maxAgePreference: Int?
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.name = dictionary["fullName"] as? String ?? ""
        self.age = dictionary["age"] as? Int ?? 0
        self.breed = dictionary["breed"] as? String ?? "N/A"
        self.bio = dictionary["bio"] as? String ?? "N/A"
        self.imageUrls = dictionary["imageUrls"] as? [String: String]
        self.minAgePreference = dictionary["minAgePreference"] as? Int
        self.maxAgePreference = dictionary["maxAgePreference"] as? Int
    }
    
    func toCardViewModel() -> CardViewModel {
        return CardViewModel(user: self)
    }
}
