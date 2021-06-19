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
    private let emptyStackLabel = PawLabel(text: "End of stack. Switch up your preferences or try again later.", textColor: .black, font: .systemFont(ofSize: 14, weight: .medium), alignment: .center)
    private lazy var emptyStack = PawStackView(views: [emptyStackImageView, emptyStackLabel], spacing: 5, axis: .vertical)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        configureUI()
        setupAuthStateChangeListener()
        setupNotificationObservers()
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
        filterViewLauncher.filterVC.delegate = self
    }
    
    private func layoutUI() {
        edgesForExtendedLayout = []
        view.addSubviews(emptyStack, mainStack)
        emptyStack.center(x: view.centerXAnchor, y: view.centerYAnchor)
        emptyStack.setDimension(width: view.widthAnchor, wMult: 0.75)
        emptyStackImageView.setDimension(wConst: 25, hConst: 25)
        
        mainStack.fill(superView: view, withPadding: .init(top: 15, left: 0, bottom: 15, right: 0))
        
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
            if let error = error { self?.showAlert(title: "Error", message: error.localizedDescription) }
        })
    }
    
    private func setupHomeContent() {
        createCardDeck()
        setupFetchObserver()
        homeViewModel.fetchCurrentUser()
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

        cardViews.forEach({
            cardsDeckView.addSubview($0)
            cardsDeckView.sendSubviewToBack($0)
            $0.fill(superView: cardsDeckView)
            self.previousCardView?.nextCardView = $0
            self.previousCardView = $0
            if self.topCardView == nil { self.topCardView = $0 }
        })
    }
    
    private func performSwipeAnimationWhenPressed(translation: CGFloat, rotation: CGFloat) {
        let duration = translation > 0 ? 0.5 : 1.0
        
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
        currentTopCardView?.showLikeDislikeIndicators(translation: .init(x: translation/4, y: 0))
        
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
        homeViewModel.fetchCurrentUser()
    }
    
    @objc func handleMatch() {
//        let matchedUserId: String
//        let name: String
//        let imageUrlString: String
//        let startedConversation: Bool

//
//        let match = Match(dictionary: ["name": currentTopCardView?.userName, "imageUrlString": currentTopCardView?.firstImageUrl, "matchedUserId": currentTopCardView?.userId, "startedConversation": false])
        matchingView.delegate = self
        matchingView.matchedUserInfo = (currentTopCardView?.userName, currentTopCardView?.firstImageUrl, homeViewModel.currentUser?.imageUrls?["1"])
        matchingView.showMatchingView()
    }
}

// MARK: - HomeNavbarStackDelegate
extension HomeVC: HomeNavbarStackDelegate {
    func handleUndoTapped() {
        NotificationCenter.default.post(Notification(name: .didUndoPrevSwipe))
        
        if let previousTopCardView = currentTopCardView {
            let alertTitle = "Undo Swipe"
            let alertMessage = "Are you sure you want to undo your last swipe? Any conversations between you and that user will be deleted."
            showAlert(title: alertTitle, message: alertMessage, leftButtonTitle: "No", rightButtonTitle: "Yes") { [weak self] _ in
                guard let self = self else { return }
                let newCard = CardView()
                newCard.delegate = self
                newCard.setupCardWith(cardVM: previousTopCardView.cardVM!)
                self.cardsDeckView.addSubview(newCard)
                newCard.fill(superView: self.cardsDeckView)
                newCard.nextCardView = self.topCardView
                self.topCardView = newCard
                self.currentTopCardView = nil

                FirebaseManager.shared.undoLastSwipe(otherUserId: newCard.userId) { [weak self] error in
                    if let error = error { self?.showAlert(title: "Error", message: error.localizedDescription) }
                }
            }
        }
    }
    
    func handleFilterTapped() {
        filterViewLauncher.showFilterViewFor(user: homeViewModel.currentUser)
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

// MARK: - FilterVCDelegate
extension HomeVC: FilterVCDelegate {
    func didPressSaveFilter() {
        showLoader()
        SettingsViewModel.shared.updateUserInfo { [weak self] error in
            if let error = error { self?.showAlert(title: "Error", message: error.localizedDescription) }
            self?.dismissLoader()
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension HomeVC: CLLocationManagerDelegate {
    #warning("If a user changes location, maybe automaticcaly reflect that in other users deck")
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations[0].cityAndStateName(completion: { locationName, err in
            let sameLocation = self.homeViewModel.currentUser?.locationName == locationName
            if !sameLocation { self.showUpdateNewLocationAlert() }
        })
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

// MARK: - MatchingViewLauncherDelegate
extension HomeVC: MatchingViewLauncherDelegate {
    func handleMessageButtonTapped() {
        let match = Match(dictionary: ["name": currentTopCardView?.userName ?? "",
                                       "imageUrlString": currentTopCardView?.firstImageUrl ?? "",
                                       "matchedUserId": currentTopCardView?.userId ?? "",
                                       "startedConversation": false])
        let messageLogVC = MessageLogVC()
        messageLogVC.match = match
        messageLogVC.navigationItem.leftBarButtonItem = BarButtonWithHandler(barButtonSystemItem: .done, actionHandler: { _ in
            self.dismiss(animated: true, completion: nil)
        })
        let navController = UINavigationController(rootViewController: messageLogVC)
        present(navController, animated: true, completion: nil)
    }
}
