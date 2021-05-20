//
//  EditSettingsRootVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/17/21.
//

import UIKit

class EditSettingsRootVC: UIViewController {
    // MARK: - Properties
    var newSettingsVC: NewSettingsVC?
    var settings: Setting?

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
        self.settings = setting
        navigationItem.title = setting.emoji + " " + setting.title.rawValue.capitalized
    }
    
    // MARK: - Selector
}
