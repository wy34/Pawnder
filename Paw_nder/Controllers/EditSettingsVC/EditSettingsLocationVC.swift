//
//  EditSettingsLocationVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/23/21.
//

import UIKit

class EditSettingsLocationVC: EditSettingsRootVC {
    // MARK: - Properties
    
    // MARK: - Views
    private let ageLabel = PawLabel(text: "Your Location", textColor: .black, font: .systemFont(ofSize: 35, weight: .bold), alignment: .left)
    private let captionLabel = PawLabel(text: "Williamsport, PA", textColor: .gray, font: .systemFont(ofSize: 16, weight: .medium), alignment: .left)
    private lazy var labelStack = PawStackView(views: [ageLabel, captionLabel], spacing: 10, axis: .vertical, distribution: .fill, alignment: .fill)
    
    private let newLocationButton = PawButton(title: "Change Locations", textColor: .white, bgColor: .purple)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Helpers
    override func configureNavBar() {
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func configureUI() {
        super.configureUI()
        newLocationButton.layer.cornerRadius = view.frame.width * 0.15 / 2
        newLocationButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    override func layoutUI() {
        super.layoutUI()
        view.addSubviews(labelStack, newLocationButton)
        labelStack.center(to: view, by: .centerY, withMultiplierOf: 0.5)
        labelStack.anchor(trailing: view.trailingAnchor, leading: view.leadingAnchor, paddingTrailing: 25, paddingLeading: 25)
        
        newLocationButton.setDimension(width: view.widthAnchor, height: view.widthAnchor, wMult: 0.5, hMult: 0.15)
        newLocationButton.center(to: view, by: .centerY, withMultiplierOf: 0.85)
        newLocationButton.center(to: view, by: .centerX)
    }
    
    // MARK: - Selectors
}
