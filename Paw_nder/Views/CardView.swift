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
    func configureUI() {
        imageView.layer.cornerRadius = 15
    }
    
    func layoutUI() {
        addSubview(imageView)
        imageView.fill(superView: self, withPaddingOnAllSides: 10)
    }
    
    func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        addGestureRecognizer(panGesture)
    }
    
    // MARK: - Selectors
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        if gesture.state == .changed {
            self.transform = CGAffineTransform(rotationAngle: (translation.x / 20) * .pi / 180).translatedBy(x: translation.x, y: translation.y)
        } else if gesture.state == .ended {
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: [.curveEaseOut]) {
                if translation.x > 200 {
                    self.transform = CGAffineTransform(translationX: 1000, y: 0)
                } else if translation.x < -200 {
                    self.transform = CGAffineTransform(translationX: -1000, y: 0)
                } else {
                    self.transform = .identity
                }
            } completion: { (_) in
                self.transform = .identity
            }
        }
    }
}
