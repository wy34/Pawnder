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
    
    private let distanceLabel = PawLabel(text: "Distance:", textColor: .gray, font: .systemFont(ofSize: 18, weight: .bold), alignment: .left)
    private let milesLabel = PawLabel(text: "0 Miles", textColor: .darkGray, font: .systemFont(ofSize: 14), alignment: .left)
    private let milesSlider = PawSlider(starting: 0, min: 0, max: 1)
    private lazy var milesStack = PawStackView(views: [milesLabel, milesSlider], distribution: .fill, alignment: .fill)
    private lazy var distanceStack = PawStackView(views: [distanceLabel, milesStack], spacing: 10, axis: .vertical, distribution: .fillEqually, alignment: .fill)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        ageStack.anchor(top: genderStack.bottomAnchor, trailing: genderStack.trailingAnchor, leading: genderStack.leadingAnchor, paddingTop: 25)
        minLabel.setDimension(width: view.widthAnchor, wMult: 0.15)
        maxLabel.setDimension(width: view.widthAnchor, wMult: 0.15)
        
        distanceStack.anchor(top: ageStack.bottomAnchor, trailing: genderStack.trailingAnchor, leading: genderStack.leadingAnchor, paddingTop: 25)
        milesLabel.setDimension(width: view.widthAnchor, wMult: 0.15)
    }
}
