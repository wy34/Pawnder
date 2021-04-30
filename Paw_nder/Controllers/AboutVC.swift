//
//  AboutVC.swift
//  Paw_nder
//
//  Created by William Yeung on 4/29/21.
//

import UIKit

class AboutVC: UIViewController {
    // MARK: - Properties
    var aboutVM: AboutViewModel? {
        didSet {
            guard let aboutVM = aboutVM else { return }
            imagePagingVC.setupImages(aboutVM: aboutVM)
            nameLabel.text = aboutVM.userInfo.name
        }
    }
    
    // MARK: - Views
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .white
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()
    
    private let contentView = PawView(bgColor: .blue)
    
    private let dismissButton = PawButton(image: downArrow, tintColor: .darkGray, font: .boldSystemFont(ofSize: 18))
    private let imagePagingVC = PagingController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
    private let nameLabel = PawLabel(text: "", font: .systemFont(ofSize: 16, weight: .medium))
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        configureUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        imagePagingVC.view.frame = .init(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
    }
    
    // MARK: - Helpers
    func configureUI() {
        dismissButton.backgroundColor = .white.withAlphaComponent(0.75)
        dismissButton.layer.cornerRadius = 35/2
        dismissButton.addTarget(self, action: #selector(handleDismissTapped), for: .touchUpInside)
        nameLabel.backgroundColor = .red
    }
    
    func layoutScrollView() {
        view.addSubview(scrollView)
        scrollView.fill(superView: view)
        scrollView.addSubview(contentView)
        contentView.fill(superView: scrollView)
        contentView.setDimension(width: scrollView.widthAnchor, height: scrollView.heightAnchor, hMult: 1.25)
    }
    
    func layoutUI() {
        layoutScrollView()
        contentView.addSubviews(imagePagingVC.view, dismissButton, nameLabel)
        dismissButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, paddingLeading: 20)
        dismissButton.setDimension(wConst: 35, hConst: 35)
        nameLabel.anchor(top: imagePagingVC.view.bottomAnchor, trailing: view.trailingAnchor, leading: view.leadingAnchor)
        nameLabel.setDimension(hConst: 100)
    }
    
    // MARK: - Selector
    @objc func handleDismissTapped() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIScrollViewDelegate
extension AboutVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = -scrollView.contentOffset.y 
        var width = view.frame.width + changeY * 2
        width = max(view.frame.width, width)
        imagePagingVC.view.frame = .init(x: min(0, -changeY), y: min(0, -changeY), width: width, height: width)
    }
}
