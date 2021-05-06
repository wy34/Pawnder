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
    var topCardView: CardView?
    var previousCardView: CardView?
    
    // MARK: - Views
    private let navbarView = PawView()
    private lazy var navbarStack = HomeNavbarStack(distribution: .fillEqually)
    
    private let filterViewLauncher = FilterViewLauncher()

    private let cardsDeckView = PawView()
    
    private let bottomControlsView = PawView()
    private let bottomControlsStack = HomeBottomControlsStack(distribution: .fillEqually, alignment: .top)
    
    private lazy var mainStack = PawStackView(views: [navbarView, cardsDeckView, bottomControlsView], axis: .vertical, alignment: .center)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        configureUI()
        setupAuthStateChangeListener()
        setupNotificationObservers()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = bgLightGray
        mainStack.bringSubviewToFront(cardsDeckView)
        navbarStack.delegate = self
        bottomControlsStack.delegate = self
    }
    
    private func layoutUI() {
        edgesForExtendedLayout = []
        view.addSubviews(mainStack)
        mainStack.anchor(top: view.topAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, paddingTop: 15, paddingBottom: 15)
        
        navbarView.setDimension(width: view.widthAnchor, height: view.heightAnchor, hMult: 0.125)
        navbarView.addSubview(navbarStack)
        navbarStack.center(to: navbarView, by: .centerY, withMultiplierOf: 1.35)
        navbarStack.anchor(trailing: navbarView.trailingAnchor, leading: navbarView.leadingAnchor)

        bottomControlsView.setDimension(width: view.widthAnchor, height: view.heightAnchor, wMult: 0.5, hMult: 0.125)
        bottomControlsView.addSubview(bottomControlsStack)
        bottomControlsStack.fill(superView: bottomControlsView)

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
    
    func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewUserRegistered), name: Notification.Name.didRegisterNewUser, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdatedSettings), name: Notification.Name.didSaveSettings, object: nil)
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
            self.topCardView = nil
            self.createCardDeck()
            NotificationCenter.default.post(Notification(name: .didFetchUsers))
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
            cardsDeckView.sendSubviewToBack($0)
            $0.fill(superView: cardsDeckView)
            self.previousCardView?.nextCardView = $0
            self.previousCardView = $0
            if self.topCardView == nil { self.topCardView = $0 }
        })
    }
    
    // MARK: - Selectors
    @objc func handleNewUserRegistered() {
        setupHomeContent()
    }
    
    @objc func handleUpdatedSettings() {
        homeViewModel.fetchUsers()
    }
}

// MARK: - HomeNavbarStackDelegate
extension HomeVC: HomeNavbarStackDelegate {
    func handleRefreshTapped() {
        homeViewModel.fetchUsers()
    }
    
    func handleFilterTapped() {
        filterViewLauncher.showFilterView()
    }
}

// MARK: - HomeBottomControlsDelegate
extension HomeVC: HomeBottomControlsStackDelegate {
    func handleDislikeTapped() {
        print("should swipe left")
    }
    
    func handleLikeTapped() {
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: [.curveEaseOut]) {
            let degrees = 30 * CGFloat.pi / 180
            self.topCardView?.transform = CGAffineTransform(translationX: 800, y: 0).rotated(by: degrees)
        } completion: { _ in
            self.topCardView?.removeFromSuperview()
            self.topCardView = self.topCardView?.nextCardView
        }
        
        NotificationCenter.default.post(Notification(name: .didLikedUser))
    }
}
#warning("issue with dragging -> pressing like -> resetting -> only resetting last card")
// MARK: - CardViewDelegate
extension HomeVC: CardViewDelegate {
    func resetTopCardView() {
        topCardView = topCardView?.nextCardView
    }
    
    func showAboutVC(cardViewModel: CardViewModel?) {
        let aboutVC = AboutVC()
        aboutVC.aboutVM = AboutViewModel(cardViewModel: cardViewModel)
        aboutVC.modalPresentationStyle = .fullScreen
        present(aboutVC, animated: true, completion: nil)
    }
}
