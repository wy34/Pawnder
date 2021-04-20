//
//  CardViewModel.swift
//  Paw_nder
//
//  Created by William Yeung on 4/20/21.
//

import UIKit

struct CardViewModel {
    // MARK: - Properties
    private var user: User!
    
    var image: UIImage {
        return UIImage(named: user.imageName)!
    }
    
    var infoText: NSAttributedString {
        return setupTextualInformation()
    }
    
    // MARK: - Init
    init(user: User) {
        self.user = user
    }
    
    // MARK: - Helpers
    func setupTextualInformation() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: user.name, attributes: [.font: UIFont.systemFont(ofSize: 30, weight: .bold), .foregroundColor: UIColor.white])
        attributedString.append(NSAttributedString(string: "  \(user.age)\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .regular), .foregroundColor: UIColor.white]))
        attributedString.append(NSAttributedString(string: user.breed, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .regular), .foregroundColor: UIColor.white]))
        return attributedString
    }
}
