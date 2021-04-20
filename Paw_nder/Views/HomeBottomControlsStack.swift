//
//  HomeBottomControlsStackView.swift
//  Paw_nder
//
//  Created by William Yeung on 4/19/21.
//

import UIKit

class HomeBottomControlsStack: UIStackView {
    // MARK: - Views
    private let refreshBtn = PawButton(image: refresh)
    private let dismissBtn = PawButton(image: dismiss)
    private let starBtn = PawButton(image: star)
    private let heartBtn = PawButton(image: heart)
    private let lightningBtn = PawButton(image: lightning)
    
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
        let views = [refreshBtn, dismissBtn, starBtn, heartBtn, lightningBtn]
        views.forEach({ self.addArrangedSubview($0) })
    }
}
