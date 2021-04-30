//
//  AboutVC.swift
//  Paw_nder
//
//  Created by William Yeung on 4/29/21.
//

import UIKit

class AboutVC: UIViewController {
    // MARK: - Properties
    
    // MARK: - Views
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .white
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()
    
    private let contentView = PawView(bgColor: .blue)
    
    private let dismissButton = PawButton(image: downArrow, tintColor: .darkGray, font: .boldSystemFont(ofSize: 16))
    private let userImageView = PawImageView(image: UIImage(named: bob4)!, contentMode: .scaleAspectFill)
    private let bioLabel = PawLabel(text: "klfjwie skfj sfij wei fiejw iorj isjf oewj f wiejowi fj ifj woejwoie  wie fiwje fowjef oiw oiw ejoiw ewi eji weijowie joiw iwje owij wiej oiw ej wijoe iwje owije oiwje  iwj wjeiojw eojowje klfjwie skfj sfij wei fiejw iorj isjf oewj f wiejowi fj ifj woejwoie  wie fiwje fowjef oiw oiw ejoiw ewi eji weijowie joiw iwje owij wiej oiw ej wijoe iwje owije oiwje  iwj wjeiojw eojowje klfjwie skfj sfij wei fiejw iorj isjf oewj f wiejowi fj ifj woejwoie  wie fiwje fowjef oiw oiw ejoiw ewi eji weijowie joiw iwje owij wiej oiw ej wijoe iwje owije oiwje  iwj wjeiojw eojowje", font: .systemFont(ofSize: 16, weight: .medium))
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        configureUI()
    }
    
    // MARK: - Helpers
    func configureUI() {
        bioLabel.numberOfLines = 0
        bioLabel.backgroundColor = .red
        dismissButton.backgroundColor = .white.withAlphaComponent(0.5)
        dismissButton.layer.cornerRadius = 35/2
        dismissButton.addTarget(self, action: #selector(handleDismissTapped), for: .touchUpInside)
    }
    
    func layoutScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.fill(superView: view)
        contentView.anchor(top: scrollView.topAnchor, trailing: scrollView.trailingAnchor, bottom: scrollView.bottomAnchor, leading: scrollView.leadingAnchor)
        contentView.setDimension(width: scrollView.widthAnchor, height: scrollView.heightAnchor, hMult: 1.25)
    }
    
    func layoutUI() {
        layoutScrollView()
        
        contentView.addSubviews(userImageView, dismissButton, bioLabel)
        userImageView.frame = .init(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        dismissButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, paddingLeading: 20)
        dismissButton.setDimension(wConst: 35, hConst: 35)
        bioLabel.anchor(top: userImageView.bottomAnchor, trailing: view.trailingAnchor, leading: view.leadingAnchor)
        bioLabel.setDimension(hConst: 600)
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
        userImageView.frame = .init(x: min(0, -changeY), y: min(0, -changeY), width: width, height: width)
    }
}
