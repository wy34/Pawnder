//
//  EditSettingsLocationVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/23/21.
//

import UIKit

class EditSettingsLocationVC: EditSettingsRootVC {
    // MARK: - Properties
    let locationManager = LocationManager.shared
    
    // MARK: - Views
    private let titleLabel = PawLabel(text: "Your Location", textColor: .black, font: markerFont(36), alignment: .left)
    private let captionLabel = PawLabel(text: "Williamsport, PA", textColor: .gray, font: markerFont(18), alignment: .left)
    private lazy var labelStack = PawStackView(views: [titleLabel, captionLabel], spacing: 10, axis: .vertical, distribution: .fill, alignment: .fill)
    
    private let changeLocationButton = PawButton(title: "Update Location", textColor: .white, bgColor: Colors.lightRed)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActionsAndObservers()
    }
    
    // MARK: - Helpers
    override func configureNavBar() {
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func configureUI() {
        super.configureUI()
        changeLocationButton.layer.cornerRadius = view.frame.width * 0.1 / 2
        changeLocationButton.titleLabel?.font = markerFont(18)
    }
    
    override func layoutUI() {
        super.layoutUI()
        view.addSubviews(labelStack, changeLocationButton)
        labelStack.center(to: view, by: .centerY, withMultiplierOf: 0.5)
        labelStack.anchor(trailing: view.trailingAnchor, leading: view.leadingAnchor, paddingTrailing: 25, paddingLeading: 25)
        
        changeLocationButton.setDimension(width: view.widthAnchor, height: view.widthAnchor, wMult: 0.45, hMult: 0.1)
        changeLocationButton.center(to: view, by: .centerY, withMultiplierOf: 0.8)
        changeLocationButton.center(to: view, by: .centerX)
    }
    
    override func configureWith(setting: Setting) {
        super.configureWith(setting: setting)
        captionLabel.text = setting.preview
    }
    
    private func setupActionsAndObservers() {
        changeLocationButton.addTarget(self, action: #selector(handleChangeLocationTapped), for: .touchUpInside)
    }
    
    private func updateUserLocation() {
        locationManager.saveUserLocation { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
            
            self.settingsVC?.tableView.reloadRows(at: [.init(row: self.settings!.index, section: 0)], with: .automatic)
            self.captionLabel.text = self.settingsVM.locationName
        }
    }
    
    // MARK: - Selectors
    @objc func handleChangeLocationTapped() {
        let message =  "Are you sure you want to update to your latest location?"
        let confirmAC = UIAlertController(title: "Update Location", message: message, preferredStyle: .alert)
        confirmAC.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] action in
            guard let self = self else { return }
            self.updateUserLocation()
        }))
        confirmAC.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(confirmAC, animated: true, completion: nil)
    }
}
