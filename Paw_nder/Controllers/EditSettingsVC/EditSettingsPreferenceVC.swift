//
//  EditSettingsPreferenceVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/20/21.
//

import UIKit

class EditSettingsPreferenceVC: EditSettingsRootVC {
    // MARK: - Properties
    
    // MARK: - Views
    private let preferenceFormView = PreferenceFormView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        preferenceFormView.loadGenderPreference(user: settingsVM.userCopy)
        preferenceFormView.loadBreedPreference()
        preferenceFormView.loadSliderValues()
    }
    
    // MARK: - Helpers
    override func configureUI() {
        view.backgroundColor = bgLightGray
        preferenceFormView.delegate = self
    }
    
    override func layoutUI() {
        super.layoutUI()
        view.addSubview(preferenceFormView)
        preferenceFormView.fill(superView: view)
    }
    
    override func handleSave() {
        super.handleSave()
    }
    
    // MARK: - Selector
}

// MARK: - PreferenceFormViewDelegate
extension EditSettingsPreferenceVC: PreferenceFormViewDelegate {
    func didTapBreedPreference() {
        let breedSearchVC = BreedSearchVC()
        breedSearchVC.preferenceFormView = preferenceFormView
        navigationController?.pushViewController(breedSearchVC, animated: true)
    }
}
