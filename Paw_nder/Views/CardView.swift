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
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
    }
    
    // MARK: - Selectors
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            let translation = gesture.translation(in: self)
            self.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
        } else if gesture.state == .ended {
            UIView.animate(withDuration: 0.76, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: [.curveEaseOut]) {
                self.transform = .identity
            }
        }
    }
}
