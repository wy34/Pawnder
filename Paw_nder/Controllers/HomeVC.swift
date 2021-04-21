//
//  ViewController.swift
//  Paw_nder
//
//  Created by William Yeung on 4/19/21.
//

import UIKit

class HomeVC: UIViewController {
    // MARK: - Properties
    private let cardViewModels: [CardViewModel] = {
        let users = [
            User(name: "Vikram", age: 2, breed: "Husky", imageNames: [vikram1]),
            User(name: "Bob", age: 5, breed: "Golden Retriever", imageNames: [bob1, bob2, bob3, bob4])
        ]
        return users.map({ $0.toCardViewModel() })
    }()
    
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
        createCardDeck()
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
    
    private func createCardDeck() {
        cardViewModels.forEach({ cardVM in
            let cardView = CardView()
            cardView.setupCardWith(cardVM: cardVM)
            cardsDeckView.addSubview(cardView)
            cardView.fill(superView: cardsDeckView)
        })
    }
}

