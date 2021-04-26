//
//  UIImageView.swift
//  Paw_nder
//
//  Created by William Yeung on 4/23/21.
//

import UIKit

extension UIImageView {
    func setImage(imageUrlString: String, completion: (() -> Void)?) {
        FirebaseManager.shared.downloadImage(urlString: imageUrlString) { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                self.image = image
                completion?()
            }
        }
    }
}
