//
//  PawLabel.swift
//  Paw_nder
//
//  Created by William Yeung on 4/19/21.
//

import UIKit

class PawLabel: UILabel {
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    init(text: String, textColor: UIColor = .black, font: UIFont, alignment: NSTextAlignment = .left) {
        super.init(frame: .zero)
        self.text = text
        self.textColor = textColor
        self.font = font
    }
}
