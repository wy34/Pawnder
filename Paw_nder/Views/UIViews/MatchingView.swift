//
//  MatchingView.swift
//  Paw_nder
//
//  Created by William Yeung on 5/7/21.
//

import UIKit
import SwiftUI

class MatchingView: UIView {
    // MARK: - Properties
    var backToSwipeButtonSide: CGFloat = 60
    
    // MARK: - Views
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    private let matchTitleLabel = PawLabel(text: "It's a Match!", textColor: .white, font: .systemFont(ofSize: 45, weight: .bold), alignment: .center)
    private let matchingUsersLabel = PawLabel(text: "You and Kate liked each other", textColor: .white, font: .systemFont(ofSize: 16, weight: .bold), alignment: .center)
    private lazy var headingLabelStack = PawStackView(views: [matchTitleLabel, matchingUsersLabel], axis: .vertical, alignment: .fill)
    
    private let user1ImageView = PawImageView(image: UIImage(named: bob1)!, contentMode: .scaleAspectFill)
    private let user2ImageView = PawImageView(image: UIImage(named: bob2)!, contentMode: .scaleAspectFill)
    
    private let messageButton = PawButton(title: "Send a Message", textColor: .white, bgColor: .red)
    private let backToSwipeButton = PawButton(image: SFSymbols.rightArrow, tintColor: lightRed, font: .systemFont(ofSize: 18, weight: .bold))
    private lazy var buttonStack = PawStackView(views: [messageButton, backToSwipeButton], spacing: 50, axis: .vertical, distribution: .fill)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        layoutUI()
        addGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helpers
    func configureUI() {
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
    }
    
    func layoutUI() {
        let contentView = visualEffectView.contentView
        contentView.addSubviews(headingLabelStack, user1ImageView, user2ImageView, buttonStack)
        
        headingLabelStack.setDimension(width: contentView.widthAnchor, height: contentView.heightAnchor, hMult: 0.1)
        headingLabelStack.center(to: contentView, by: .centerY, withMultiplierOf: 0.35)
        
        [user1ImageView, user2ImageView].forEach { item in
            item.setDimension(width: contentView.widthAnchor, height: contentView.heightAnchor, wMult: 0.4, hMult: 0.225)
            item.center(to: headingLabelStack, by: .centerY, withMultiplierOf: 2.6)
            item.center(to: contentView, by: .centerX, withMultiplierOf: item == user1ImageView ? 0.45 : 1.55)
        }
            
        buttonStack.center(to: user2ImageView, by: .centerY, withMultiplierOf: 1.73)
        buttonStack.setDimension(width: contentView.widthAnchor)
        messageButton.setDimension(width: contentView.widthAnchor, height: contentView.heightAnchor, wMult: 0.7, hMult: 0.05)
        backToSwipeButton.setDimension(wConst: backToSwipeButtonSide, hConst: backToSwipeButtonSide)
    }
    
    func showMatchingView() {
        if let keywindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            keywindow.addSubview(visualEffectView)
            visualEffectView.frame = keywindow.frame
            
            UIView.animate(withDuration: 0.5) {
                self.visualEffectView.alpha = 1
                self.user1ImageView.transform = CGAffineTransform(translationX: 40, y: -25).rotated(by: -15 * CGFloat.pi / 180)
                self.user2ImageView.transform = CGAffineTransform(translationX: -40, y: 25).rotated(by: 15 * CGFloat.pi / 180)
            }
        }
    }
    
    func addGestureRecognizer() {
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissMatchingView)))
    }

    // MARK: - Selector
    @objc func dismissMatchingView() {
        UIView.animate(withDuration: 0.25) {
            self.visualEffectView.alpha = 0
        } completion: { _ in
            self.visualEffectView.removeFromSuperview()
        }
    }
}






// MARK: - Previews
struct Login: UIViewRepresentable {
    func makeUIView(context: Context) -> MatchingView {
        let loginVC = MatchingView()
        return loginVC
    }
    
    func updateUIView(_ uiView: MatchingView, context: Context) {
        
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
            .edgesIgnoringSafeArea(.all)
    }
}