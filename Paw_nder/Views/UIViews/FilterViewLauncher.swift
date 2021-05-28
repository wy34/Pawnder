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
//    private let dismissButton = PawButton(image: SFSymbols.xmark, tintColor: lightRed, font: .systemFont(ofSize: 16, weight: .bold))
//    private let filterTitle = PawLabel(text: "Filters", font: .systemFont(ofSize: 22, weight: .bold), alignment: .center)
//    private lazy var headingStack = PawStackView(views: [dismissButton, filterTitle, UIView()], distribution: .fillEqually, alignment: .fill)
//
//    private let preferenceFormView = PreferenceFormView()
    
//    private let saveButtonContainerView = PawView(bgColor: .clear)
//    private let saveButton = PawButton(title: "Save", textColor: .white, bgColor: lightRed)
    
    private let bgFillerView = PawView(bgColor: .white)
    let nav = UINavigationController(rootViewController: FilterVC())
    
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
        blackBgView.alpha = 0
        bgFillerView.layer.cornerRadius = 30
        bgFillerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        saveButton.layer.cornerRadius = 50/2
//        saveButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    private func layoutFilterCard() {
        filterCardView.addSubviews(bgFillerView, nav.view)
        bgFillerView.anchor(top: filterCardView.topAnchor, trailing: filterCardView.trailingAnchor, leading: filterCardView.leadingAnchor)
        bgFillerView.setDimension(hConst: 50)
        
        nav.view.anchor(top: filterCardView.topAnchor, trailing: filterCardView.trailingAnchor, bottom: filterCardView.bottomAnchor, leading: filterCardView.leadingAnchor, paddingTop: 12)
        nav.view.layer.cornerRadius = 30
//        filterCardView.addSubviews(headingStack, saveButtonContainerView, preferenceFormView)
//        headingStack.setDimension(hConst: 35)
//        headingStack.anchor(top: filterCardView.topAnchor, trailing: filterCardView.trailingAnchor, leading: filterCardView.leadingAnchor, paddingTop: 30, paddingTrailing: 30, paddingLeading: 30)
//
//        saveButtonContainerView.anchor(bottom: filterCardView.bottomAnchor, paddingBottom: 30)
//        saveButtonContainerView.setDimension(width: filterCardView.widthAnchor, height: filterCardView.widthAnchor, hMult: 0.333)
//        saveButtonContainerView.addSubview(saveButton)
//        saveButton.center(x: saveButtonContainerView.centerXAnchor, y: saveButtonContainerView.centerYAnchor)
//        saveButton.setDimension(width: filterCardView.widthAnchor, wMult: 0.5)
//        saveButton.setDimension(hConst: 50)
//
//        preferenceFormView.anchor(top: headingStack.bottomAnchor,  bottom: saveButtonContainerView.topAnchor, paddingTop: 25, paddingBottom: 15)
//        preferenceFormView.setDimension(width: filterCardView.widthAnchor)
    }
    
    func showFilterViewFor(user: User?) {
//        preferenceFormView.loadBreedPreference(user: user)
//        preferenceFormView.loadSliderValuesFor()
//        preferenceFormView.loadGenderPreference()
        
        if let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            keyWindow.addSubview(self.blackBgView)
            self.blackBgView.frame = keyWindow.frame
            
            keyWindow.addSubview(filterCardView)
            let height = keyWindow.frame.width * 1.75
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
//        dismissButton.addTarget(self, action: #selector(dismissFilterView), for: .touchUpInside)
//        saveButton.addTarget(self, action: #selector(saveAndApplyFilters), for: .touchUpInside)
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









class FilterVC: UIViewController {
    // MARK: - Properties
    
    // MARK: - Views
    private let preferenceFormView = PreferenceFormView()
    
    private let saveButtonContainerView = PawView(bgColor: .clear)
    private let saveButton = PawButton(title: "Save", textColor: .white, bgColor: lightRed)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        configureUI()
        layoutUI()
    }
    
    // MARK: - Helpers
    func setupNavBar() {
        navigationItem.title = "Filter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        navigationController?.navigationBar.barTintColor = .white
    }
    
    func configureUI() {
        saveButton.layer.cornerRadius = 50/2
        saveButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        preferenceFormView.delegate = self
    }
    
    func layoutUI() {
        view.addSubviews(saveButtonContainerView, preferenceFormView)
        saveButtonContainerView.anchor(bottom: view.bottomAnchor, paddingBottom: 30)
        saveButtonContainerView.setDimension(width: view.widthAnchor, height: view.widthAnchor, hMult: 0.333)
        saveButtonContainerView.addSubview(saveButton)
        saveButton.center(x: saveButtonContainerView.centerXAnchor, y: saveButtonContainerView.centerYAnchor)
        saveButton.setDimension(width: view.widthAnchor, wMult: 0.5)
        saveButton.setDimension(hConst: 50)

        preferenceFormView.anchor(top: view.topAnchor,  bottom: saveButtonContainerView.topAnchor, paddingTop: 25, paddingBottom: 15)
        preferenceFormView.setDimension(width: view.widthAnchor)
    }
    
    // MARK: - Selectors
    @objc func handleDone() {
        
    }
}

// MARK: - PreferenceFormViewDelegate
extension FilterVC: PreferenceFormViewDelegate {
    func didTapBreedPreference() {
        let breedSearchVC = BreedSearchVC()
        navigationController?.pushViewController(breedSearchVC, animated: true)
    }
}
