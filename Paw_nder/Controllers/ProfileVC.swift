//
//  NewSettingVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/14/21.
//

import UIKit
import SwiftUI

class ProfileVC: LoadingViewController {
    // MARK: - Properties
    var imagePickerButtonTag: Int?
    var settingsVM = SettingsViewModel.shared
    
    // MARK: - Views
    private let saveButton = PawButton(image: SFSymbols.saveCloud, tintColor: .white, font: .systemFont(ofSize: 12, weight: .black))
    private let imagePickerView = ImagePickerView()
    
    private let infoContainerView = PawView(bgColor: lightGray)
    private let nameLabel = PawLabel(text: "William Yeung", textColor: .black, font: .systemFont(ofSize: 25, weight: .bold), alignment: .left)
    private let breedAgeLabel = PawLabel(text: "Golden Retriever • 34 yrs", textColor: lightRed, font: .systemFont(ofSize: 12, weight: .semibold), alignment: .left)
    private lazy var headingStack = PawStackView(views: [nameLabel, breedAgeLabel], spacing: 5, axis: .vertical, distribution: .fill, alignment: .fill)
    private let settingsButton = PawButton(image: SFSymbols.gears, tintColor: .white, font: .systemFont(ofSize: 14, weight: .black))
    
    private let genderLabel = PaddedLabel(text: "Female", font: .systemFont(ofSize: 14, weight: .bold), padding: 8)
    private let locationLabel = IconLabel(text: "Los Angelos, CA", image: mappin, cornerRadius: 10)
    
    private let bioLabel = PawLabel(text: "", textColor: .black, font: .systemFont(ofSize: 16, weight: .medium), alignment: .left)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
        setupActionsAndObservers()
        fetchCurrentUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = bgLightGray
        settingsButton.backgroundColor = .gray
        settingsButton.layer.cornerRadius = 35/2
        saveButton.backgroundColor = .gray
        saveButton.layer.cornerRadius = 35/2
        infoContainerView.layer.cornerRadius = 15
        genderLabel.backgroundColor = #colorLiteral(red: 1, green: 0.4016966522, blue: 0.4617980123, alpha: 0.1497695853)
        genderLabel.textColor = lightRed
        genderLabel.layer.cornerRadius = 10
        genderLabel.clipsToBounds = true
        bioLabel.numberOfLines = 0
        bioLabel.backgroundColor = .green
    }

    private func layoutUI() {
        edgesForExtendedLayout = []
        view.addSubviews(imagePickerView, saveButton, infoContainerView)
        
        saveButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor, paddingTop: 10, paddingTrailing: 25)
        saveButton.setDimension(wConst: 35, hConst: 35)
        
        imagePickerView.setDimension(width: view.widthAnchor, height: view.heightAnchor, wMult: 0.9, hMult: 0.45)
        imagePickerView.center(to: view, by: .centerX)
        imagePickerView.anchor(top: saveButton.bottomAnchor, paddingTop: 25)
        
        infoContainerView.anchor(top: imagePickerView.bottomAnchor, trailing: imagePickerView.trailingAnchor, bottom: view.bottomAnchor, leading: imagePickerView.leadingAnchor, paddingTop: 35, paddingBottom: 25)
        
        layoutTextualInfo()
    }
    
    private func layoutTextualInfo(){
        infoContainerView.addSubviews(settingsButton, headingStack, genderLabel, locationLabel, bioLabel)
        
        settingsButton.anchor(top: infoContainerView.topAnchor, trailing: infoContainerView.trailingAnchor, paddingTop: 15, paddingTrailing: 15)
        settingsButton.setDimension(wConst: 35, hConst: 35)
        
        headingStack.anchor(top: settingsButton.topAnchor, trailing: settingsButton.leadingAnchor, leading: infoContainerView.leadingAnchor, paddingTrailing: 15, paddingLeading: 15)
        nameLabel.setDimension(hConst: 30)
        breedAgeLabel.setDimension(hConst: 15)
        
        genderLabel.anchor(top: headingStack.bottomAnchor, leading: headingStack.leadingAnchor, paddingTop: 10)
        locationLabel.anchor(top: genderLabel.topAnchor, bottom: genderLabel.bottomAnchor, leading: genderLabel.trailingAnchor, paddingLeading: 10)
        
        bioLabel.anchor(top: locationLabel.bottomAnchor, trailing: settingsButton.trailingAnchor, leading: nameLabel.leadingAnchor, paddingTop: 15)
    }
    
    private func setupActionsAndObservers() {
        settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveImages), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSelectPhotoTapped(notification:)), name: .didOpenImagePicker, object: nil)
    }
    
    func fetchCurrentUserInfo() {
        FirebaseManager.shared.fetchCurrentUser { [weak self] (result) in
            switch result {
            case .success(let user):
                self?.settingsVM.user = user
                #warning("Refactor")
                self?.imagePickerView.setCurrentUserImage(urlStringsDictionary: self?.settingsVM.user?.imageUrls)
                self?.nameLabel.text = self?.settingsVM.user?.name
                self?.breedAgeLabel.text = self?.settingsVM.userBreedAge
                self?.breedAgeLabel.textColor = self?.settingsVM.userGender.textColor
                self?.genderLabel.text = self?.settingsVM.userGender.text
                self?.genderLabel.textColor = self?.settingsVM.userGender.textColor
                self?.genderLabel.backgroundColor = self?.settingsVM.userGender.bgColor
                self?.bioLabel.text = self?.settingsVM.user?.bio
            case .failure(let error):
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    private func handleUpdateCompletion(error: Error?) {
        if let error = error {
           showAlert(title: "Error", message: error.localizedDescription)
        }

        dismissLoader()
        NotificationCenter.default.post(Notification(name: .didSaveSettings, object: nil, userInfo: nil))
    }
    
    // MARK: - Selector
    @objc func openSettings() {
        let settingsVC = SettingsVC()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc func saveImages() {
        showLoader()
        
        settingsVM.updateUserImages { [weak self] error in
            self?.handleUpdateCompletion(error: error)
        }
    }
    
    @objc func handleSelectPhotoTapped(notification: Notification) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePickerButtonTag = notification.userInfo?[buttonTag] as? Int
        present(imagePicker, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        settingsVM.selectedImages[imagePickerButtonTag!] = selectedImage
        NotificationCenter.default.post(Notification(name: .didSelectPhoto, object: nil, userInfo: [imagePickerButtonTag: selectedImage]))
        dismiss(animated: true, completion: nil)
    }
}
