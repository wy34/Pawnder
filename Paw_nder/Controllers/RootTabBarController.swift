//
//  RootTabBarController.swift
//  Paw_nder
//
//  Created by William Yeung on 5/2/21.
//

import UIKit

class RootTabBarController: UITabBarController {
    // MARK: - Views
    var homeVC: HomeVC?
    var likesVC: LikesVC?
    var messagesVC: UINavigationController?
    var settingsVC: UINavigationController?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.bgLightGray
        setupTabbar()
        setupNotificationObservers()
    }
    
    // MARK: - Helpers
    private func setupTabbar() {
        let layer = CAShapeLayer()
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 20
        
        let roundedRect = CGRect(x: 0, y: 0, width: self.tabBar.bounds.width, height: self.tabBar.bounds.height * 2)
        layer.path = UIBezierPath(roundedRect: roundedRect, cornerRadius: 30).cgPath
        layer.fillColor = UIColor.white.cgColor
        tabBar.layer.insertSublayer(layer, at: 0)
        
        tabBar.itemWidth = tabBar.bounds.width / 5
        tabBar.itemPositioning = .centered
        tabBar.tintColor = Colors.lightRed
        tabBar.backgroundColor = Colors.bgLightGray
        
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        
        setupViewControllers()
    }
    
    func setupViewControllers() {
        self.selectedIndex = 0
                
        homeVC = HomeVC()
        setupVCsAndTabItems(for: homeVC!, image: Assets.tabPaw, tag: 0)
        
        likesVC = LikesVC()
        likesVC?.homeVC = homeVC
        setupVCsAndTabItems(for: likesVC!, image: Assets.tabThumb, tag: 0)

        messagesVC = UINavigationController(rootViewController: MessagesVC())
        setupVCsAndTabItems(for: messagesVC!, image: Assets.tabMessage, tag: 2)
        
        settingsVC = UINavigationController(rootViewController: ProfileVC())
        setupVCsAndTabItems(for: settingsVC!, image: Assets.tabUser, tag: 3)
        
        setViewControllers([homeVC!, likesVC!, messagesVC!, settingsVC!], animated: true)
    }
    
    private func setupVCsAndTabItems(for vc: UIViewController, image: UIImage, tag: Int) {
        vc.tabBarItem = UITabBarItem(title: nil, image: image, tag: tag)
        vc.tabBarItem.imageInsets = .init(top: 15, left: 2, bottom: -15, right: 2)
    }
    
    func showTabbar() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.tabBar.frame.origin.y = self.view.frame.height - self.tabBar.bounds.height
            self.tabBar.layoutIfNeeded()
        }
    }
    
    func hideTabbar() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.tabBar.frame.origin.y = self.view.frame.height
            self.tabBar.layoutIfNeeded()
        }
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(disableButtons), name: .didDragCard, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enableButtons), name: .didFinishDraggingCard, object: nil)
    }
    
    // MARK: - Selector
    @objc func disableButtons() {
        for vc in [homeVC, likesVC, messagesVC, settingsVC] {
            vc?.tabBarItem.isEnabled = false
        }
    }
    
    @objc func enableButtons() {
        for vc in [homeVC, likesVC, messagesVC, settingsVC] {
            vc?.tabBarItem.isEnabled = true
        }
    }
}
