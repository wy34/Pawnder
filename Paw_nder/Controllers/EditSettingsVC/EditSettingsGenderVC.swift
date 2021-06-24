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
    
    private let maleButton = PawButton(title: "🙋‍♂️", font: .systemFont(ofSize: 75, weight: .bold))
    private let femaleButton = PawButton(title: "🙋‍♀️", font: .systemFont(ofSize: 75, weight: .bold))
    private lazy var buttonStack = PawStackView(views: [maleButton, femaleButton], spacing: 10, distribution: .fillEqually, alignment: .fill)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActionsAndObservers()
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
        let maleScale: CGFloat = gender == .male ? 1 : 0.8
        let femaleScale: CGFloat = gender == .female ? 1 : 0.8
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.genderLabel.text = gender == .male ? Gender.male.rawValue : Gender.female.rawValue
            self?.genderLabel.textColor = gender == .male ? Colors.lightBlue : Colors.lightRed
            self?.maleButton.layer.borderColor = gender == .male ? Colors.lightBlue.cgColor : UIColor.lightGray.cgColor
            self?.femaleButton.layer.borderColor = gender == .male ? UIColor.lightGray.cgColor : Colors.lightRed.cgColor
            self?.maleButton.transform = CGAffineTransform(scaleX: maleScale, y: maleScale)
            self?.femaleButton.transform = CGAffineTransform(scaleX: femaleScale, y: femaleScale)
        }
    }
    
    override func handleSave() {
        settingsVM.user?.gender = selectedGender ?? .male
        super.handleSave()
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
