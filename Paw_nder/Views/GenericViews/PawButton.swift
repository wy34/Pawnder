//
//  PawButton.swift
//  Paw_nder
//
//  Created by William Yeung on 4/19/21.
//

import UIKit

class PawButton: UIButton {
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    init(title: String, textColor: UIColor = .black, bgColor: UIColor) {
        super.init(frame: .zero)
        self.init(type: .system)
        self.setTitle(title, for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.backgroundColor = bgColor
    }
    
    init(image: UIImage, tintColor: UIColor = .black) {
        super.init(frame: .zero)
        self.setImage(image, for: .normal)
        self.tintColor = tintColor
    }
    
    init(image: UIImage) {
        super.init(frame: .zero)
        self.init(type: .system)
        self.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    init(image: UIImage, tintColor: UIColor, font: UIFont) {
        super.init(frame: .zero)
        self.init(type: .system)
        self.tintColor = tintColor
        self.setImage(image.applyingSymbolConfiguration(.init(font: font))!.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    init(title: String, textColor: UIColor = .black, font: UIFont) {
        super.init(frame: .zero)
        self.init(type: .system)
        self.setTitle(title, for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.titleLabel?.font = font
    }
}
