//
//  CardViewModel.swift
//  Paw_nder
//
//  Created by William Yeung on 4/20/21.
//

import UIKit

class CardViewModel {
    // MARK: - Properties
    var user: User!
    
    private var imageIndex = 0
        
    var firstImageUrl: String {
        guard let imageUrlsDictionary = user.imageUrls else { return "" }
        return imageUrlsDictionary["1"] ?? ""
    }
    
    var imageUrls: [String] {
        guard let imageUrlsDictionary = user.imageUrls else { return [""] }
        let sortedKeys = imageUrlsDictionary.keys.sorted()
        let sortedUrls = sortedKeys.map({ imageUrlsDictionary[$0] ?? "" })
        return imageUrlsDictionary.count == 0 ? [""] : sortedUrls
    }
    
    var userInfo: (uid: String, name: String, age: Int?, breed: String?, gender: Gender, bio: String?) {
        return (user.uid, user.name, user.age, user.breed, user.gender, user.bio)
    }
    
    var userAge: String {
        if let age = user.age {
            if age == 0 {
                return "N/A"
            } else if age > 1 {
                return "\(age) YRS"
            } else {
                return "\(age) YR"
            }
        }
        
        return "N/A"
    }
    
    var userBreedAge: String {
        return "\(user.breed?.uppercased() ?? "N/A")  •  \(userAge)"
    }
    
    var userBreedAgeColor: UIColor {
        return user.gender == .male ? Colors.lightBlue : Colors.lightRed
    }
    
    var locationName: String {
        return user?.locationName ?? ""
    }
    
    // MARK: - Init
    init(user: User) {
        self.user = user
    }
}
