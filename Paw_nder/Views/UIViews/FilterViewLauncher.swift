//
//  FilterVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/3/21.
//

import UIKit
import SwiftUI


class FilterViewLauncher: UIView {
    // MARK: - Properties

    // MARK: - Views
    private let blackBgView = PawView(bgColor: .black.withAlphaComponent(0.5))
    
    private let filterCardView = PawView(bgColor: .white, cornerRadius: 30)
    private let dismissButton = PawButton(image: SFSymbols.xmark, tintColor: .black, font: .systemFont(ofSize: 16, weight: .bold))
    private let filterTitle = PawLabel(text: "Filters", font: .systemFont(ofSize: 22, weight: .bold), alignment: .center)
    private let saveButton = PawButton(image: SFSymbols.checkmark, tintColor: .black, font: .systemFont(ofSize: 16, weight: .bold))
    private lazy var headingStack = PawStackView(views: [dismissButton, filterTitle, saveButton], distribution: .fillEqually, alignment: .fill)
    
    private let locationLabel = PawLabel(text: "Location", textColor: .black, font: .systemFont(ofSize: 18, weight: .bold), alignment: .left)
    private let locationTextField = PawTextField(placeholder: "Location", bgColor: .red, cornerRadius: 10)
    private lazy var locationStack = PawStackView(views: [locationLabel, locationTextField], spacing: -5, axis: .vertical, distribution: .fillEqually, alignment: .fill)
    
    private let genderLabel = PawLabel(text: "Gender", textColor: .black, font: .systemFont(ofSize: 18, weight: .bold), alignment: .left)
    private let genderTextField = PawTextField(placeholder: "Gender", bgColor: .red, cornerRadius: 10)
    private lazy var genderStack = PawStackView(views: [genderLabel, genderTextField], spacing: -5, axis: .vertical, distribution: .fillEqually, alignment: .fill)
    
    private let ageLabel = PawLabel(text: "Age", textColor: .black, font: .systemFont(ofSize: 18, weight: .bold), alignment: .left)
    private let ageTextField = PawTextField(placeholder: "Age", bgColor: .red, cornerRadius: 10)
    private lazy var ageStack = PawStackView(views: [ageLabel, ageTextField], spacing: -5, axis: .vertical, distribution: .fillEqually, alignment: .fill)

    private lazy var bodyStack = PawStackView(views: [locationStack, genderStack, ageStack], axis: .vertical, distribution: .fillEqually, alignment: .fill)
    private lazy var formStack = PawStackView(views: [headingStack, bodyStack], axis: .vertical, distribution: .fill, alignment: .fill)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupActionsAndGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helpers
    func configureUI() {
        dismissButton.contentHorizontalAlignment = .left
        saveButton.contentHorizontalAlignment = .right
        blackBgView.alpha = 0
    }
    
    func layoutFilterCard() {
        filterCardView.addSubviews(formStack)
        formStack.fill(superView: filterCardView, withPaddingOnAllSides: 30)
        headingStack.setDimension(height: formStack.heightAnchor, hMult: 0.2)
    }
    
    func showFilterView() {
        if let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            keyWindow.addSubview(self.blackBgView)
            self.blackBgView.frame = keyWindow.frame
            
            keyWindow.addSubview(filterCardView)
            let height = keyWindow.frame.height * 0.45
            filterCardView.frame = .init(x: 0, y: -height, width: keyWindow.frame.width, height: height)
            
            layoutFilterCard()
            
            UIView.animate(withDuration: 0.4) { [weak self] in
                guard let self = self else { return }
                self.blackBgView.alpha = 1
                self.filterCardView.frame.origin.y = 0
            }
        }
    }
    
    func setupActionsAndGestures() {
        blackBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissFilterView)))
        dismissButton.addTarget(self, action: #selector(dismissFilterView), for: .touchUpInside)
    }
    
    // MARK: - Selector
    @objc func dismissFilterView() {
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let self = self else { return }
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            self.blackBgView.alpha = 0
            if let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
                self.filterCardView.frame.origin.y = -keyWindow.frame.height / 2
            }
        }
    }
}
