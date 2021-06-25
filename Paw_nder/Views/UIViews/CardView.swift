//
//  CardView.swift
//  Paw_nder
//
//  Created by William Yeung on 4/20/21.
//

import UIKit

protocol CardViewDelegate: AnyObject {
    func resetTopCardView()
    func showAboutVC(cardViewModel: CardViewModel?)
    func handleCardSwipe(userId: String, like: Bool)
}

class CardView: LoadingView {
    // MARK: - Properties
    var cardVM: CardViewModel?
    private var selectedBarColor = UIColor.white
    private var deselectedBarColor = #colorLiteral(red: 0.817677021, green: 0.8137882352, blue: 0.8206836581, alpha: 0.5)
    
    weak var delegate: CardViewDelegate?
    
    var prevCardView: CardView?
    var nextCardView: CardView?
    
    var userId: String {
        return cardVM?.userInfo.uid ?? ""
    }
    
    var userName: String {
        return cardVM?.userInfo.name ?? ""
    }
    
    var firstImageUrl: String? {
        return cardVM?.firstImageUrl
    }
    
    // MARK: - Views
    private let containerView = PawView(bgColor: .white, cornerRadius: 25)
    
    private let photoCountIcon = PawButton(image: SFSymbols.photos, tintColor: .white, font: .boldSystemFont(ofSize: 22))
    private let photoCountLabel = PawLabel(text: "3", textColor: .white, font: .boldSystemFont(ofSize: 20))
    private lazy var photoCountStack = PawStackView(views: [photoCountIcon, photoCountLabel], spacing: 5, distribution: .fillEqually, alignment: .fill)

    private let profileImageView = PawImageView(image: nil, contentMode: .scaleAspectFill)
    private let nameLabel = PawLabel(text: "Rex", textColor: .black, font: .boldSystemFont(ofSize: 26), alignment: .left)
    private let breedAgeLabel = PawLabel(text: "Golden Retriever", textColor: Colors.lightRed, font: .systemFont(ofSize: 12, weight: .semibold), alignment: .left)
    private lazy var topStack = PawStackView(views: [nameLabel, breedAgeLabel], spacing: 5, axis: .vertical, distribution: .fillEqually, alignment: .fill)
    
    private let locationLabel = IconLabel(text: "Los Angelos, CA", image: Assets.location, cornerRadius: 10)
    
    private lazy var overallLabelStack = PawStackView(views: [topStack, locationLabel], spacing: 5, axis: .vertical, distribution: .fill, alignment: .leading)
    private let aboutButton = PawButton(image: SFSymbols.info, tintColor: .black, font: .systemFont(ofSize: 25, weight: .medium))
    
    private let likeDislikeTintView = PawView(bgColor: .green)
    private let likeDislikeIndicator = PawImageView(image: SFSymbols.heart, contentMode: .scaleAspectFit, tintColor: .white)
    
    private let temporaryCoverView = PawView(bgColor: Colors.lightGray, cornerRadius: 25)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
        configureUI()
        setupGestures()
        startLoadingCards()
        
        likeDislikeIndicator.alpha = 0
        likeDislikeTintView.alpha = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        photoCountIcon.imageView?.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = 25
        profileImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.layer.shadowOpacity = 0.25
        containerView.layer.shadowOffset = .init(width: 0, height: 0)
        aboutButton.addTarget(self, action: #selector(handleAboutTapped), for: .touchUpInside)
        likeDislikeTintView.layer.cornerRadius = 25
    }
    
    private func layoutUI() {
        addSubview(containerView)
        containerView.fill(superView: self, withPadding: .init(top: 30, left: 30, bottom: 15, right: 30))
        
        containerView.addSubviews(profileImageView, overallLabelStack, aboutButton, likeDislikeTintView, likeDislikeIndicator, temporaryCoverView)
        profileImageView.setDimension(width: containerView.widthAnchor, height: containerView.widthAnchor, hMult: 1.15)
        profileImageView.anchor(top: containerView.topAnchor, trailing: containerView.trailingAnchor, leading: containerView.leadingAnchor)
        overallLabelStack.setDimension(width: containerView.widthAnchor, wMult: 0.7)
        overallLabelStack.anchor(top: profileImageView.bottomAnchor, bottom: containerView.bottomAnchor, leading: containerView.leadingAnchor, paddingTop: 12, paddingBottom: 15, paddingLeading: 18)
        topStack.setDimension(height: overallLabelStack.heightAnchor, hMult: 0.6)
        aboutButton.anchor(top: overallLabelStack.topAnchor, trailing: containerView.trailingAnchor, bottom: overallLabelStack.bottomAnchor, leading: overallLabelStack.trailingAnchor, paddingLeading: 10)
        likeDislikeTintView.fill(superView: containerView)
        likeDislikeIndicator.center(x: containerView.centerXAnchor, y: containerView.centerYAnchor)
        temporaryCoverView.fill(superView: containerView)
        
        profileImageView.addSubview(photoCountStack)
        photoCountStack.setDimension(wConst: 50, hConst: 50)
        photoCountStack.anchor(top: profileImageView.topAnchor, leading: profileImageView.leadingAnchor, paddingTop: 6, paddingLeading: 16)
    }
    
    private func startLoadingCards() {
        showLoader()
        isUserInteractionEnabled = false
    }
    
    private func stopLoadingCards() {
        dismissLoader()
        isUserInteractionEnabled = true
        temporaryCoverView.isHidden = true
    }
    
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        addGestureRecognizer(panGesture)
    }
    
    func setupCardWith(cardVM: CardViewModel) {
        self.cardVM = cardVM
        photoCountLabel.text = "\(cardVM.imageUrls.count)"
        profileImageView.setImage(imageUrlString: cardVM.firstImageUrl) { self.stopLoadingCards() }
        nameLabel.text = cardVM.userInfo.name
        breedAgeLabel.text = cardVM.userBreedAge
        breedAgeLabel.textColor = cardVM.userBreedAgeColor
        locationLabel.text = cardVM.locationName
    }
    
    func showLikeDislikeIndicators(translation: CGPoint) {
        let likeIndicator = SFSymbols.heart.applyingSymbolConfiguration(.init(font: .systemFont(ofSize: 75, weight: .bold)))
        let dislikeIndicator = SFSymbols.xmark.applyingSymbolConfiguration(.init(font: .systemFont(ofSize: 75, weight: .bold)))
        
        likeDislikeIndicator.image = translation.x > 0 ? likeIndicator : dislikeIndicator
        likeDislikeTintView.backgroundColor = translation.x > 0 ? .systemGreen : Colors.lightRed
        
        likeDislikeIndicator.alpha = abs(translation.x) / 100
        likeDislikeTintView.alpha = abs(translation.x) / 600
    }
    
    private func swipeCardWith(translationX: CGFloat, like: Bool) {
        self.transform = CGAffineTransform(translationX: translationX, y: 0)
        self.delegate?.handleCardSwipe(userId: self.userId, like: like)
        self.delegate?.resetTopCardView()
    }
    
    // MARK: - Selectors
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        NotificationCenter.default.post(Notification(name: .didDragCard))
        
        if gesture.state == .changed {
            transform = CGAffineTransform(rotationAngle: (translation.x / 20) * .pi / 180).translatedBy(x: translation.x, y: translation.y)
            showLikeDislikeIndicators(translation: translation)
        } else if gesture.state == .ended {
            NotificationCenter.default.post(Notification(name: .didFinishDraggingCard))
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: [.curveEaseOut]) {
                self.likeDislikeIndicator.alpha = 0
                self.likeDislikeTintView.alpha = 0
                
                if translation.x > 175 {
                    self.swipeCardWith(translationX: 800, like: true)
                } else if translation.x < -175 {
                    self.swipeCardWith(translationX: -800, like: false)
                } else {
                    self.transform = .identity
                }
            } completion: { (_) in
                if translation.x > 175 || translation.x < -175 {
                    self.removeFromSuperview()
                }
            }
        }
    }
    
    @objc private func handleAboutTapped() {
        delegate?.showAboutVC(cardViewModel: cardVM)
    }
}
