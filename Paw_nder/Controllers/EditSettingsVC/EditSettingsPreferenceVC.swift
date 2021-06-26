//
//  EditSettingsPreferenceVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/20/21.
//

import UIKit

class EditSettingsPreferenceVC: EditSettingsRootVC {
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
        view.backgroundColor = Colors.bgLightGray
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
}

// MARK: - PreferenceFormViewDelegate
extension EditSettingsPreferenceVC: PreferenceFormViewDelegate {
    func didTapBreedPreference() {
        let breedSearchVC = BreedSearchVC()
        breedSearchVC.isChoosingBreedPref = true
        breedSearchVC.didSelectBreedHandler = { [weak self] in
            self?.preferenceFormView.loadBreedPreference()
        }
        navigationController?.pushViewController(breedSearchVC, animated: true)
    }
}
