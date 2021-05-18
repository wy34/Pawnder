//
//  PaddedTextField.swift
//  Paw_nder
//
//  Created by William Yeung on 5/17/21.
//

import UIKit

class PaddedTextField: UITextField {
    // MARK: - Properties
    var padding: UIEdgeInsets
    
    // MARK: - Init
    override init(frame: CGRect) {
        self.padding = .init(top: 0, left: 0, bottom: 0, right: 0)
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    init(placeholder: String, bgColor: UIColor, padding: UIEdgeInsets) {
        self.padding = padding
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.backgroundColor = bgColor
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
