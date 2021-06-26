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

class HomeBottomControlsStack: UIView {
    // MARK: - Properties
    weak var delegate: HomeBottomControlsStackDelegate?
    
    // MARK: - Views
    private let likeBtn = PawButton(image: SFSymbols.heart, tintColor: .white, font: .systemFont(ofSize: 16, weight: .bold))
    private let dislikeBtn = PawButton(image: SFSymbols.xmark, tintColor: .white, font: .systemFont(ofSize: 16, weight: .bold))
    private lazy var likeDislikeStack = PawStackView(views: [dislikeBtn, likeBtn], spacing: 12, distribution: .fillEqually, alignment: .fill)
    
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
        setupNotificationObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Helpers
    private func configureUI() {
        likeBtn.layer.cornerRadius = 45/2
        dislikeBtn.layer.cornerRadius = 45/2
        likeBtn.backgroundColor = #colorLiteral(red: 0.4704266787, green: 0.8806294799, blue: 0.6199433804, alpha: 1)
        dislikeBtn.backgroundColor = Colors.lightRed
    }
    
    private func layoutUI() {
        addSubview(likeDislikeStack)
        likeDislikeStack.center(x: centerXAnchor, y: centerYAnchor)
        likeDislikeStack.setDimension(width: widthAnchor)
        likeBtn.setDimension(hConst: 45)
    }
    
    private func setupButtonActions() {
        dislikeBtn.addTarget(self, action: #selector(handleDislikeTapped), for: .touchUpInside)
        likeBtn.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
    }
    
    private func changeButtonEnableStateTo(_ enable: Bool) {
        likeBtn.isEnabled = enable ? true : false
        dislikeBtn.isEnabled = enable ? true : false
    }
    
    private func disableLikeDislikeBy(seconds: Double) {
        changeButtonEnableStateTo(false)
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.changeButtonEnableStateTo(true)
        }
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(disableButtons), name: .didDragCard, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enableButtons), name: .didFinishDraggingCard, object: nil)
    }
    
    // MARK: - Selectors
    @objc func handleDislikeTapped() {
        delegate?.handleDislikeTapped()
        disableLikeDislikeBy(seconds: 0.15)
    }
    
    @objc func handleLikeTapped() {
        delegate?.handleLikeTapped()
        disableLikeDislikeBy(seconds: 0.15)
    }
    
    @objc func disableButtons() {
        changeButtonEnableStateTo(false)
    }
    
    @objc func enableButtons() {
        self.changeButtonEnableStateTo(true)
    }
}
