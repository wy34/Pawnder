//
//  ViewController.swift
//  Paw_nder
//
//  Created by William Yeung on 4/19/21.
//

import UIKit
import CoreLocation
import Firebase

class HomeVC: LoadingViewController {
    // MARK: - Properties
    var locationManager = LocationManager.shared
    var homeViewModel = HomeViewModel()
    var currentTopCardView: CardView?
    var topCardView: CardView?
    var previousCardView: CardView?
    var isFirstLocation = true
    
    // MARK: - Views
    private let navbarView = PawView()
    private lazy var navbarStack = HomeNavbarStack(distribution: .fillEqually)
    
    private let filterViewLauncher = FilterViewLauncher()

    private let matchingView = MatchingViewLauncher()

    private let cardsDeckView = PawView()
    
    private let bottomControlsView = PawView()
    private let bottomControlsStack = HomeBottomControlsStack(distribution: .fillEqually, alignment: .top)
    
    private lazy var mainStack = PawStackView(views: [navbarView, cardsDeckView, bottomControlsView], axis: .vertical, alignment: .center)
    
    private let emptyStackImageView = PawImageView(image: crying, contentMode: .scaleAspectFit)
    private let emptyStackLabel = PawLabel(text: "Empty Stack. Switch up your preferences or try again later.", textColor: .black, font: .systemFont(ofSize: 14, weight: .medium), alignment: .center)
    private lazy var emptyStack = PawStackView(views: [emptyStackImageView, emptyStackLabel], spacing: 5, axis: .vertical)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        configureUI()
        setupAuthStateChangeListener()
        setupNotificationObservers()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = bgLightGray
        mainStack.bringSubviewToFront(cardsDeckView)
        navbarStack.delegate = self
        bottomControlsStack.delegate = self
        emptyStackLabel.numberOfLines = 0
    }
    
    private func layoutUI() {
        edgesForExtendedLayout = []
        view.addSubviews(emptyStack, mainStack)
        emptyStack.center(x: view.centerXAnchor, y: view.centerYAnchor)
        emptyStack.setDimension(width: view.widthAnchor, wMult: 0.75)
        emptyStackImageView.setDimension(wConst: 25, hConst: 25)
        
        mainStack.anchor(top: view.topAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, paddingTop: 15, paddingBottom: 15)
        
        navbarView.setDimension(width: view.widthAnchor, height: view.heightAnchor, hMult: 0.125)
        navbarView.addSubview(navbarStack)
        navbarStack.center(to: navbarView, by: .centerY, withMultiplierOf: 1.35)
        navbarStack.anchor(trailing: navbarView.trailingAnchor, leading: navbarView.leadingAnchor)

        bottomControlsView.setDimension(width: view.widthAnchor, height: view.heightAnchor, wMult: 0.6, hMult: 0.125)
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
                self?.setupLocationServices()
            } else {
                self?.locationManager.locationManager.stopUpdatingLocation()
                self?.presentLoginScreen()
            }
        }
    }
    
    private func setupLocationServices() {
        locationManager.locationManager.delegate = self
        locationManager.checkLocationServices(delegate: self, completion: { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        })
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
        present(navContoller, animated: true, completion: nil)
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
        
        #warning("If no cards, ie: no users match age pref., disabel all buttons on that page and show some sort of a message")
        if cardViews.count == 0 {
            print("no cards")
        }
    }
    
    private func performSwipeAnimationWhenPressed(translation: CGFloat, rotation: CGFloat) {
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
    
    private func addSwipeDataWhenPressed(for otherUserId: String, like: Bool) {
        FirebaseManager.shared.addUserSwipe(for: otherUserId, like: like) { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Error", message: error.localizedDescription)
                return
            }
        }
    }
    
    func swipeWhenPressed(like: Bool) {
        guard let topCardView = topCardView else { return }
        let translation: CGFloat = like ? 700 : -700
        let rotation: CGFloat = like ? 15 : -15
        performSwipeAnimationWhenPressed(translation: translation, rotation: rotation)
        addSwipeDataWhenPressed(for: topCardView.userId, like: like)
    }
    
    // MARK: - Selectors
    @objc func handleNewUserRegistered() {
        setupHomeContent()
        setupLocationServices()
    }
    
    @objc func handleUpdatedSettings() { 
        homeViewModel.fetchUsers()
    }
    
    @objc func handleMatch() {
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
        swipeWhenPressed(like: false)
    }
    
    func handleLikeTapped() {
        swipeWhenPressed(like: true)
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
        currentTopCardView = topCardView
        topCardView = topCardView?.nextCardView
    }
    
    func showAboutVC(cardViewModel: CardViewModel?) {
        let aboutVC = AboutVC()
        aboutVC.homeVC = self
        aboutVC.aboutVM = AboutViewModel(cardViewModel: cardViewModel)
        aboutVC.modalPresentationStyle = .fullScreen
        present(aboutVC, animated: true, completion: nil)
    }
}

// MARK: - CLLocationManagerDelegate
extension HomeVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !isFirstLocation {
            showUpdateNewLocationAlert()
        }
        
        isFirstLocation = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationManager.checkLocationAuthorization { error in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    private func showUpdateNewLocationAlert() {
        let title = "New Location Detected"
        let message = "Would you like to update to this new location? You can always do this in settings as well."
        showAlert(title: title, message: message, leftButtonTitle: "No", rightButtonTitle: "Yes") { [weak self] alertAction in
            guard let self = self else { return }
            self.locationManager.saveUserLocation { error in
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
}
