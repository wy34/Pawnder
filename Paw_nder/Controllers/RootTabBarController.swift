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
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 15
        
        let roundedRect = CGRect(x: 0, y: 0, width: self.tabBar.bounds.width, height: self.tabBar.bounds.height * 2)
        layer.path = UIBezierPath(roundedRect: roundedRect, cornerRadius: 30).cgPath
        layer.fillColor = UIColor.white.cgColor
        tabBar.layer.insertSublayer(layer, at: 0)
        
        tabBar.itemWidth = tabBar.bounds.width / 5
        tabBar.itemPositioning = .centered
        tabBar.tintColor = lightRed
        tabBar.backgroundColor = .white
        
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        
        let homeVC = HomeVC()
        homeVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house")!.withBaselineOffset(fromBottom: tabBar.bounds.height/3), tag: 0)
        
        let redVC = UIViewController()
        redVC.view.backgroundColor = .white
        redVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "cloud")!.withBaselineOffset(fromBottom: tabBar.bounds.height/3), tag: 1)
        
        let settingsVC = UINavigationController(rootViewController: SettingsVC())
        settingsVC.view.backgroundColor = .white
        settingsVC.tabBarItem = UITabBarItem(title: "", image: person.withBaselineOffset(fromBottom: tabBar.bounds.height/3), tag: 2)
        
        viewControllers = [homeVC, redVC, settingsVC]
    }
}
