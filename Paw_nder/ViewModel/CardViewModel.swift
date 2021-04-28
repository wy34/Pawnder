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
    
    var imageTappedHandler: ((String, Int) -> Void)?
    
    var firstImageUrl: String {
        guard let imageUrlsDictionary = user.imageUrls else { return "" }
        print(imageUrlsDictionary["1"] ?? "")
        return imageUrlsDictionary["1"] ?? ""
    }
    
    var imageUrls: [String] {
        guard let imageUrlsDictionary = user.imageUrls else { return [""] }
        let sortedKeys = imageUrlsDictionary.keys.sorted()
        let sortedUrls = sortedKeys.map({ imageUrlsDictionary[$0] ?? "" })
        return imageUrlsDictionary.count == 0 ? [""] : sortedUrls
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
        imageIndex = min(imageIndex + 1, imageUrls.count - 1)
        imageTappedHandler?(imageUrls[imageIndex], imageIndex)
    }
    
    func showPrevImage() {
        imageIndex = max(0, imageIndex - 1)
        imageTappedHandler?(imageUrls[imageIndex], imageIndex)
    }
    
    func setupTextualInformation() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: user.name, attributes: [.font: UIFont.systemFont(ofSize: 30, weight: .bold), .foregroundColor: UIColor.white])
        attributedString.append(NSAttributedString(string: "  \(user.age ?? "")\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .regular), .foregroundColor: UIColor.white]))
        attributedString.append(NSAttributedString(string: user.breed ?? "N/A", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .regular), .foregroundColor: UIColor.white]))
        return attributedString
    }
}
