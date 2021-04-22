//
//  PawTextField.swift
//  Paw_nder
//
//  Created by William Yeung on 4/21/21.
//

import UIKit

class PawTextField: UITextField {
    // MARK: - Properties
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    init(placeholder: String, bgColor: UIColor = .clear, cornerRadius: CGFloat = 0) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.backgroundColor = bgColor
        self.layer.cornerRadius = cornerRadius
    }
    
//    // MARK: - Padding
//    override func editingRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: padding)
//    }
//
//    override func textRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: padding)
//    }
//
//    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: padding)
//    }
}
