//
//  MessagesVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/8/21.
//

import UIKit
import Firebase


class MessagesVC: UIViewController {
    // MARK: - Properties
    
    // MARK: - Views
    private let iconImageView = PawImageView(image: icon, contentMode: .scaleAspectFit)
    private let newMatchesView = NewMatchesView()
    private let userMessagesVC = RecentMessagesVC()
    private let searchBar = UISearchBar()
    
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
        view.backgroundColor = bgLightGray

        newMatchesView.delegate = self
        userMessagesVC.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        userMessagesVC.view.layer.cornerRadius = 30
        userMessagesVC.view.backgroundColor = bgLightGray
    }
    
    private func layoutUI() {
        view.addSubviews(iconImageView, newMatchesView.view, userMessagesVC.view)
        
        iconImageView.center(to: view, by: .centerX)
        iconImageView.center(to: view, by: .centerY, withMultiplierOf: 0.1875)
        iconImageView.setDimension(wConst: 45, hConst: 45)
        
        newMatchesView.view.anchor(top: iconImageView.bottomAnchor, trailing: view.trailingAnchor, leading: view.leadingAnchor, paddingTop: 35)
        newMatchesView.view.setDimension(height: view.widthAnchor, hMult: 0.25)
        addChild(newMatchesView)
        
        userMessagesVC.view.anchor(top: newMatchesView.view.bottomAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, paddingTop: 5)
    }
}

// MARK: - NewMatchesViewDelegate
extension MessagesVC: NewMatchesViewDelegate {
    func didPressMatchedUser(match: Match) {
        let messageLogVC = MessageLogVC()
        messageLogVC.match = match
        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(messageLogVC, animated: true)
    }
}
