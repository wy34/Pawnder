//
//  CardView.swift
//  Paw_nder
//
//  Created by William Yeung on 4/20/21.
//

import UIKit

class CardView: UIView {
    // MARK: - Views
    private let imageView = PawImageView(image: dog1, contentMode: .scaleAspectFill)
    private let infoLabel = PawLabel(attributedText: .init())
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
        configureUI()
        setupPanGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        imageView.layer.cornerRadius = 15
    }
    
    private func layoutUI() {
        addSubview(imageView)
        imageView.fill(superView: self, withPaddingOnAllSides: 15)
        
        imageView.addSubview(infoLabel)
        infoLabel.anchor(trailing: imageView.trailingAnchor, bottom: imageView.bottomAnchor, leading: imageView.leadingAnchor, paddingTrailing: 20, paddingBottom: 20, paddingLeading: 20)
    }
    
    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        addGestureRecognizer(panGesture)
    }
    
    func setupCardWith(cardVM: CardViewModel) {
        imageView.image = cardVM.image
        infoLabel.attributedText = cardVM.infoText
    }
    
    // MARK: - Selectors
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        if gesture.state == .changed {
            self.transform = CGAffineTransform(rotationAngle: (translation.x / 20) * .pi / 180).translatedBy(x: translation.x, y: translation.y)
        } else if gesture.state == .ended {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: [.curveEaseOut]) {
                if translation.x > 200 {
                    self.transform = CGAffineTransform(translationX: 800, y: 0)
                } else if translation.x < -200 {
                    self.transform = CGAffineTransform(translationX: -800, y: 0)
                } else {
                    self.transform = .identity
                }
            } completion: { (_) in
                if translation.x > 200 || translation.x < -200 {
                    self.removeFromSuperview()
                }
            }
        }
    }
}
