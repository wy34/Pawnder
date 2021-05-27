//
//  FilterVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/3/21.
//

import UIKit
import SwiftUI

protocol FilterViewLauncherDelegate: AnyObject {
    func didPressSaveFilter()
}

class FilterViewLauncher: UIView {
    // MARK: - Properties
    weak var delegate: FilterViewLauncherDelegate?
    
    // MARK: - Views
    private let blackBgView = PawView(bgColor: .black.withAlphaComponent(0.5))
    
    private let filterCardView = PawView(bgColor: bgLightGray, cornerRadius: 30)
    private let dismissButton = PawButton(image: SFSymbols.xmark, tintColor: .black, font: .systemFont(ofSize: 16, weight: .bold))
    private let filterTitle = PawLabel(text: "Filters", font: .systemFont(ofSize: 22, weight: .bold), alignment: .center)
    private let saveButton = PawButton(image: SFSymbols.checkmark, tintColor: .black, font: .systemFont(ofSize: 16, weight: .bold))
    private lazy var headingStack = PawStackView(views: [dismissButton, filterTitle, saveButton], distribution: .fillEqually, alignment: .fill)
    
    private let preferenceFormView = PreferenceFormView()
    
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
    private func configureUI() {
        dismissButton.contentHorizontalAlignment = .left
        saveButton.contentHorizontalAlignment = .right
        blackBgView.alpha = 0
    }
    
    private func layoutFilterCard() {
        filterCardView.addSubviews(headingStack, preferenceFormView)
        headingStack.setDimension(height: filterCardView.heightAnchor, hMult: 0.1)
        headingStack.anchor(top: filterCardView.topAnchor, trailing: filterCardView.trailingAnchor, leading: filterCardView.leadingAnchor, paddingTop: 15, paddingTrailing: 30, paddingLeading: 30)
        preferenceFormView.anchor(top: headingStack.bottomAnchor, trailing: filterCardView.trailingAnchor, bottom: filterCardView.bottomAnchor, leading: filterCardView.leadingAnchor, paddingTop: 25, paddingBottom: 10)
    }
    
    func showFilterViewFor(user: User?) {
        preferenceFormView.loadSliderValuesFor(user: user)
        preferenceFormView.loadGenderPreference()
        
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
    
    private func setupActionsAndGestures() {
        blackBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissFilterView)))
        dismissButton.addTarget(self, action: #selector(dismissFilterView), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveAndApplyFilters), for: .touchUpInside)
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
    
    @objc func saveAndApplyFilters() {
        delegate?.didPressSaveFilter()
    }
}
