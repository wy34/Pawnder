//
//  EditSettingsVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/17/21.
//

import UIKit

class EditSettingsVC: UIViewController {
    // MARK: - Properties
    
    // MARK: - Views
//    private let textfield = PawTextField(placeholder: <#T##String#>, bgColor: <#T##UIColor#>, cornerRadius: <#T##CGFloat#>)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
    }
        
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = bgLightGray
    }
    
    private func layoutUI() {
        
    }
        
    func configureWith(setting: Setting) {
        navigationItem.title = setting.emoji + " " + setting.name
    }
    
    // MARK: - Selector
}
