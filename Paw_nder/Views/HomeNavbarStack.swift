//
//  HomeNavbarStack.swift
//  Paw_nder
//
//  Created by William Yeung on 4/19/21.
//

import UIKit

class HomeNavbarStack: UIStackView {
    // MARK: - Views
    private let userBtn = PawButton(image: user)
    private let heartImageView = PawImageView(image: icon, contentMode: .scaleAspectFit)
    private let messageBtn = PawButton(image: message)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    init(spacing: CGFloat = 0, axis: NSLayoutConstraint.Axis = .horizontal, distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .center) {
        super.init(frame: .zero)
        layoutUI()
        self.spacing = spacing
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
    }
    
    // MARK: - Helpers
    private func layoutUI() {
        let views = [userBtn, UIView(), heartImageView, UIView(), messageBtn]
        views.forEach({ addArrangedSubview($0) })
        heartImageView.setDimension(wConst: 45, hConst: 45)
    }
}
