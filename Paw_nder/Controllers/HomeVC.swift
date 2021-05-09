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
    var currentTopCardView: CardView?
    var topCardView: CardView?
    var previousCardView: CardView?
    
    // MARK: - Views
    private let navbarView = PawView()
    private lazy var navbarStack = HomeNavbarStack(distribution: .fillEqually)
    
    private let filterViewLauncher = FilterViewLauncher()

    private let matchingView = MatchingView()

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
    
    private func setupAuthStateChangeListener() {
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if let _ = user {
                self?.setupHomeContent()
            } else {
                self?.presentLoginScreen()
            }
        }
    }
    
    private func setupHomeContent() {
        createCardDeck()
        setupFetchObserver()
        homeViewModel.fetchUsers()
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewUserRegistered), name: Notification.Name.didRegisterNewUser, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdatedSettings), name: Notification.Name.didSaveSettings, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleMatch), name: .didFindMatch, object: nil)
    }
    
    private func presentLoginScreen() {
        let loginVC = LoginVC()
        let navContoller = UINavigationController(rootViewController: loginVC)
        navContoller.modalPresentationStyle = .fullScreen
        navContoller.modalTransitionStyle = .crossDissolve
        self.present(navContoller, animated: true, completion: nil)
    }
    
    private func setupFetchObserver() {
        homeViewModel.fetchUserHandler = { [weak self] in
            guard let self = self else { return }
            self.topCardView = nil
            self.previousCardView = nil
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
    
    private func performSwipeAnimation(translation: CGFloat, rotation: CGFloat) {
        let duration = 0.5
        
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.fillMode = .forwards
        translationAnimation.isRemovedOnCompletion = false
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = rotation * CGFloat.pi / 180
        rotationAnimation.duration = duration
        
        currentTopCardView = topCardView
        topCardView = topCardView?.nextCardView
        CATransaction.setCompletionBlock { [weak self] in
            self?.currentTopCardView?.removeFromSuperview()
        }
        
        currentTopCardView?.layer.add(translationAnimation, forKey: "translation")
        currentTopCardView?.layer.add(rotationAnimation, forKey: "rotation")
        
        CATransaction.commit()
    }
    
    private func addSwipeData(for otherUserId: String, like: Bool) {
        FirebaseManager.shared.addUserSwipe(for: otherUserId, like: like) { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Error", message: error.localizedDescription)
                return
            }
        }
    }
    
    func swipe(like: Bool) {
        guard let topCardView = topCardView else { return }
        let translation: CGFloat = like ? 700 : -700
        let rotation: CGFloat = like ? 15 : -15
        performSwipeAnimation(translation: translation, rotation: rotation)
        addSwipeData(for: topCardView.userId, like: like)
    }
    
    // MARK: - Selectors
    @objc func handleNewUserRegistered() {
        setupHomeContent()
    }
    
    @objc func handleUpdatedSettings() { 
        homeViewModel.fetchUsers()
    }
    
    @objc func handleMatch() {
//        matchingView.matchedUserInfo = (topCardView?.userName, topCardView?.firstImageUrl, homeViewModel.currentUser?.imageUrls?["1"])

        matchingView.matchedUserInfo = (currentTopCardView?.userName, currentTopCardView?.firstImageUrl, homeViewModel.currentUser?.imageUrls?["1"])
        matchingView.showMatchingView()
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
        swipe(like: false)
    }
    
    func handleLikeTapped() {
        swipe(like: true)
    }
}

// MARK: - CardViewDelegate
extension HomeVC: CardViewDelegate {
    func handleCardSwipe(userId: String, like: Bool) {
        FirebaseManager.shared.addUserSwipe(for: userId, like: like) { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    func resetTopCardView() {
        #warning("need to swipe slow for match view to display images, otherwise, currentTopCardView is nil")
        topCardView = topCardView?.nextCardView
        currentTopCardView = topCardView
        NotificationCenter.default.post(Notification(name: .didFinishDraggingCard))
    }
    
    func showAboutVC(cardViewModel: CardViewModel?) {
        let aboutVC = AboutVC()
        aboutVC.homeVC = self
        aboutVC.aboutVM = AboutViewModel(cardViewModel: cardViewModel)
        aboutVC.modalPresentationStyle = .fullScreen
        present(aboutVC, animated: true, completion: nil)
    }
}

