//
//  CardView.swift
//  Paw_nder
//
//  Created by William Yeung on 4/20/21.
//

import UIKit

protocol CardViewDelegate: AnyObject {
    func showAboutVC(cardViewModel: CardViewModel?)
}

class CardView: LoadingView {
    // MARK: - Properties
    private var cardVM: CardViewModel?
    private var selectedBarColor = UIColor.white
    private var deselectedBarColor = #colorLiteral(red: 0.817677021, green: 0.8137882352, blue: 0.8206836581, alpha: 0.5)
    
    weak var delegate: CardViewDelegate?
    
    // MARK: - Views
    private let containerView = PawView(bgColor: .white, cornerRadius: 25)
    private let profileImageView = PawImageView(image: UIImage(named: bob3)!, contentMode: .scaleAspectFill)
    private let nameLabel = PawLabel(text: "Rex", textColor: .black, font: .boldSystemFont(ofSize: 26), alignment: .left)
    private let bioLabel = PawLabel(text: "Potty trained. Loves walks and belly rubs", textColor: .black, font: .systemFont(ofSize: 16, weight: .medium), alignment: .left)
    private let breedLabel = PawLabel(text: "Golden Retriever", textColor: lightRed, font: .systemFont(ofSize: 12, weight: .semibold), alignment: .left)
    private let ageLabel = PawLabel(text: "5.5 years", textColor: lightRed, font: .systemFont(ofSize: 12, weight: .semibold), alignment: .right)
    private lazy var bottomLabelStack = PawStackView(views: [breedLabel, ageLabel], distribution: .fillEqually, alignment: .fill)
    private lazy var overallLabelStack = PawStackView(views: [nameLabel, bioLabel, bottomLabelStack], spacing: 10, axis: .vertical, distribution: .fillEqually, alignment: .fill)
    private let aboutButton = PawButton(image: info, tintColor: .black, font: .systemFont(ofSize: 20, weight: .medium))
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
    private func configureUI() { profileImageView.layer.cornerRadius = 25
        profileImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.layer.shadowOpacity = 0.25
        containerView.layer.shadowOffset = .init(width: 0, height: 0)
        aboutButton.addTarget(self, action: #selector(handleAboutTapped), for: .touchUpInside)
    }
    
    private func layoutUI() {
        addSubview(containerView)
        containerView.setDimension(width: widthAnchor, height: heightAnchor, wMult: 0.85, hMult: 0.85)
        containerView.center(x: centerXAnchor, y: centerYAnchor)
        
        containerView.addSubviews(profileImageView, overallLabelStack, aboutButton, temporaryCoverView)
        profileImageView.setDimension(width: containerView.widthAnchor, height: containerView.heightAnchor, hMult: 0.75)
        profileImageView.anchor(top: containerView.topAnchor, trailing: containerView.trailingAnchor, leading: containerView.leadingAnchor)
        overallLabelStack.anchor(top: profileImageView.bottomAnchor, trailing: containerView.trailingAnchor, bottom: containerView.bottomAnchor, leading: containerView.leadingAnchor, paddingTop: 15, paddingTrailing: 15, paddingBottom: 15, paddingLeading: 15)
        aboutButton.setDimension(wConst: 50, hConst: 50)
        aboutButton.anchor(top: profileImageView.bottomAnchor, trailing: profileImageView.trailingAnchor, paddingTrailing: 5)
        temporaryCoverView.fill(superView: containerView)
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
        profileImageView.setImage(imageUrlString: cardVM.firstImageUrl) { self.stopLoadingCards() }
        nameLabel.text = cardVM.userInfo.name
        breedLabel.text = cardVM.userInfo.breed
        ageLabel.text = cardVM.userAge
        bioLabel.text = cardVM.userInfo.bio
    }
    
    // MARK: - Selectors
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        if gesture.state == .changed {
            self.transform = CGAffineTransform(rotationAngle: (translation.x / 20) * .pi / 180).translatedBy(x: translation.x, y: translation.y)
        } else if gesture.state == .ended {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: [.curveEaseOut]) {
                if translation.x > 200 {
                    self.transform = CGAffineTransform(translationX: 800, y: 0)
                } else if translation.x < -200 {
                    self.transform = CGAffineTransform(translationX: -800, y: 0)
                } else {
                    self.transform = .identity
                }
            } completion: { (_) in
                if translation.x > 200 || translation.x < -200 {
                    self.removeFromSuperview()
                }
            }
        }
    }
    
    @objc private func handleAboutTapped() {
        delegate?.showAboutVC(cardViewModel: cardVM)
    }
}
