//
//  UIApplication.swift
//  Paw_nder
//
//  Created by William Yeung on 5/3/21.
//

import UIKit

extension UIApplication {
    static var rootTabBarController: RootTabBarController {
        return UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController as? RootTabBarController ?? RootTabBarController()
    }
}
