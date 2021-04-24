//
//  ViewController.swift
//  Paw_nder
//
//  Created by William Yeung on 4/19/21.
//

import UIKit

class HomeVC: LoadingViewController {
    // MARK: - Properties
    var homeViewModel = HomeViewModel()
    
    // MARK: - Views
    private let navbarView = PawView()
    private lazy var navbarStack = HomeNavbarStack(distribution: .fillEqually)
    
    private let cardsDeckView = PawView()
    
    private let bottomControlsView = PawView()
    private let bottomControlsStack = HomeBottomControlsStack(distribution: .fillEqually)
    
    private lazy var mainStack = PawStackView(views: [navbarView, cardsDeckView, bottomControlsView], axis: .vertical, alignment: .fill)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        configureUI()
        setupFetchObserver()
        homeViewModel.fetchUsers()
    }

    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = bgWhite
        mainStack.bringSubviewToFront(cardsDeckView)
    }
    
    private func layoutUI() {
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
    
    func setupFetchObserver() {
        homeViewModel.fetchUserHandler = { [weak self] in
            guard let self = self else { return }
            self.createCardDeck()
        }
    }
    
    private func createCardDeck() {
        homeViewModel.cardViewModels.forEach({ cardVM in
            let cardView = CardView()
            cardView.setupCardWith(cardVM: cardVM)
            cardsDeckView.addSubview(cardView)
            cardView.fill(superView: cardsDeckView)
        })
    }
}

