//
//  ViewController.swift
//  Paw_nder
//
//  Created by William Yeung on 4/19/21.
//

import UIKit

class HomeVC: UIViewController {
    // MARK: - Views
    private let navbarView = PawView(bgColor: #colorLiteral(red: 0.957364738, green: 0.9528102279, blue: 0.9608851075, alpha: 1))
    private lazy var navbarStack = HomeNavbarStack(distribution: .fillEqually)
    
    private let blueView = PawView(bgColor: .blue)
    
    private let bottomControlsView = PawView(bgColor: #colorLiteral(red: 0.957364738, green: 0.9528102279, blue: 0.9608851075, alpha: 1))
    private let bottomControlsStack = HomeBottomControlsStack(distribution: .fillEqually)
    
    private lazy var mainStack = PawStackView(views: [navbarView, blueView, bottomControlsView], axis: .vertical, alignment: .fill)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
    }

    // MARK: - Helpers
    func layoutUI() {
        view.addSubviews(mainStack)
        mainStack.fill(superView: view)
        
        navbarView.setDimension(width: view.widthAnchor, height: view.heightAnchor, hMult: 0.13)
        navbarView.addSubview(navbarStack)
        navbarStack.center(to: navbarView, by: .centerY, withMultiplierOf: 1.35)
        navbarStack.anchor(trailing: navbarView.trailingAnchor, leading: navbarView.leadingAnchor)
        
        bottomControlsView.setDimension(width: view.widthAnchor, height: view.heightAnchor, hMult: 0.15)
        bottomControlsView.addSubview(bottomControlsStack)
        bottomControlsStack.center(to: bottomControlsView, by: .centerY, withMultiplierOf: 0.75)
        bottomControlsStack.anchor(trailing: bottomControlsView.trailingAnchor, leading: bottomControlsView.leadingAnchor)
    }
}

