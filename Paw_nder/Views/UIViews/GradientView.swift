//
//  GradientView.swift
//  Paw_nder
//
//  Created by William Yeung on 4/28/21.
//

import UIKit

class GradientView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [lightRed.cgColor, bgWhite.cgColor]
        gradientLayer.startPoint = .init(x: 0.5, y: 0)
        gradientLayer.endPoint = .init(x: 0.5, y: 1)
        gradientLayer.frame = self.frame
        layer.addSublayer(gradientLayer)
    }
}
