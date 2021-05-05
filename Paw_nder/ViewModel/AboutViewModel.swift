//
//  AboutViewModel.swift
//  Paw_nder
//
//  Created by William Yeung on 4/30/21.
//

import Foundation

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
    
    var userInfo: (name: String, age: Int?, breed: String?, bio: String?) {
        return cardViewModel!.userInfo
    }
    
    var userBreedAge: String {
        return cardViewModel?.userBreedAge ?? ""
    }
}
