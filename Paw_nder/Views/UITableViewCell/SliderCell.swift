//
//  SliderCell.swift
//  Paw_nder
//
//  Created by William Yeung on 4/27/21.
//

import UIKit
import SwiftUI

class SliderCell: UITableViewCell {
    // MARK: - Properties
    static let reuseId = "SliderCell"
    let settingsVM = SettingsViewModel.shared
    
    // MARK: - Views
    private let minLabel = PawLabel(text: "Min: 0", font: .systemFont(ofSize: 16, weight: .medium), alignment: .left)
    private let minSlider = PawSlider(starting: 0, min: 0, max: 1)
    private lazy var minStack = PawStackView(views: [minLabel, minSlider], distribution: .fill, alignment: .fill)

    private let maxLabel = PawLabel(text: "Max: 0", font: .systemFont(ofSize: 16, weight: .medium), alignment: .left)
    private let maxSlider = PawSlider(starting: 0, min: 0, max: 1)
    private lazy var maxStack = PawStackView(views: [maxLabel, maxSlider], distribution: .fill, alignment: .fill)

    private lazy var sliderStack = PawStackView(views: [minStack, maxStack], spacing: 10, axis: .vertical, distribution: .fillEqually, alignment: .fill)
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setupSliderAction()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        minSlider.tintColor = lightRed
        maxSlider.tintColor = lightRed
    }
    
    private func setupSliderAction() {
        minSlider.addTarget(self, action: #selector(handleSliderChanged(slider:)), for: .valueChanged)
        maxSlider.addTarget(self, action: #selector(handleSliderChanged(slider:)), for: .valueChanged)
    }
    
    private func layoutUI() {
        contentView.addSubview(sliderStack)
        sliderStack.fill(superView: self,  withPaddingOnAllSides: 15)
        minLabel.setDimension(width: widthAnchor, wMult: 0.25)
        maxLabel.setDimension(width: widthAnchor, wMult: 0.25)
    }
    
    func setSliderValues() {
        minSlider.value = settingsVM.ageSliderMinFloatValue
        minLabel.text = settingsVM.ageSliderMinLabel
        maxSlider.value = settingsVM.ageSliderMaxFloatValue
        maxLabel.text = settingsVM.ageSliderMaxLabel
    }
    
    // MARK: - Selector
    @objc func handleSliderChanged(slider: UISlider) {
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
                maxSlider.value = settingsVM.ageSliderMinFloatValue
                settingsVM.user?.maxAgePreference = Int(minSlider.value * 100)
                maxLabel.text = settingsVM.ageSliderMaxLabel
            }
        }
    }
}


