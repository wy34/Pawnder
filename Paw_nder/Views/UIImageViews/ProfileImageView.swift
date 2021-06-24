//
//  ProfileImageView.swift
//  Paw_nder
//
//  Created by William Yeung on 4/22/21.
//

import UIKit
import SwiftUI

class ProfileImageView: UIView {
    // MARK: - Views
    private let containerView = PawView(bgColor: Colors.bgWhite)
    private let defaultImageView = PawImageView(image: Assets.placeholderProfile, contentMode: .scaleAspectFit)
    private let label = PawLabel(text: "Select Photo", font: .systemFont(ofSize: 18, weight: .bold), alignment: .center)
    private lazy var stack = PawStackView(views: [defaultImageView, label], axis: .vertical)
    private let pickedImageView = PawImageView(image: UIImage(), contentMode: .scaleAspectFill)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helpers
    private func layoutUI() {
        addSubviews(containerView, pickedImageView)
        containerView.fill(superView: self)
        pickedImageView.fill(superView: self)
        
        containerView.addSubview(stack)
        stack.fill(superView: containerView, withPaddingOnAllSides: 25)
    }
    
    func setProfileImage(uiImage: UIImage) {
        pickedImageView.image = uiImage
    }
}
