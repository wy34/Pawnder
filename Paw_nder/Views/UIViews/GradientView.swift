//
//  GradientView.swift
//  Paw_nder
//
//  Created by William Yeung on 4/28/21.
//

import UIKit

class GradientView: UIView {
    var color1: UIColor
    var color2: UIColor
    
    override init(frame: CGRect) {
        self.color1 = lightRed
        self.color2 = bgWhite
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    init(color1: UIColor, color2: UIColor) {
        self.color1 = color1
        self.color2 = color2
        super.init(frame: .zero)
    }
    
    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        gradientLayer.startPoint = .init(x: 0.5, y: 0)
        gradientLayer.endPoint = .init(x: 0.5, y: 1)
        gradientLayer.frame = self.frame
        layer.addSublayer(gradientLayer)
    }
}
