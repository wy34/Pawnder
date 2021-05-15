//
//  LoadingButton.swift
//  Paw_nder
//
//  Created by William Yeung on 4/24/21.
//

import UIKit
import SwiftUI


class ImagePickerButtonView: UIView {
    // MARK: - Properties
    
    // MARK: - Views
    let imageView = PawImageView(image: nil, contentMode: .scaleAspectFill)
    let addButton = PawButton(image: SFSymbols.plus, tintColor: .white, font: .systemFont(ofSize: 10, weight: .black))
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI(imageCornerRadius: 0)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    init(imageCornerRadius: CGFloat, tagNumber: Int) {
        super.init(frame: .zero)
        self.addButton.tag = tagNumber
        configureUI(imageCornerRadius: imageCornerRadius)
        layoutUI()
    }
    
    // MARK: - Helpers
    private func configureUI(imageCornerRadius: CGFloat) {
        imageView.backgroundColor = lightGray
        imageView.layer.cornerRadius = imageCornerRadius
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = lightTransparentGray.cgColor
        addButton.backgroundColor = lightRed
        addButton.layer.cornerRadius = 23/2
    }
    
    private func layoutUI() {
        addSubviews(imageView, addButton)
        imageView.fill(superView: self, withPaddingOnAllSides: 5)
        
        addButton.setDimension(wConst: 23, hConst: 23)
        addButton.anchor(top: imageView.topAnchor, leading: imageView.leadingAnchor, paddingTop: -5, paddingLeading: -5)
    }
}
