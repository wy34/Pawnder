//
//  HomeNavbarStack.swift
//  Paw_nder
//
//  Created by William Yeung on 4/19/21.
//

import UIKit

protocol HomeNavbarStackDelegate: AnyObject {
    func handleRefreshTapped()
    func handleFilterTapped()
}

class HomeNavbarStack: UIStackView {
    // MARK: - Properties
    weak var delegate: HomeNavbarStackDelegate?
    
    // MARK: - Views
    private let refreshBtn = PawButton(image: UIImage(named: "refresh")!.withRenderingMode(.alwaysTemplate), tintColor: .gray)
    private let heartImageView = PawImageView(image: icon, contentMode: .scaleAspectFit)
    private let filterBtn = PawButton(image: UIImage(named: "filter")!.withRenderingMode(.alwaysTemplate), tintColor: .gray)
    
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
        setupNotificationObserver()
        self.spacing = spacing
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Helpers
    private func layoutUI() {
        let views = [refreshBtn, UIView(), heartImageView, UIView(), filterBtn]
        views.forEach({ addArrangedSubview($0) })
        heartImageView.setDimension(wConst: 45, hConst: 45)
    }
    
    private func setupButtonActions() {
        refreshBtn.addTarget(self, action: #selector(handleRefreshTapped), for: .touchUpInside)
        filterBtn.addTarget(self, action: #selector(handleFilterTapped), for: .touchUpInside)
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleSwipeUndo), name: .didUndoPrevSwipe, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disableButtons), name: .didDragCard, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enableButtons), name: .didFinishDraggingCard, object: nil)
    }
    
    // MARK: - Selectors
    @objc func handleRefreshTapped() {
        refreshBtn.isEnabled = false
        delegate?.handleRefreshTapped()
    }
    
    @objc func handleFilterTapped() {
        delegate?.handleFilterTapped()
    }
    
    @objc func handleSwipeUndo() {
        refreshBtn.isEnabled = true
    }
    
    @objc func disableButtons() {
        refreshBtn.isEnabled = false
        filterBtn.isEnabled = false
    }
    
    @objc func enableButtons() {
        refreshBtn.isEnabled = true
        filterBtn.isEnabled = true
    }
}
