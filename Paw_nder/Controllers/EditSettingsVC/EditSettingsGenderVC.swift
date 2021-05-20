//
//  EditSettingsGenderVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/17/21.
//

import UIKit

class EditSettingsGenderVC: EditSettingsRootVC {
    // MARK: - Properties
    var selectedGender: Gender?
    
    // MARK: - Views
    private let headingLabel = PaddedLabel(text: "You are a: ", font: .systemFont(ofSize: 35, weight: .bold), padding: 5)
    private let genderLabel = PaddedLabel(text: "?", font: .systemFont(ofSize: 35, weight: .bold), padding: 5)
    private lazy var labelStack = PawStackView(views: [headingLabel, genderLabel], spacing: -5, distribution: .fill, alignment: .center)
    
    private let maleButton = PawButton(title: "🙎‍♂️", font: .systemFont(ofSize: 75, weight: .bold))
    private let femaleButton = PawButton(title: "🙎‍♀️", font: .systemFont(ofSize: 75, weight: .bold))
    private lazy var buttonStack = PawStackView(views: [maleButton, femaleButton], spacing: 10, distribution: .fillEqually, alignment: .fill)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActionsAndObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let currentGender = settings?.preview
        settings?.preview = selectedGender == nil ? currentGender : selectedGender?.rawValue
        newSettingsVC?.updateNewSettingsPreview(settings: settings!)
    }
    
    // MARK: - Helpers
    override func configureUI() {
        super.configureUI()
        
        [maleButton, femaleButton].forEach({
            $0.layer.borderWidth = 3
            $0.layer.cornerRadius = 10
            $0.backgroundColor = .white
        })
    }
    
    override func layoutUI() {
        super.layoutUI()
        view.addSubviews( buttonStack, labelStack)
        buttonStack.center(to: view, by: .centerX)
        buttonStack.center(to: view, by: .centerY, withMultiplierOf: 0.65)
        buttonStack.setDimension(width: view.widthAnchor, height: view.widthAnchor, wMult: 0.5, hMult: 0.3)
        
        labelStack.anchor(bottom: buttonStack.topAnchor, paddingBottom: 35)
        labelStack.center(to: view, by: .centerX)
    }
    
    override func configureWith(setting: Setting) {
        super.configureWith(setting: setting)
        let gender = Gender(rawValue: setting.preview ?? "") ?? .male
        configureButtonFor(gender: gender)
    }
    
    private func setupActionsAndObservers() {
        maleButton.addTarget(self, action: #selector(handleGenderButtonPressed(button:)), for: .touchUpInside)
        femaleButton.addTarget(self, action: #selector(handleGenderButtonPressed(button:)), for: .touchUpInside)
    }
    
    func configureButtonFor(gender: Gender) {
        genderLabel.text = gender == .male ? Gender.male.rawValue : Gender.female.rawValue
        genderLabel.textColor = gender == .male ? lightBlue : lightRed
        maleButton.layer.borderColor = gender == .male ? lightBlue.cgColor : UIColor.lightGray.cgColor
        femaleButton.layer.borderColor = gender == .male ? UIColor.lightGray.cgColor : lightRed.cgColor
    }
    
    // MARK: - Selectors
    @objc func handleGenderButtonPressed(button: UIButton) {
        if button == maleButton {
            configureButtonFor(gender: .male)
            selectedGender = .male
        } else {
            configureButtonFor(gender: .female)
            selectedGender = .female
        }
    }
}
