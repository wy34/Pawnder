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
    private var cardVM: CardViewModel?
    private var selectedBarColor = UIColor.white
    private var deselectedBarColor = #colorLiteral(red: 0.817677021, green: 0.8137882352, blue: 0.8206836581, alpha: 0.5)
    
    weak var delegate: CardViewDelegate?
    
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
    
    private let photoCountIcon = PawButton(image: SFSymbols.photos, tintColor: .white, font: .boldSystemFont(ofSize: 14))
    private let photoCountLabel = PawLabel(text: "3", textColor: .white, font: .boldSystemFont(ofSize: 14))
    private lazy var photoCountStack = PawStackView(views: [photoCountIcon, photoCountLabel], spacing: 5, distribution: .fillEqually, alignment: .fill)

    private let profileImageView = PawImageView(image: UIImage(named: bob3)!, contentMode: .scaleAspectFill)
    private let nameLabel = PawLabel(text: "Rex", textColor: .black, font: .boldSystemFont(ofSize: 26), alignment: .left)
    private let breedAgeLabel = PawLabel(text: "Golden Retriever", textColor: lightRed, font: .systemFont(ofSize: 12, weight: .semibold), alignment: .left)
    private lazy var topStack = PawStackView(views: [nameLabel, breedAgeLabel], spacing: 5, axis: .vertical, distribution: .fillEqually, alignment: .fill)
    
    private let bioLabel = PawLabel(text: "Potty trained. Loves walks and belly rubs", textColor: .black, font: .systemFont(ofSize: 16, weight: .medium), alignment: .left)
    private lazy var overallLabelStack = PawStackView(views: [topStack, bioLabel], spacing: 5, axis: .vertical, distribution: .fillEqually, alignment: .fill)
    private let aboutButton = PawButton(image: SFSymbols.info, tintColor: .black, font: .systemFont(ofSize: 20, weight: .medium))
    private let temporaryCoverView = PawView(bgColor: lightGray, cornerRadius: 25)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
        configureUI()
        setupGestures()
        startLoadingCards()
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
        bioLabel.numberOfLines = 2
    }
    
    private func layoutUI() {
        addSubview(containerView)

        containerView.anchor(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor, paddingTop: 30, paddingTrailing: 30, paddingBottom: 15, paddingLeading: 30)
        
        containerView.addSubviews(profileImageView, overallLabelStack, aboutButton, temporaryCoverView)
        profileImageView.setDimension(width: containerView.widthAnchor, height: containerView.heightAnchor, hMult: 0.74)
        profileImageView.anchor(top: containerView.topAnchor, trailing: containerView.trailingAnchor, leading: containerView.leadingAnchor)
        overallLabelStack.anchor(top: profileImageView.bottomAnchor, trailing: containerView.trailingAnchor, bottom: containerView.bottomAnchor, leading: containerView.leadingAnchor, paddingTop: 15, paddingTrailing: 15, paddingBottom: 15, paddingLeading: 15)
        aboutButton.setDimension(wConst: 50, hConst: 50)
        aboutButton.anchor(top: profileImageView.bottomAnchor, trailing: profileImageView.trailingAnchor, paddingTrailing: 5)
        temporaryCoverView.fill(superView: containerView)
        
        profileImageView.addSubview(photoCountStack)
        photoCountStack.setDimension(wConst: 45, hConst: 45)
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
        bioLabel.text = cardVM.userInfo.bio
    }
    
    // MARK: - Selectors
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        NotificationCenter.default.post(Notification(name: .didDragCard))
        
        if gesture.state == .changed {
            self.transform = CGAffineTransform(rotationAngle: (translation.x / 20) * .pi / 180).translatedBy(x: translation.x, y: translation.y)
        } else if gesture.state == .ended {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: [.curveEaseOut]) {
                if translation.x > 175 {
                    self.transform = CGAffineTransform(translationX: 800, y: 0)
                    self.delegate?.handleCardSwipe(userId: self.userId, like: true)
                } else if translation.x < -175 {
                    self.transform = CGAffineTransform(translationX: -800, y: 0)
                    self.delegate?.handleCardSwipe(userId: self.userId, like: false)
                } else {
                    self.transform = .identity
                }
            } completion: { (_) in
                if translation.x > 175 || translation.x < -175 {
                    self.removeFromSuperview()
                    self.delegate?.resetTopCardView()
                } else {
                    NotificationCenter.default.post(Notification(name: .didFinishDraggingCard))
                }
            }
        }
    }
    
    @objc private func handleAboutTapped() {
        delegate?.showAboutVC(cardViewModel: cardVM)
    }
}
