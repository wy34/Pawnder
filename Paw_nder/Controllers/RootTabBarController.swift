//
//  RootTabBarController.swift
//  Paw_nder
//
//  Created by William Yeung on 5/2/21.
//

import UIKit

class RootTabBarController: UITabBarController {
    // MARK: - Properties
    
    // MARK: - Views
    var homeVC: HomeVC?
    var messagesVC: UINavigationController?
    var newSettingsVC: UINavigationController?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        tabBar.tintColor = lightRed
        tabBar.backgroundColor = bgLightGray
        
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        
        setupViewControllers()
    }
    
    func setupViewControllers() {
        self.selectedIndex = 0
                
        homeVC = HomeVC()
        homeVC?.tabBarItem = UITabBarItem(title: nil, image: paw, tag: 0)
        homeVC?.tabBarItem.imageInsets = .init(top: 14, left: 0, bottom: -14, right: 0)
        
        messagesVC = UINavigationController(rootViewController: MessagesVC())
        messagesVC?.tabBarItem = UITabBarItem(title: nil, image: message, tag: 1)
        messagesVC?.tabBarItem.imageInsets = .init(top: 14, left: 0, bottom: -14, right: 0)
        
        newSettingsVC = UINavigationController(rootViewController: ProfileVC())
        newSettingsVC?.tabBarItem = UITabBarItem(title: nil, image: user, tag: 2)
        newSettingsVC?.tabBarItem.imageInsets = .init(top: 14, left: 0, bottom: -14, right: 0)
        
        setViewControllers([homeVC!, messagesVC!, newSettingsVC!], animated: true)
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
    
    func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(disableButtons), name: .didDragCard, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enableButtons), name: .didFinishDraggingCard, object: nil)
    }
    
    // MARK: - Selector
    @objc func disableButtons() {
        homeVC?.tabBarItem.isEnabled = false
        messagesVC?.tabBarItem.isEnabled = false
        newSettingsVC?.tabBarItem.isEnabled = false
    }
    
    @objc func enableButtons() {
        homeVC?.tabBarItem.isEnabled = true
        messagesVC?.tabBarItem.isEnabled = true
        newSettingsVC?.tabBarItem.isEnabled = true
    }
}
