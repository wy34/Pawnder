//
//  EditSettingsBreedV.swift
//  Paw_nder
//
//  Created by William Yeung on 5/31/21.
//

import UIKit

class EditSettingsBreedVC: EditSettingsRootVC {
    // MARK: - Properties
    
    // MARK: - Views
    private let breedButton = PawButton(title: "N/A", bgColor: .white)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActionsAndObservers()
    }
    
    // MARK: - Helpers
    override func configureUI() {
        super.configureUI()
        breedButton.layer.cornerRadius = 50/2
        breedButton.layer.borderWidth = 1
        breedButton.layer.borderColor = UIColor.lightGray.cgColor
        breedButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
    }
    
    override func layoutUI() {
        super.layoutUI()
        view.addSubview(breedButton)
        breedButton.anchor(top: view.topAnchor, paddingTop: 25)
        breedButton.center(to: view, by: .centerX)
        breedButton.setDimension(width: view.widthAnchor, wMult: 0.9)
        breedButton.setDimension(hConst: 50)
    }
    
    override func configureWith(setting: Setting) {
        super.configureWith(setting: setting)
        breedButton.setTitle(settingsVM.userCopy?.breed, for: .normal)
    }
    
    private func setupActionsAndObservers() {
        breedButton.addTarget(self, action: #selector(handleBreedButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    @objc func handleBreedButtonTapped() {
        let breedSearchVC = BreedSearchVC()
        breedSearchVC.isChoosingBreedPref = false
        breedSearchVC.didSelectBreedHandler = { [weak self] in
            self?.breedButton.setTitle(self?.settingsVM.user?.breed, for: .normal)
        }
        navigationController?.pushViewController(breedSearchVC, animated: true)
    }
}
