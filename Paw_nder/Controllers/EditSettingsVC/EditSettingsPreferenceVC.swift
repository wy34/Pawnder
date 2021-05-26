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
    private let iWannaMeetLabel = PawLabel(text: "I wanna meet:", textColor: .gray, font: .systemFont(ofSize: 18, weight: .bold), alignment: .left)
    private let maleButton = PawButton(title: "🙎‍♂️", font: .systemFont(ofSize: 30, weight: .bold))
    private let femaleButton = PawButton(title: "🙎‍♀️", font: .systemFont(ofSize: 30, weight: .bold))
    private let allButton = PawButton(title: "🙎‍♂️🙎‍♀️", font: .systemFont(ofSize: 30, weight: .bold))
    private lazy var buttonStack = PawStackView(views: [maleButton, femaleButton, allButton], spacing: 10, distribution: .fillEqually, alignment: .fill)
    private lazy var genderStack = PawStackView(views: [iWannaMeetLabel, buttonStack], spacing: 10, axis: .vertical, distribution: .fill, alignment: .fill)
    
    private let ageRangeLabel = PawLabel(text: "Age range:", textColor: .gray, font: .systemFont(ofSize: 18, weight: .bold), alignment: .left)
    private let minLabel = PawLabel(text: "Min: 0", textColor: .darkGray, font: .systemFont(ofSize: 14), alignment: .left)
    private let minSlider = PawSlider(starting: 0, min: 0, max: 1)
    private lazy var minStack = PawStackView(views: [minLabel, minSlider], distribution: .fill, alignment: .fill)

    private let maxLabel = PawLabel(text: "Max: 0", textColor: .darkGray, font: .systemFont(ofSize: 14), alignment: .left)
    private let maxSlider = PawSlider(starting: 0, min: 0, max: 1)
    private lazy var maxStack = PawStackView(views: [maxLabel, maxSlider], distribution: .fill, alignment: .fill)

    private lazy var ageStack = PawStackView(views: [ageRangeLabel, minStack, maxStack], spacing: 10, axis: .vertical, distribution: .fillEqually, alignment: .fill)
    
    private let distanceLabel = PawLabel(text: "Within:", textColor: .gray, font: .systemFont(ofSize: 18, weight: .bold), alignment: .left)
    private let milesLabel = PawLabel(text: "0 mi", textColor: .darkGray, font: .systemFont(ofSize: 14), alignment: .left)
    private let milesSlider = PawSlider(starting: 0, min: 0, max: 1)
    private lazy var milesStack = PawStackView(views: [milesLabel, milesSlider], distribution: .fill, alignment: .fill)
    private lazy var distanceStack = PawStackView(views: [distanceLabel, milesStack], spacing: 10, axis: .vertical, distribution: .fillEqually, alignment: .fill)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActionsAndObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadGenderPreference()
        loadSliderValues()
    }
    
    // MARK: - Helpers
    override func configureUI() {
        view.backgroundColor = bgLightGray
        
        [maleButton, femaleButton, allButton].forEach({
            $0.backgroundColor = .white
            $0.layer.borderWidth = 3
            $0.layer.cornerRadius = 20
            $0.layer.borderColor = UIColor.lightGray.cgColor
        })
        
        minSlider.tintColor = lightRed
        maxSlider.tintColor = lightRed
        milesSlider.tintColor = lightRed
    }
    
    override func layoutUI() {
        super.layoutUI()
        view.addSubviews(genderStack, ageStack, distanceStack)
        genderStack.center(to: view, by: .centerY, withMultiplierOf: 0.25)
        genderStack.anchor(trailing: view.trailingAnchor, leading: view.leadingAnchor, paddingTrailing: 25, paddingLeading: 25)
        genderStack.setDimension(height: view.widthAnchor, hMult: 0.25)
        iWannaMeetLabel.setDimension(hConst: 20)
        
        ageStack.anchor(top: genderStack.bottomAnchor, trailing: genderStack.trailingAnchor, leading: genderStack.leadingAnchor, paddingTop: 30)
        minLabel.setDimension(width: view.widthAnchor, wMult: 0.17)
        maxLabel.setDimension(width: view.widthAnchor, wMult: 0.17)
        
        distanceStack.anchor(top: ageStack.bottomAnchor, trailing: genderStack.trailingAnchor, leading: genderStack.leadingAnchor, paddingTop: 30)
        milesLabel.setDimension(width: view.widthAnchor, wMult: 0.17)
    }
    
    private func setupActionsAndObservers() {
        maleButton.addTarget(self, action: #selector(handleGenderSelected(button:)), for: .touchUpInside)
        femaleButton.addTarget(self, action: #selector(handleGenderSelected(button:)), for: .touchUpInside)
        allButton.addTarget(self, action: #selector(handleGenderSelected(button:)), for: .touchUpInside)
        minSlider.addTarget(self, action: #selector(handleAgeSliderChanged(slider:)), for: .valueChanged)
        maxSlider.addTarget(self, action: #selector(handleAgeSliderChanged(slider:)), for: .valueChanged)
        milesSlider.addTarget(self, action: #selector(handleMilesSliderChanged), for: .valueChanged)
    }
    
    private func setBorderColor(button: UIButton, borderColor: UIColor, gender: Gender) {
        UIView.animate(withDuration: 0.25) { [weak self] in
            [self?.maleButton, self?.femaleButton, self?.allButton].forEach({
                if $0 != button {
                    $0?.layer.borderColor = UIColor.lightGray.cgColor
                    $0?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                } else {
                    $0?.layer.borderColor = borderColor.cgColor
                    $0?.transform = .identity
                }
            })
        }
        
        settingsVM.user?.genderPreference = gender
    }
    
    func loadSliderValues() {
        minSlider.value = settingsVM.ageSliderMinFloatValue
        minLabel.text = settingsVM.ageSliderMinLabel
        maxSlider.value = settingsVM.ageSliderMaxFloatValue
        maxLabel.text = settingsVM.ageSliderMaxLabel
        milesSlider.value = settingsVM.distanceSliderValue
        milesLabel.text = settingsVM.preferredDistanceLabel
    }
    
    func loadGenderPreference() {
        switch settingsVM.user?.genderPreference {
            case .male: setBorderColor(button: maleButton, borderColor: lightBlue, gender: .male)
            case .female: setBorderColor(button: femaleButton, borderColor: lightRed, gender: .female)
            case .all: setBorderColor(button: allButton, borderColor: .purple, gender: .all)
            default: break
        }
    }
    
    override func handleSave() {
        super.handleSave()
    }
    
    // MARK: - Selector
    @objc func handleGenderSelected(button: UIButton) {
        if button == maleButton {
            setBorderColor(button: button, borderColor: lightBlue, gender: .male)
        } else if button == femaleButton {
            setBorderColor(button: button, borderColor: lightRed, gender: .female)
        } else {
            setBorderColor(button: button, borderColor: .purple, gender: .all)
        }
    }
    
    @objc func handleAgeSliderChanged(slider: UISlider) {
        let value = Int(slider.value * 100)
        
        if slider == minSlider {
            settingsVM.user?.minAgePreference = value
            minLabel.text = settingsVM.ageSliderMinLabel
            
            if slider.value >= maxSlider.value {
                maxSlider.value = slider.value
                settingsVM.user?.maxAgePreference = value
                maxLabel.text = settingsVM.ageSliderMaxLabel
            }
        } else {
            settingsVM.user?.maxAgePreference = value
            maxLabel.text = settingsVM.ageSliderMaxLabel
            
            if slider.value <= minSlider.value {
                minSlider.value = slider.value
                settingsVM.user?.minAgePreference = value
                minLabel.text = settingsVM.ageSliderMinLabel
            }
        }
    }
    
    @objc func handleMilesSliderChanged() {
        let value = Int(milesSlider.value * 150)
        milesLabel.text = "\(value) mi"
        settingsVM.user?.distancePreference = value
    }
}
