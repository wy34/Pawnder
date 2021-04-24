//
//  UIView.swift
//  Paw_nder
//
//  Created by William Yeung on 4/19/21.
//

import UIKit

enum Side {
    case top, right, bottom, left
}

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
    func fill(superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superView.topAnchor),
            self.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: superView.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: superView.leadingAnchor)
        ])
    }
    
    func fill(superView: UIView, withPaddingOnAllSides padding: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superView.topAnchor, constant: padding),
            self.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -padding),
            self.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -padding),
            self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: padding)
        ])
    }
    
    func anchor(top: NSLayoutYAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, paddingTop:  CGFloat = 0, paddingTrailing: CGFloat = 0, paddingBottom: CGFloat = 0, paddingLeading: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -paddingTrailing).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: paddingLeading).isActive = true
        }
    }
    
    func setDimension(wConst: CGFloat? = nil, hConst: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let wConst = wConst {
            widthAnchor.constraint(equalToConstant: wConst).isActive = true
        }
        
        if let hConst = hConst {
            heightAnchor.constraint(equalToConstant: hConst).isActive = true
        }
    }
    
    func setDimension(width: NSLayoutDimension? = nil, height: NSLayoutDimension? = nil, wMult: CGFloat = 1, hMult: CGFloat = 1) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let width = width {
            widthAnchor.constraint(equalTo: width, multiplier: wMult).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalTo: height, multiplier: hMult).isActive = true
        }
    }
    
    func makePerfectSquare(anchor: NSLayoutDimension, multiplier: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        
        widthAnchor.constraint(equalTo: anchor, multiplier: multiplier).isActive = true
        heightAnchor.constraint(equalTo: anchor, multiplier: multiplier).isActive = true
    }
    
    func center(x: NSLayoutXAxisAnchor? = nil, y: NSLayoutYAxisAnchor? = nil, xPadding: CGFloat = 0, yPadding: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let x = x {
            centerXAnchor.constraint(equalTo: x, constant: xPadding).isActive = true
        }
        
        if let y = y {
            centerYAnchor.constraint(equalTo: y, constant: yPadding).isActive = true
        }
    }
    
    func center(to view2: UIView, by attribute: NSLayoutConstraint.Attribute, withMultiplierOf mult: CGFloat = 1) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: view2, attribute: attribute, multiplier: mult, constant: 0).isActive = true
    }
    
    func addBorderTo(side: Side, bgColor: UIColor, dimension: CGFloat) {
        let border = PawView(bgColor: bgColor)
        border.translatesAutoresizingMaskIntoConstraints = false
        addSubview(border)
        
        let topConstraint = border.topAnchor.constraint(equalTo: self.topAnchor)
        let trailingConstraint = border.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        let bottomConstraint = border.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        let leadingConstraint = border.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let widthConstraint = border.widthAnchor.constraint(equalToConstant: dimension)
        let heightConstraint = border.heightAnchor.constraint(equalToConstant: dimension)
        
        switch side {
            case .top:
                NSLayoutConstraint.activate([leadingConstraint, topConstraint, trailingConstraint, heightConstraint])
            case .right:
                NSLayoutConstraint.activate([topConstraint, trailingConstraint, bottomConstraint, widthConstraint])
            case .bottom:
                NSLayoutConstraint.activate([leadingConstraint, bottomConstraint, trailingConstraint, heightConstraint])
            case .left:
                NSLayoutConstraint.activate([topConstraint, leadingConstraint, bottomConstraint, widthConstraint])
        }
    }
    
//    func showLoader() {
//        let spinner = UIActivityIndicatorView(style: .large)
//        spinner.color = .blue
//        spinner.startAnimating()
//        spinner.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(spinner)
//        spinner.center(x: centerXAnchor, y: centerYAnchor)
//    }
}
