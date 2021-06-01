//
//  FilterVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/29/21.
//

import UIKit


protocol FilterVCDelegate: AnyObject {
    func didPressSaveFilter()
}

class FilterVC: UIViewController {
    // MARK: - Properties
    weak var delegate: FilterVCDelegate?
    var user: User?
    var filterViewLauncher: FilterViewLauncher?
    
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
        setupActionsAndGestures()
    }
    
    // MARK: - Helpers
    private func setupNavBar() {
        navigationItem.title = "Filter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        navigationController?.navigationBar.barTintColor = .white
    }
    
    private func configureUI() {
        saveButton.layer.cornerRadius = 50/2
        saveButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        preferenceFormView.delegate = self
    }
    
    private func layoutUI() {
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
    
    func loadDataFor(user: User?) {
        guard let user = user else { return }
        preferenceFormView.loadGenderPreference(user: user)
        preferenceFormView.loadBreedPreference()
        preferenceFormView.loadSliderValues()
    }
    
    private func setupActionsAndGestures() {
        saveButton.addTarget(self, action: #selector(saveAndApplyFilters), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    @objc func handleDone() {
        filterViewLauncher?.dismissFilterView()
    }
    
    @objc func saveAndApplyFilters() {
        delegate?.didPressSaveFilter()
    }
}

// MARK: - PreferenceFormViewDelegate
extension FilterVC: PreferenceFormViewDelegate {
    func didTapBreedPreference() {
        let breedSearchVC = BreedSearchVC()
        breedSearchVC.isChoosingBreedPref = true
        breedSearchVC.didSelectBreedHandler = { [weak self] in
            self?.preferenceFormView.loadBreedPreference()
        }
        navigationController?.pushViewController(breedSearchVC, animated: true)
    }
}
