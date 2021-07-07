//
//  MessagesVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/8/21.
//

import UIKit
import Firebase


class MessagesVC: UIViewController {
    // MARK: - Views
    private let iconImageView = PawImageView(image: Assets.icon, contentMode: .scaleAspectFit)
    private let newMatchesView = NewMatchesVC()
    private let recentMessagesVC = RecentMessagesVC()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = Colors.bgLightGray
        newMatchesView.delegate = self
        recentMessagesVC.delegate = self
        recentMessagesVC.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        recentMessagesVC.view.layer.cornerRadius = 30
        recentMessagesVC.view.backgroundColor = Colors.bgLightGray
    }
    
    private func layoutUI() {
        view.addSubviews(iconImageView, newMatchesView.view, recentMessagesVC.view)
        
        iconImageView.center(to: view, by: .centerX)
        iconImageView.center(to: view, by: .centerY, withMultiplierOf: 0.1875)
        iconImageView.setDimension(wConst: 45, hConst: 45)
        
        newMatchesView.view.anchor(top: iconImageView.bottomAnchor, trailing: view.trailingAnchor, leading: view.leadingAnchor, paddingTop: 30)
        newMatchesView.view.setDimension(height: view.widthAnchor, hMult: 0.35)
        addChild(newMatchesView)
        
        recentMessagesVC.view.anchor(top: newMatchesView.view.bottomAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, paddingTop: 5)
    }
    
    private func navigateToMessageLogVC(match: Match) {
        let messageLogVC = MessageLogVC()
        messageLogVC.match = match
        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(messageLogVC, animated: true)
    }
}

// MARK: - NewMatchesViewDelegate
extension MessagesVC: NewMatchesVCDelegate {
    func didPressMatchedUser(match: Match) {
        navigateToMessageLogVC(match: match)
    }
}

// MARK: - RecentMessagesVCDelegate
extension MessagesVC: RecentMessagesVCDelegate {
    func handleRowTapped(match: Match) {
        navigateToMessageLogVC(match: match)
    }
}
