//
//  MatchingView.swift
//  Paw_nder
//
//  Created by William Yeung on 5/7/21.
//

import UIKit
import SwiftUI

protocol MatchingViewLauncherDelegate: AnyObject {
    func handleMessageButtonTapped()
}

class MatchingViewLauncher: UIView {
    // MARK: - Properties
    var matchedUserInfo: (String?, String?, String?) {
        didSet {
            guard let likedUserName = matchedUserInfo.0, let likedUserImageUrl = matchedUserInfo.1,  let currentUserImageUrl = matchedUserInfo.2 else { return }
            matchingUsersLabel.text = "You and \(likedUserName) liked each other"
            user1ImageView.setImage(imageUrlString: currentUserImageUrl, completion: nil)
            user2ImageView.setImage(imageUrlString: likedUserImageUrl, completion: nil)
        }
    }

    var backToSwipeButtonSide: CGFloat = 55
    weak var delegate: MatchingViewLauncherDelegate?
    
    // MARK: - Views
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    private let matchTitleLabel = PawLabel(text: "It's a Match!", textColor: .white, font: markerFont(47), alignment: .center)
    private let matchingUsersLabel = PawLabel(text: "", textColor: .white, font: markerFont(18), alignment: .center)
    private lazy var headingLabelStack = PawStackView(views: [matchTitleLabel, matchingUsersLabel], axis: .vertical, alignment: .fill)
    
    private let user1ImageView = PawImageView(image: nil, contentMode: .scaleAspectFill)
    private let user2ImageView = PawImageView(image: nil, contentMode: .scaleAspectFill)
    
    private let messageButton = PawButton(title: "Send a Message", textColor: .white, bgColor: Colors.lightRed)
    private let backToSwipeButton = PawButton(image: SFSymbols.rightArrow, tintColor: Colors.lightRed, font: .systemFont(ofSize: 18, weight: .bold))
    private lazy var buttonStack = PawStackView(views: [messageButton, backToSwipeButton], spacing: 50, axis: .vertical, distribution: .fill)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addActionsAndGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        visualEffectView.alpha = 0
        
        [user1ImageView, user2ImageView, messageButton].forEach { item in
            item.layer.cornerRadius = 15
            item.clipsToBounds = true
            item.layer.borderWidth = 2
            item.layer.borderColor = UIColor.white.cgColor
        }

        user1ImageView.transform = CGAffineTransform(translationX: -700, y: -25).rotated(by: 50 * CGFloat.pi / 180)
        user2ImageView.transform = CGAffineTransform(translationX: 700, y: 25).rotated(by: -50 * CGFloat.pi / 180)

        backToSwipeButton.backgroundColor = .white
        backToSwipeButton.layer.cornerRadius = backToSwipeButtonSide/2
        
        messageButton.titleLabel?.font = markerFont(18)
    }
    
    private func layoutUI() {
        let contentView = visualEffectView.contentView
        contentView.addSubviews(headingLabelStack, user1ImageView, user2ImageView, buttonStack)
        
        headingLabelStack.setDimension(width: contentView.widthAnchor, height: contentView.heightAnchor, hMult: 0.1)
        headingLabelStack.center(to: contentView, by: .centerY, withMultiplierOf: 0.36)
        
        [user1ImageView, user2ImageView].forEach { item in
            item.setDimension(width: contentView.widthAnchor, height: contentView.heightAnchor, wMult: 0.4, hMult: 0.225)
            item.center(to: headingLabelStack, by: .centerY, withMultiplierOf: 2.5)
            item.center(to: contentView, by: .centerX, withMultiplierOf: item == user1ImageView ? 0.45 : 1.55)
        }
            
        buttonStack.center(to: user2ImageView, by: .centerY, withMultiplierOf: 1.7)
        buttonStack.setDimension(width: contentView.widthAnchor)
        messageButton.setDimension(width: contentView.widthAnchor, height: contentView.widthAnchor, wMult: 0.7, hMult: 0.12)
        backToSwipeButton.setDimension(wConst: backToSwipeButtonSide, hConst: backToSwipeButtonSide)
    }
    
    func showMatchingView() {
        if let keywindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            keywindow.addSubview(visualEffectView)
            visualEffectView.frame = keywindow.frame
            
            configureUI()
            layoutUI()
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .curveEaseOut) {
                self.visualEffectView.alpha = 1
                self.user1ImageView.transform = CGAffineTransform(translationX: 40, y: -25).rotated(by: -15 * CGFloat.pi / 180)
                self.user2ImageView.transform = CGAffineTransform(translationX: -40, y: 25).rotated(by: 15 * CGFloat.pi / 180)
            }
        }
    }
    
    private func addActionsAndGestures() {
        messageButton.addTarget(self, action: #selector(goToMessageVC), for: .touchUpInside)
        backToSwipeButton.addTarget(self, action: #selector(dismissMatchingView), for: .touchUpInside)
    }

    // MARK: - Selector
    @objc func goToMessageVC() {
        dismissMatchingView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            self.delegate?.handleMessageButtonTapped()
        }
    }
    
    @objc func dismissMatchingView() {
        UIView.animate(withDuration: 0.25) {
            self.visualEffectView.alpha = 0
        } completion: { _ in
            self.visualEffectView.removeFromSuperview()
            self.user1ImageView.removeFromSuperview()
            self.user2ImageView.removeFromSuperview()
        }
    }
}
