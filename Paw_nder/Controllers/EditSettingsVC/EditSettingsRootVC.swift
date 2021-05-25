//
//  EditSettingsRootVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/17/21.
//

import UIKit

class EditSettingsRootVC: LoadingViewController {
    // MARK: - Properties
    let settingsVM = SettingsViewModel.shared
    var settingsVC: SettingsVC?
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave))
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
    @objc func handleSave() {
        showLoader()
        
        self.settingsVM.updateUserInfo { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            }

            self.dismissLoader()
            self.settingsVC?.tableView.reloadRows(at: [IndexPath(row: self.settings!.index, section: 0)], with: .automatic)
        }
    }
}
