//
//  HomeBottomControlsStackView.swift
//  Paw_nder
//
//  Created by William Yeung on 4/19/21.
//

import UIKit

protocol HomeBottomControlsStackDelegate: AnyObject {
    func handleDislikeTapped()
    func handleLikeTapped()
}

class HomeBottomControlsStack: UIStackView {
    // MARK: - Properties
    weak var delegate: HomeBottomControlsStackDelegate?
    
    // MARK: - Views
    private let dislikeBtn = PawButton(image: dismiss)
    private let likeBtn = PawButton(image: heart)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        layoutUI()
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    init(spacing: CGFloat = 0, axis: NSLayoutConstraint.Axis = .horizontal, distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .center) {
        super.init(frame: .zero)
        configureUI()
        layoutUI()
        setupButtonActions()
        self.spacing = spacing
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
    }
    
    // MARK: - Helpers
    private func configureUI() {
        likeBtn.imageView?.contentMode = .scaleAspectFit
        dislikeBtn.imageView?.contentMode = .scaleAspectFit
        likeBtn.layer.shadowOpacity = 0.25
        dislikeBtn.layer.shadowOpacity = 0.25
        likeBtn.layer.shadowOffset = .init(width: 0, height: 0)
        dislikeBtn.layer.shadowOffset = .init(width: 0, height: 0)
    }
    
    private func layoutUI() {
        let views = [dislikeBtn, likeBtn]
        views.forEach({ self.addArrangedSubview($0) })
    }
    
    private func setupButtonActions() {
        dislikeBtn.addTarget(self, action: #selector(handleDislikeTapped), for: .touchUpInside)
        likeBtn.addTarget(self, action: #selector(handleHeartTapped), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    @objc func handleDislikeTapped() {
        delegate?.handleDislikeTapped()
    }
    
    @objc func handleHeartTapped() {
        delegate?.handleLikeTapped()
    }
}
