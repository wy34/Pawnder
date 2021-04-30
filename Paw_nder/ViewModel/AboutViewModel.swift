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
}
