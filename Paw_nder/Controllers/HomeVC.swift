//
//  ViewController.swift
//  Paw_nder
//
//  Created by William Yeung on 4/19/21.
//

import UIKit
import Firebase

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
        setupAuthStateChangeListener()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = bgWhite
        mainStack.bringSubviewToFront(cardsDeckView)
        navbarStack.delegate = self
        bottomControlsStack.delegate = self
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
        
        let cardView = CardView()
        cardsDeckView.addSubview(cardView)
        cardView.fill(superView: cardsDeckView)
    }
    
    func setupAuthStateChangeListener() {
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if let _ = user {
                self?.setupHomeContent()
            } else {
                self?.presentLoginScreen()
            }
        }
    }
    
    func setupHomeContent() {
        createCardDeck()
        setupFetchObserver()
        homeViewModel.fetchUsers()
    }
    
    func presentLoginScreen() {
        let loginVC = LoginVC()
        let navContoller = UINavigationController(rootViewController: loginVC)
        navContoller.modalPresentationStyle = .fullScreen
        navContoller.modalTransitionStyle = .crossDissolve
        self.present(navContoller, animated: true, completion: nil)
    }
    
    func setupFetchObserver() {
        homeViewModel.fetchUserHandler = { [weak self] in
            guard let self = self else { return }
            self.createCardDeck()
        }
    }
    
    private func createCardDeck() {
        cardsDeckView.subviews.forEach({ $0.removeFromSuperview() })
        
        var cardViews = [CardView]()
        
        homeViewModel.cardViewModels.forEach({ cardVM in
            let cardView = CardView()
            cardView.delegate = self
            cardView.setupCardWith(cardVM: cardVM)
            cardViews.append(cardView)
        })
        
        cardViews.reversed().forEach({
            cardsDeckView.addSubview($0)
            $0.fill(superView: cardsDeckView)
        })
    }
}

// MARK: - HomeNavbarStackDelegate
extension HomeVC: HomeNavbarStackDelegate {
    func handleUserTapped() {
        let settingsVC = SettingsVC()
        settingsVC.delegate = self
        let navController = UINavigationController(rootViewController: settingsVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    func handleMessageTapped() {
        
    }
}

// MARK: - HomeBottomControlsDelegate
extension HomeVC: HomeBottomControlsStackDelegate {
    func handleRefreshTapped() {
        homeViewModel.fetchUsers()
    }
    
    func handleDismissTapped() {
        
    }
    
    func handleStarTapped() {
        
    }
    
    func handleHeartTapped() {
        
    }
    
    func handleLightningTapped() {
        
    }
}

// MARK: - SettingsVCDelegate
extension HomeVC: SettingsVCDelegate {
    func updateCardDeck() {
        homeViewModel.fetchUsers()
    }
}

// MARK: - CardViewDelegate
extension HomeVC: CardViewDelegate {
    func showAboutVC(cardViewModel: CardViewModel?) {
        let aboutVC = AboutVC()
        aboutVC.aboutVM = AboutViewModel(cardViewModel: cardViewModel)
        aboutVC.modalPresentationStyle = .fullScreen
        present(aboutVC, animated: true, completion: nil)
    }
}
