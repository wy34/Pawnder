//
//  HomeNavbarStack.swift
//  Paw_nder
//
//  Created by William Yeung on 4/19/21.
//

import UIKit

protocol HomeNavbarStackDelegate: class {
    func handleUserTapped()
    func handleMessageTapped()
}

class HomeNavbarStack: UIStackView {
    // MARK: - Properties
    weak var delegate: HomeNavbarStackDelegate?
    
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
        setupButtonActions()
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
    
    private func setupButtonActions() {
        userBtn.addTarget(self, action: #selector(handleUserTapped), for: .touchUpInside)
        messageBtn.addTarget(self, action: #selector(handleMessageTapped), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    @objc func handleUserTapped() {
        delegate?.handleUserTapped()
    }
    
    @objc func handleMessageTapped() {
        
    }
}
