//
//  MessagesVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/8/21.
//

import UIKit

class MessagesVC: UIViewController {
    // MARK: - Properties
    
    // MARK: - Views
    private let iconImageView = PawImageView(image: icon, contentMode: .scaleAspectFit)
    private let newMatchesView = NewMatchesView()
    private let userMessageContainerView = PawView(bgColor: bgLightGray)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .gray

        userMessageContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        userMessageContainerView.layer.cornerRadius = 30
    }
    
    private func layoutUI() {
        view.addSubviews(iconImageView, newMatchesView, userMessageContainerView)
        
        iconImageView.center(to: view, by: .centerX)
        iconImageView.center(to: view, by: .centerY, withMultiplierOf: 0.1875)
        iconImageView.setDimension(wConst: 45, hConst: 45)
        
        newMatchesView.anchor(top: iconImageView.bottomAnchor, trailing: view.trailingAnchor, leading: view.leadingAnchor, paddingTop: 35)
        newMatchesView.setDimension(height: view.widthAnchor, hMult: 0.25)
        
        userMessageContainerView.anchor(top: newMatchesView.bottomAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, paddingTop: 35)
    }
}
