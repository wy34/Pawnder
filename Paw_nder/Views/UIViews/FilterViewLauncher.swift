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
    private let filterTitle = PawLabel(text: "Filters", font: .systemFont(ofSize: 24, weight: .bold), alignment: .center)
    private let saveButton = PawButton(image: SFSymbols.checkmark, tintColor: .black, font: .systemFont(ofSize: 16, weight: .bold))
    private lazy var headingStack = PawStackView(views: [dismissButton, filterTitle, saveButton], distribution: .fillEqually, alignment: .fill)
    
    private let iWannaMeetLabel = PawLabel(text: "I wanna meet:", textColor: .gray, font: .systemFont(ofSize: 18, weight: .bold), alignment: .left)
    private let maleButton = PawButton(title: "🙋‍♂️", font: .systemFont(ofSize: 30, weight: .bold))
    private let femaleButton = PawButton(title: "🙋‍♀️", font: .systemFont(ofSize: 30, weight: .bold))
    private let allButton = PawButton(title: "🙋‍♂️🙋‍♀️", font: .systemFont(ofSize: 30, weight: .bold))
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
    
    private lazy var optionsStack = PawStackView(views: [genderStack, ageStack, distanceStack], axis: .vertical, distribution: .equalSpacing, alignment: .fill)
    
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
        
        [maleButton, femaleButton, allButton].forEach({
            $0.backgroundColor = .white
            $0.layer.borderWidth = 3
            $0.layer.cornerRadius = 20
            $0.layer.borderColor = UIColor.lightGray.cgColor
        })
    }
    
    func layoutFilterCard() {
        filterCardView.addSubviews(headingStack, optionsStack)
        headingStack.setDimension(height: filterCardView.heightAnchor, hMult: 0.1)
        headingStack.anchor(top: filterCardView.topAnchor, trailing: filterCardView.trailingAnchor, leading: filterCardView.leadingAnchor, paddingTop: 15, paddingTrailing: 25, paddingLeading: 25)
        
        optionsStack.anchor(top: headingStack.bottomAnchor, trailing: headingStack.trailingAnchor, bottom: filterCardView.bottomAnchor, leading: headingStack.leadingAnchor, paddingTop: 15, paddingBottom: 50)
        
        genderStack.setDimension(height: filterCardView.widthAnchor, hMult: 0.25)
        iWannaMeetLabel.setDimension(hConst: 20)

        minLabel.setDimension(width: filterCardView.widthAnchor, wMult: 0.17)
        maxLabel.setDimension(width: filterCardView.widthAnchor, wMult: 0.17)

        milesLabel.setDimension(width: filterCardView.widthAnchor, wMult: 0.17)
    }
    
    func showFilterView() {
        if let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            keyWindow.addSubview(self.blackBgView)
            self.blackBgView.frame = keyWindow.frame
            
            keyWindow.addSubview(filterCardView)
            let height = keyWindow.frame.width * 1.15
            filterCardView.frame = .init(x: 0, y: keyWindow.frame.height, width: keyWindow.frame.width, height: height)
            
            layoutFilterCard()
            
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn) {[weak self] in
                guard let self = self else { return }
                self.blackBgView.alpha = 1
                self.filterCardView.frame.origin.y = keyWindow.frame.height - height
            }
        }
    }
    
    func setupActionsAndGestures() {
        blackBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissFilterView)))
        dismissButton.addTarget(self, action: #selector(dismissFilterView), for: .touchUpInside)
    }
    
    // MARK: - Selector
    @objc func dismissFilterView() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn) {[weak self] in
            guard let self = self else { return }
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            self.blackBgView.alpha = 0
            if let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
                self.filterCardView.frame.origin.y = keyWindow.frame.height
            }
        }
    }
}
