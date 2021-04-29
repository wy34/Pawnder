//
//  IconTextfields.swift
//  Paw_nder
//
//  Created by William Yeung on 4/28/21.
//

import UIKit
import SwiftUI

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


// MARK: - Previews
struct Home: UIViewRepresentable {
    func makeUIView(context: Context) -> IconTextfield {
        let homeVC = IconTextfield(placeholder: "Email", font: .systemFont(ofSize: 16, weight: .medium), icon: person)
        return homeVC
    }
    
    func updateUIView(_ uiView: IconTextfield, context: Context) {
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 40))
            .edgesIgnoringSafeArea(.all)
    }
}
