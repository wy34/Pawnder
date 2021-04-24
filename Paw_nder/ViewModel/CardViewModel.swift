//
//  CardViewModel.swift
//  Paw_nder
//
//  Created by William Yeung on 4/20/21.
//

import UIKit

class CardViewModel {
    // MARK: - Properties
    private var user: User!
    
    private var imageIndex = 0
    
    var imageTappedHandler: ((UIImage, Int) -> Void)?
    
    var firstImageUrl: String {
        return user.imageNames.first ?? ""
    }
    
    var images: [UIImage] {
        return user.imageNames.map({ i in UIImage(named: bob1)! })
    }
    
    var infoText: NSAttributedString {
        return setupTextualInformation()
    }
    
    // MARK: - Init
    init(user: User) {
        self.user = user
    }
    
    // MARK: - Helpers
    func showNextImage() {
        imageIndex = min(imageIndex + 1, images.count - 1)
        imageTappedHandler?(images[imageIndex], imageIndex)
    }
    
    func showPrevImage() {
        imageIndex = max(0, imageIndex - 1)
        imageTappedHandler?(images[imageIndex], imageIndex)
    }
    
    func setupTextualInformation() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: user.name, attributes: [.font: UIFont.systemFont(ofSize: 30, weight: .bold), .foregroundColor: UIColor.white])
        attributedString.append(NSAttributedString(string: "  \(user.age)\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .regular), .foregroundColor: UIColor.white]))
        attributedString.append(NSAttributedString(string: user.breed, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .regular), .foregroundColor: UIColor.white]))
        return attributedString
    }
}
