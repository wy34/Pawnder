//
//  AboutViewModel.swift
//  Paw_nder
//
//  Created by William Yeung on 4/30/21.
//

import UIKit

class AboutViewModel {
    var cardViewModel: CardViewModel?
    
    init(cardViewModel: CardViewModel?) {
        self.cardViewModel = cardViewModel
    }
    
    var firstImageUrl: String {
        return cardViewModel?.firstImageUrl ?? ""
    }
    
    var imageUrls: [String] {
        return cardViewModel?.imageUrls ?? [""]
    }
    
    var userInfo: (uid: String, name: String, age: Int?, breed: String?, gender: Gender, bio: String?) {
        return cardViewModel!.userInfo
    }
    
    var userGender: (text: String, textColor: UIColor, bgColor: UIColor) {
        let gender = userInfo.gender
        
        if gender == .male {
            return (gender.rawValue, lightBlue, .blue)
        } else {
//            return (gender.rawValue, lightRed)
            return (gender.rawValue, lightRed, #colorLiteral(red: 1, green: 0.4016966522, blue: 0.4617980123, alpha: 0.1497695853))
        }
    }
    
    var userBreedAge: String {
        return cardViewModel?.userBreedAge ?? ""
    }
}
