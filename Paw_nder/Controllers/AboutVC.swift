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
            label.text = aboutVM.userInfo.name
        }
    }

    // MARK: - Views
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        return sv
    }()
    
    private let contentView = PawView(bgColor: .blue)
    private let dismissButton = PawButton(image: downArrow, tintColor: .darkGray, font: .boldSystemFont(ofSize: 18))
    private let label = PawLabel(text: "", textColor: .white, font: .systemFont(ofSize: 16, weight: .semibold), alignment: .left)
    private let headerContainerView = PawView(bgColor: .gray)
    private let imagePagingVC = PagingController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutScrollView()
        layoutUI()
        configureUI()
    }
    
    // MARK: - Helpers
    func layoutScrollView() {
        view.addSubviews(scrollView)
        scrollView.fill(superView: view)
        scrollView.addSubview(contentView)
        contentView.fill(superView: scrollView)
        contentView.setDimension(width: scrollView.widthAnchor, height: scrollView.heightAnchor, hMult: 1.25)
    }
    
    func layoutUI() {
        contentView.addSubviews(label, headerContainerView, imagePagingVC.view, dismissButton)
        
        label.anchor(top: contentView.topAnchor, trailing: view.trailingAnchor, bottom: contentView.bottomAnchor, leading: view.leadingAnchor, paddingTop: UIScreen.main.bounds.height * 0.45, paddingTrailing: 10, paddingBottom: 10, paddingLeading: 10)
        
        headerContainerView.anchor(top: view.topAnchor, trailing: view.trailingAnchor, bottom: label.topAnchor, leading: view.leadingAnchor)
        imagePagingVC.view.fill(superView: headerContainerView)
        
        dismissButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, paddingLeading: 20)
        dismissButton.setDimension(wConst: 35, hConst: 35)
    }
    
    func configureUI() {
        label.numberOfLines = 0
        label.backgroundColor = .clear
        dismissButton.backgroundColor = .white
        dismissButton.layer.cornerRadius = 35/2
        dismissButton.addTarget(self, action: #selector(handleDismissTapped), for: .touchUpInside)
    }
    
    // MARK: - Selector
    @objc func handleDismissTapped() {
        dismiss(animated: true, completion: nil)
    }
}
