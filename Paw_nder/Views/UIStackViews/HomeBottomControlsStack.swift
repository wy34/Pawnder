//
//  HomeBottomControlsStackView.swift
//  Paw_nder
//
//  Created by William Yeung on 4/19/21.
//

import UIKit

protocol HomeBottomControlsStackDelegate: AnyObject {
    func handleRefreshTapped()
    func handleDismissTapped()
    func handleStarTapped()
    func handleHeartTapped()
    func handleLightningTapped()
}

class HomeBottomControlsStack: UIStackView {
    // MARK: - Properties
    weak var delegate: HomeBottomControlsStackDelegate?
    
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
        setupButtonActions()
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
    
    private func setupButtonActions() {
        refreshBtn.addTarget(self, action: #selector(handleRefreshTapped), for: .touchUpInside)
//        dismissBtn
//        starBtn
        heartBtn.addTarget(self, action: #selector(handleHeartTapped), for: .touchUpInside)
//        lightningBtn
    }
    
    // MARK: - Selectors
    @objc func handleRefreshTapped() {
        delegate?.handleRefreshTapped()
    }
    
    @objc func handleHeartTapped() {
        delegate?.handleHeartTapped()
    }
}
