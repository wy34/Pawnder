//
//  PaddedLabel.swift
//  Paw_nder
//
//  Created by William Yeung on 4/24/21.
//

import UIKit

class PaddedLabel: UILabel {
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    init(text: String, font: UIFont) {
        super.init(frame: .zero)
        self.text = text
        self.font = font
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 0, dy: 0))
    }
}
