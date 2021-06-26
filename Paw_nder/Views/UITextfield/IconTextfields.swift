//
//  IconTextfields.swift
//  Paw_nder
//
//  Created by William Yeung on 4/28/21.
//

import UIKit

class IconTextfield: PawTextField {
    // MARK: - Init
    init(placeholder: String, font: UIFont, icon: UIImage) {
        super.init(placeholder: placeholder, font: font)
        layoutIcon(icon)
        textColor = .gray
        autocorrectionType = .no
        textContentType = .oneTimeCode
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helper
    func layoutIcon(_ icon: UIImage) {
        let view = PawView(bgColor: .clear)
        let icon = PawImageView(image: icon.withRenderingMode(.alwaysTemplate), contentMode: .scaleAspectFit)
        icon.tintColor = .lightGray
        
        let stack = PawStackView(views: [icon, view])
        stack.setDimension(wConst: 30)
        
        leftViewMode = .always
        leftView = stack
    }
}
