//
//  RegisterVC.swift
//  Paw_nder
//
//  Created by William Yeung on 4/21/21.
//

import UIKit
import SwiftUI

class RegisterVC: LoadingViewController {
    // MARK: - Properties
    let registerVM = RegisterViewModel()
    let profileImageViewBorderSizeMultiplier: CGFloat = 0.525
    let profileImageViewSizeMultiplier: CGFloat = 0.5
    
    // MARK: - Views
    private let backgroundGradientView = GradientView()
    
    private let iconImageView = PawImageView(image: icon, contentMode: .scaleAspectFit)

    private let profileImageViewBorder = PawView(bgColor: lightGray)
    private let profileImageView = ProfileImageView()
    private let slideupView = PawView(bgColor: bgWhite, cornerRadius: 35)
    
    private let titleLabel = PawLabel(text: "Sign Up", font: .systemFont(ofSize: 30, weight: .bold), alignment: .left)
    private let nameTextField = IconTextfield(placeholder: "Full name", font: .systemFont(ofSize: 16, weight: .medium), icon: SFSymbols.person)
    private let emailTextField = IconTextfield(placeholder: "Email", font: .systemFont(ofSize: 16, weight: .medium), icon: SFSymbols.envelope)
    private let passwordTextField = IconTextfield(placeholder: "Password", font: .systemFont(ofSize: 16, weight: .medium), icon: SFSymbols.lock)
    
    private let existingUserButton = PawButton(title: "Existing User?", textColor: .lightGray, font: UIFont.systemFont(ofSize: 16, weight: .bold))
    private let registerButton = PawButton(title: "Sign Up", textColor: .gray, font: UIFont.systemFont(ofSize: 16, weight: .bold))
    private lazy var buttonStack = PawStackView(views: [existingUserButton, registerButton], spacing: 15, distribution: .fillEqually)
    
    private lazy var formStack = PawStackView(views: [titleLabel, nameTextField, emailTextField, passwordTextField, buttonStack], spacing: 18, axis: .vertical, distribution: .fillEqually, alignment: .fill)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
        setupKeyboardListener()
        setupSwipeGesture()
        setupFormActions()
        setupImagePickerObserver()
    }

    // MARK: - Helpers
    private func configureUI() {
        profileImageView.clipsToBounds = true
        profileImageViewBorder.layer.cornerRadius = UIScreen.main.bounds.width * profileImageViewBorderSizeMultiplier / 2
        profileImageView.layer.cornerRadius = UIScreen.main.bounds.width * profileImageViewSizeMultiplier / 2
        slideupView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        existingUserButton.contentHorizontalAlignment = .left
        registerButton.contentHorizontalAlignment = .center
        registerButton.isEnabled = false
        registerButton.backgroundColor = .lightGray
        registerButton.layer.cornerRadius = 10
        nameTextField.addBorderTo(side: .bottom, bgColor: lightGray, dimension: 2)
        emailTextField.addBorderTo(side: .bottom, bgColor: lightGray, dimension: 2)
        passwordTextField.addBorderTo(side: .bottom, bgColor: lightGray, dimension: 2)
        passwordTextField.isSecureTextEntry = true
    }
    
    private func layoutUI() {
        view.addSubviews(backgroundGradientView, iconImageView, profileImageViewBorder, profileImageView, slideupView)
        backgroundGradientView.fill(superView: view)
        
        iconImageView.center(to: view, by: .centerX)
        iconImageView.center(to: view, by: .centerY, withMultiplierOf: 0.175)
        iconImageView.setDimension(wConst: 45, hConst: 45)
        
        profileImageViewBorder.center(to: view, by: .centerX)
        profileImageViewBorder.center(to: view, by: .centerY, withMultiplierOf: 0.6)
        profileImageViewBorder.makePerfectSquare(anchor: view.widthAnchor, multiplier: profileImageViewBorderSizeMultiplier)
        
        profileImageView.center(to: view, by: .centerX)
        profileImageView.center(to: view, by: .centerY, withMultiplierOf: 0.6)
        profileImageView.makePerfectSquare(anchor: view.widthAnchor, multiplier: profileImageViewSizeMultiplier)

        slideupView.anchor(trailing: view.trailingAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor)
        slideupView.setDimension(height: view.heightAnchor, hMult: 0.5)
        
        slideupView.addSubview(formStack)
        formStack.center(x: slideupView.centerXAnchor, y: slideupView.centerYAnchor)
        formStack.setDimension(width: slideupView.widthAnchor, height: slideupView.heightAnchor, wMult: 0.8, hMult: 0.8)
    }
    
    private func setupKeyboardListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupFormActions() {
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        nameTextField.addTarget(self, action: #selector(handleTextfieldChanged), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(handleTextfieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextfieldChanged), for: .editingChanged)
        registerButton.addTarget(self, action: #selector(handleSignUpTapped), for: .touchUpInside)
        existingUserButton.addTarget(self, action: #selector(handleAlreadyHaveAccountTapped), for: .touchUpInside)
    }
    
    private func setupSwipeGesture() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipeDown.direction = .down
        slideupView.addGestureRecognizer(swipeDown)
    }
    
    private func setupImagePickerObserver() {
        registerVM.bindableImage.bind { [weak self] (pickedImage) in
            guard let self = self else { return }
            self.profileImageView.setProfileImage(uiImage: pickedImage!)
        }
    }
    
    // MARK: - Selector
    @objc func handleSelectPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleKeyboardShow(notification: Notification) {
        if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = frame.cgRectValue.height
            self.slideupView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
        }
    }
    
    @objc func handleKeyboardHide() {
        slideupView.transform = .identity
    }
    
    @objc func handleSwipeDown() {
        view.endEditing(true)
    }
    
    @objc func handleTextfieldChanged(textfield: UITextField) {
        if textfield == nameTextField {
            registerVM.fullName = textfield.text ?? ""
        } else if textfield == emailTextField {
            registerVM.email = textfield.text ?? ""
        } else {
            registerVM.password = textfield.text ?? ""
        }
            
        registerButton.setTitleColor(registerVM.formButtonColor.textColor, for: .normal)
        registerButton.backgroundColor = registerVM.formButtonColor.bgColor
        registerButton.isEnabled = registerVM.isFormValid ? true : false
    }
    
    @objc func handleSignUpTapped() {
        showLoader()
        view.endEditing(true)

        registerVM.registerUser { [weak self] (result) in
            guard let self = self else { return }
            self.dismissLoader()
            switch result {
                case .success(_):
                    NotificationCenter.default.post(Notification(name: .didRegisterNewUser, object: nil, userInfo: nil))
                    self.dismiss(animated: true, completion: nil)                 
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    @objc func handleAlreadyHaveAccountTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UIImagePickerController, UINavigationControllerDelegate
extension RegisterVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[.editedImage] as? UIImage else { return }
        registerVM.bindableImage.value = pickedImage
        dismiss(animated: true, completion: nil)
    }
}
