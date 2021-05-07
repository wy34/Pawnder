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
    
    var userGender: (text: String, color: UIColor) {
        let gender = userInfo.gender
        
        if gender == .male {
            return (gender.rawValue, lightBlue)
        } else {
            return (gender.rawValue, lightRed)
        }
    }
    
    var userBreedAge: String {
        return cardViewModel?.userBreedAge ?? ""
    }
}
