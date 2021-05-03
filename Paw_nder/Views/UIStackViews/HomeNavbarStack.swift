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
        self.spacing = spacing
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
    }
    
    // MARK: - Helpers
    private func layoutUI() {
        let views = [refreshBtn, UIView(), heartImageView, UIView(), filterBtn]
        views.forEach({ addArrangedSubview($0) })
        heartImageView.setDimension(wConst: 45, hConst: 45)
    }
    
    private func setupButtonActions() {
        refreshBtn.addTarget(self, action: #selector(handleUserTapped), for: .touchUpInside)
        filterBtn.addTarget(self, action: #selector(handleFilterTapped), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    @objc func handleUserTapped() {
        delegate?.handleRefreshTapped()
    }
    
    @objc func handleFilterTapped() {
        delegate?.handleFilterTapped()
    }
}
