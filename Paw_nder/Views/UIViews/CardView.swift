//
//  CardView.swift
//  Paw_nder
//
//  Created by William Yeung on 4/20/21.
//

import UIKit

class CardView: LoadingView {
    // MARK: - Properties
    private var cardVM: CardViewModel?
    private var selectedBarColor = UIColor.white
    private var deselectedBarColor = #colorLiteral(red: 0.817677021, green: 0.8137882352, blue: 0.8206836581, alpha: 0.5)
    
    // MARK: - Views
    private let imagePageBar = PawStackView(views: [], spacing: 5, distribution: .fillEqually, alignment: .fill)
    private let cardImageView = PawImageView(image: UIImage(), contentMode: .scaleAspectFill)
    private let infoLabel = PawLabel(attributedText: .init())
    private let temporaryCoverView = PawView(bgColor: lightGray, cornerRadius: 15)
    
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
    
    override func layoutSubviews() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.65).cgColor]
        gradient.startPoint = .init(x: 0.5, y: 0.5)
        gradient.endPoint = .init(x: 0.5, y: 1)
        gradient.frame = self.frame
        cardImageView.layer.insertSublayer(gradient, at: 0)
    }
    
    // MARK: - Helpers
    private func configureUI() {
        cardImageView.layer.cornerRadius = 15
        cardImageView.backgroundColor = .white
    }
    
    private func layoutUI() {
        addSubviews(cardImageView, temporaryCoverView)
        cardImageView.fill(superView: self, withPaddingOnAllSides: 15)
        temporaryCoverView.fill(superView: self, withPaddingOnAllSides: 15)

        cardImageView.addSubviews(infoLabel, imagePageBar)
        infoLabel.anchor(trailing: cardImageView.trailingAnchor, bottom: cardImageView.bottomAnchor, leading: cardImageView.leadingAnchor, paddingTrailing: 20, paddingBottom: 20, paddingLeading: 20)
        
        imagePageBar.anchor(top: cardImageView.topAnchor, trailing: cardImageView.trailingAnchor, leading: cardImageView.leadingAnchor, paddingTop: 10, paddingTrailing: 10, paddingLeading: 10)
        imagePageBar.setDimension(hConst: 5)
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        addGestureRecognizer(tapGesture)
        addGestureRecognizer(panGesture)
    }
    
    private func setupImageTappedHandler() {
        self.cardVM?.imageTappedHandler = { [weak self] (tappedImage, imageIndex) in
            guard let self = self else { return }
            
            self.cardImageView.image = tappedImage
            
            for (index, subview) in self.imagePageBar.arrangedSubviews.enumerated() {
                subview.backgroundColor = index == imageIndex ? self.selectedBarColor : self.deselectedBarColor
            }
        }
    }
    
    func setupCardWith(cardVM: CardViewModel) {
        self.cardVM = cardVM
        setupImageTappedHandler()
        cardImageView.setImage(imageUrlString: cardVM.firstImageUrl) { self.stopLoadingCards() }
        infoLabel.attributedText = cardVM.infoText
        cardVM.images.forEach({ _ in imagePageBar.addArrangedSubview(PawView(bgColor: deselectedBarColor, cornerRadius: 3)) })
        imagePageBar.subviews[0].backgroundColor = selectedBarColor
    }
    
    // MARK: - Selectors
    @objc private func handleTap(gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: cardImageView)

        if tapLocation.x > cardImageView.frame.width / 2 && tapLocation.x <= cardImageView.frame.width {
            cardVM?.showNextImage()
        } else if tapLocation.x < cardImageView.frame.width / 2 && tapLocation.x >= 0 {
            cardVM?.showPrevImage()
        }
    }
    
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
}
