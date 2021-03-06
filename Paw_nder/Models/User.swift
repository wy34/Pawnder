//
//  User.swift
//  Paw_nder
//
//  Created by William Yeung on 4/20/21.
//

import Foundation
import Firebase
import CoreLocation

struct User: Equatable {
    // MARK: - Properties
    var dictionaryData: [String: Any]?
    
    var uid: String
    var tag: Int
    var name: String
    var age: Int?
    var breed: String?
    var bio: String?
    var locationName: String?
    var coordinate: CLLocation?
    var gender: Gender
    var imageUrls: [String: String]?
    var genderPreference: Gender?
    var breedPreference: String
    var minAgePreference: Int?
    var maxAgePreference: Int?
    var distancePreference: Int?
    
    // MARK: - Init
    init(dictionary: [String: Any]) {
        self.dictionaryData = dictionary
        self.uid = dictionary["uid"] as? String ?? ""
        self.tag = dictionary["tag"] as? Int ?? 0
        self.name = dictionary["fullName"] as? String ?? ""
        self.age = dictionary["age"] as? Int ?? 0
        self.breed = dictionary["breed"] as? String ?? "N/A"
        self.bio = dictionary["bio"] as? String ?? "N/A"
        self.gender = Gender(rawValue: dictionary["gender"] as? String ?? "") ?? .male
        self.imageUrls = dictionary["imageUrls"] as? [String: String]
        self.genderPreference = Gender(rawValue: dictionary["genderPreference"] as? String ?? Gender.all.rawValue) ?? .all
        self.breedPreference = dictionary["breedPreference"] as? String ?? noBreedPrefCaption
        self.minAgePreference = dictionary["minAgePreference"] as? Int
        self.maxAgePreference = dictionary["maxAgePreference"] as? Int
        self.distancePreference = dictionary["distancePreference"] as? Int ?? maxDistance
        setLocationInfo(dictionary)
    }
    
    // MARK: - Helpers
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    func toCardViewModel() -> CardViewModel {
        return CardViewModel(user: self)
    }
    
    mutating func setLocationInfo(_ dict: [String: Any]) {
        let locationDict = dict["location"] as? [String: Any]
        locationName = locationDict?["name"] as? String ?? "Location Unavailable"
        
        let geoPoint = locationDict?["coord"] as? GeoPoint
        coordinate = CLLocation(latitude: geoPoint?.latitude ?? 0.0, longitude: geoPoint?.longitude ?? 0.0)
    }
}
