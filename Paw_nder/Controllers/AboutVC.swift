//
//  Scroll.swift
//  Paw_nder
//
//  Created by William Yeung on 4/30/21.
//

import UIKit


class AboutVC: UIViewController {
    // MARK: - Properties
    var aboutVM: AboutViewModel? {
        didSet {
            guard let aboutVM = aboutVM else { return }
            imagePagingVC.setupImages(aboutVM: aboutVM)
            namelabel.text = aboutVM.userInfo.name
            breedAgeLabel.text = aboutVM.userBreedAge
            breedAgeLabel.textColor = aboutVM.userGender.textColor
            genderLabel.text = aboutVM.userGender.text
            genderLabel.textColor = aboutVM.userGender.textColor
            genderLabel.backgroundColor = aboutVM.userGender.bgColor
            bioLabel.text = aboutVM.userInfo.bio
        }
    }
    
    var homeVC: HomeVC?
    
    // MARK: - Views
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .white
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private let contentView = PawView(bgColor: .white)
    
    private let dismissButton = PawButton(image: SFSymbols.xmark, tintColor: .darkGray, font: .boldSystemFont(ofSize: 15))
    
    private let headerContainerView = PawView(bgColor: .gray)
    private let imagePagingVC = PagingController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
    
    private let bodyContainerView = PawView(bgColor: .clear)
    
    private let namelabel = PawLabel(text: "", textColor: .black, font: .systemFont(ofSize: 30, weight: .bold), alignment: .left)
    private let breedAgeLabel = PawLabel(text: "Golden Retriever", textColor: lightRed, font: .systemFont(ofSize: 14, weight: .semibold), alignment: .left)
    private lazy var headingStack = PawStackView(views: [namelabel, breedAgeLabel], spacing: 10, axis: .vertical, distribution: .fill, alignment: .fill)
        
    private let genderLabel = PaddedLabel(text: "", font: .systemFont(ofSize: 14, weight: .bold), padding: 8)
    private let locationLabel = IconLabel(text: "Los Angelos, CA", image: mappin, cornerRadius: 10)
    
    private let borderView = PawView(bgColor: lightGray)
    
    private let bioLabel = PawLabel(text: "Golden Retriever", textColor: .gray, font: .systemFont(ofSize: 20, weight: .semibold), alignment: .left)
    
    private let likeButton = PawButton(image: SFSymbols.heart, tintColor: .white, font: .systemFont(ofSize: 16, weight: .bold))
    private let dislikeButton = PawButton(image: SFSymbols.xmark, tintColor: .white, font: .systemFont(ofSize: 16, weight: .bold))
    private lazy var likeDislikeStack = PawStackView(views: [dislikeButton, likeButton], spacing: 12, distribution: .fillEqually, alignment: .fill)
        
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutScrollView()
        layoutUI()
        configureUI()
        setupButtonActions()
    }
    
    // MARK: - Helpers
    func configureUI() {
        dismissButton.backgroundColor = .white.withAlphaComponent(0.75)
        dismissButton.layer.cornerRadius = 35/2
        dismissButton.addTarget(self, action: #selector(handleDismissTapped), for: .touchUpInside)
        genderLabel.layer.cornerRadius = 10
        genderLabel.clipsToBounds = true
        bioLabel.numberOfLines = 0
        likeButton.layer.cornerRadius = 45/2
        dislikeButton.layer.cornerRadius = 45/2
        likeButton.backgroundColor = #colorLiteral(red: 0.4704266787, green: 0.8806294799, blue: 0.6199433804, alpha: 1)
        dislikeButton.backgroundColor = lightRed
    }
    
    func layoutScrollView() {
        view.addSubviews(scrollView)
        scrollView.fill(superView: view)
        scrollView.addSubview(contentView)
        contentView.fill(superView: scrollView)
        contentView.setDimension(width: scrollView.widthAnchor, height: scrollView.heightAnchor, hMult: 1.1)
    }
    
    func layoutUI() {
        contentView.addSubviews(bodyContainerView, headerContainerView, imagePagingVC.view, dismissButton)
        
        dismissButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor, paddingTop: 10, paddingTrailing: 25)
        dismissButton.setDimension(wConst: 35, hConst: 35)
        
        bodyContainerView.anchor(top: contentView.topAnchor, paddingTop: UIScreen.main.bounds.height * 0.5)
        bodyContainerView.center(to: contentView, by: .centerX)
        bodyContainerView.setDimension(width: contentView.widthAnchor, height: contentView.heightAnchor, wMult: 0.85)
        
        layoutBodyViews()
        
        headerContainerView.anchor(top: view.topAnchor, trailing: view.trailingAnchor, bottom: bodyContainerView.topAnchor, leading: view.leadingAnchor)
        imagePagingVC.view.fill(superView: headerContainerView)
    }
    
    func layoutBodyViews() {
        bodyContainerView.addSubviews(headingStack, genderLabel, locationLabel, borderView, bioLabel, likeDislikeStack)
        
        headingStack.anchor(top: bodyContainerView.topAnchor, trailing: bodyContainerView.trailingAnchor, leading: bodyContainerView.leadingAnchor, paddingTop: 30)
        
        genderLabel.anchor(top: headingStack.bottomAnchor, leading: headingStack.leadingAnchor, paddingTop: 10)
        locationLabel.anchor(top: genderLabel.bottomAnchor, leading: headingStack.leadingAnchor, paddingTop: 10)
        borderView.anchor(top: locationLabel.bottomAnchor, trailing: headingStack.trailingAnchor, leading: headingStack.leadingAnchor, paddingTop: 25)
        borderView.setDimension(hConst: 2)
        bioLabel.anchor(top: borderView.bottomAnchor, trailing: headingStack.trailingAnchor, leading: headingStack.leadingAnchor, paddingTop: 20)
        
        likeDislikeStack.anchor(top: bioLabel.bottomAnchor, paddingTop: 45)
        likeDislikeStack.center(to: view, by: .centerX)
        likeDislikeStack.setDimension(width: view.widthAnchor, wMult: 0.6)
        likeDislikeStack.setDimension(hConst: 45)
    }
    
    func setupButtonActions() {
        dislikeButton.addTarget(self, action: #selector(handleDislikeTapped), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
    }
    
    // MARK: - Selector
    @objc func handleDismissTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDislikeTapped() {
        dismiss(animated: true) { self.homeVC?.swipeWhenPressed(like: false) }
    }
    
    @objc func handleLikeTapped() {
        dismiss(animated: true) { self.homeVC?.swipeWhenPressed(like: true) }
    }
}

