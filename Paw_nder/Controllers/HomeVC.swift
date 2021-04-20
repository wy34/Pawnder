//
//  ViewController.swift
//  Paw_nder
//
//  Created by William Yeung on 4/19/21.
//

import UIKit

class HomeVC: UIViewController {
    // MARK: - Views
    private let navbarView = PawView()
    private lazy var navbarStack = HomeNavbarStack(distribution: .fillEqually)
    
    private let cardsDeckView = CardView()
    
    private let bottomControlsView = PawView()
    private let bottomControlsStack = HomeBottomControlsStack(distribution: .fillEqually)
    
    private lazy var mainStack = PawStackView(views: [navbarView, cardsDeckView, bottomControlsView], axis: .vertical, alignment: .fill)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        configureUI()
    }

    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = bgWhite
        mainStack.bringSubviewToFront(cardsDeckView)
    }
    
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

