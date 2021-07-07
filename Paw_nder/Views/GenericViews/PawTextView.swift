//
//  PawTextView.swift
//  Paw_nder
//
//  Created by William Yeung on 5/10/21.
//

import UIKit

class PawTextView: UITextView {
    // MARK: - Init
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    init(placeholder: String, textColor: UIColor, bgColor: UIColor) {
        super.init(frame: .zero, textContainer: nil)
        self.text = placeholder
        self.textColor = textColor
        self.backgroundColor = bgColor
    }
}
