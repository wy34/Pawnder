//
//  EditSettingsRootVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/17/21.
//

import UIKit

class EditSettingsRootVC: UIViewController {
    // MARK: - Properties
    
    // MARK: - Views
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureUI()
        layoutUI()
    }
        
    // MARK: - Helpers
    func configureNavBar() {
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func configureUI() {
        view.backgroundColor = bgLightGray
    }
    
    func layoutUI() {
        edgesForExtendedLayout = []
    }
        
    func configureWith(setting: Setting) {
        navigationItem.title = setting.emoji + " " + setting.name
    }
    
    // MARK: - Selector
}
