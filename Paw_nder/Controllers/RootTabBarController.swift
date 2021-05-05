//
//  RootTabBarController.swift
//  Paw_nder
//
//  Created by William Yeung on 5/2/21.
//

import UIKit

class RootTabBarController: UITabBarController {
    // MARK: - Properties
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbar()
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
                
        let homeVC = HomeVC()
        homeVC.tabBarItem = UITabBarItem(title: nil, image: paw, tag: 0)
        homeVC.tabBarItem.imageInsets = .init(top: 14, left: 0, bottom: -14, right: 0)
        
        let redVC = UIViewController()
        redVC.view.backgroundColor = .white
        redVC.tabBarItem = UITabBarItem(title: nil, image: message, tag: 1)
        redVC.tabBarItem.imageInsets = .init(top: 14, left: 0, bottom: -14, right: 0)
        
        let settingsVC = UINavigationController(rootViewController: SettingsVC())
        settingsVC.view.backgroundColor = .white
        settingsVC.tabBarItem = UITabBarItem(title: nil, image: user, tag: 2)
        settingsVC.tabBarItem.imageInsets = .init(top: 14, left: 0, bottom: -14, right: 0)
        
        setViewControllers([homeVC, redVC, settingsVC], animated: true)
    }
}
