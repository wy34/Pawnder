//
//  PawImageView.swift
//  Paw_nder
//
//  Created by William Yeung on 4/19/21.
//

import UIKit

class PawImageView: UIImageView {
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    init(image: UIImage?, contentMode: UIImageView.ContentMode) {
        super.init(frame: .zero)
        self.image = image
        self.contentMode = contentMode
        self.clipsToBounds = true
    }
    
    init(image: UIImage?, contentMode: UIImageView.ContentMode, tintColor: UIColor) {
        super.init(frame: .zero)
        self.image = image
        self.tintColor = tintColor
        self.contentMode = contentMode
        self.clipsToBounds = true
    }
}
