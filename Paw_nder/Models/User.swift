//
//  User.swift
//  Paw_nder
//
//  Created by William Yeung on 4/20/21.
//

import Foundation
import CoreLocation

struct User {
    var uid: String
    var name: String
    var age: Int?
    var breed: String?
    var bio: String?
    var location: String?
    var gender: Gender
    var imageUrls: [String: String]?
    var genderPreference: Gender?
    var minAgePreference: Int?
    var maxAgePreference: Int?
    var distancePreference: Int?
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.name = dictionary["fullName"] as? String ?? ""
        self.age = dictionary["age"] as? Int ?? 0
        self.breed = dictionary["breed"] as? String ?? "N/A"
        self.bio = dictionary["bio"] as? String ?? "N/A"
        self.gender = Gender(rawValue: dictionary["gender"] as? String ?? "") ?? .male
        self.imageUrls = dictionary["imageUrls"] as? [String: String]
        self.genderPreference = Gender(rawValue: dictionary["genderPreference"] as? String ?? "All") ?? .all
        self.minAgePreference = dictionary["minAgePreference"] as? Int
        self.maxAgePreference = dictionary["maxAgePreference"] as? Int
        self.distancePreference = dictionary["distancePreference"] as? Int
    }
    
    func toCardViewModel() -> CardViewModel {
        return CardViewModel(user: self)
    }
}
