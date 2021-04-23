//
//  RegisterVC.swift
//  Paw_nder
//
//  Created by William Yeung on 4/21/21.
//

import UIKit
import SwiftUI

class RegisterVC: UIViewController {
    // MARK: - Properties
    let registerVM = RegisterViewModel()
    let profileImageViewSizeMultiplier: CGFloat = 0.5
    
    // MARK: - Views
    private let backgroundFillerView = PawView(bgColor: bgWhite)
    private let profileImageView = ProfileImageView()
    private let slideupView = PawView(bgColor: bgWhite, cornerRadius: 35)
    
    private let titleLabel = PawLabel(text: "Sign Up", font: .systemFont(ofSize: 30, weight: .bold), alignment: .left)
    private let nameTextField = PawTextField(placeholder: "Full name")
    private let emailTextField = PawTextField(placeholder: "Email")
    private let passwordTextField = PawTextField(placeholder: "Password")
    
    private let alreadyHaveAccountButton = PawButton(title: "Already have an account?", textColor: lightOrange, font: UIFont.systemFont(ofSize: 16, weight: .medium))
    private let registerButton = PawButton(title: "Sign Up", textColor: .lightGray, font: UIFont.systemFont(ofSize: 16, weight: .bold))
    private lazy var buttonStack = PawStackView(views: [alreadyHaveAccountButton, registerButton], spacing: 15, alignment: .fill)
    
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
        view.backgroundColor = lightOrange
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = UIScreen.main.bounds.width * profileImageViewSizeMultiplier / 2
        slideupView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        alreadyHaveAccountButton.contentHorizontalAlignment = .left
        registerButton.contentHorizontalAlignment = .right
        registerButton.isEnabled = false
        nameTextField.addBorderTo(side: .bottom, bgColor: lightGray, dimension: 1)
        emailTextField.addBorderTo(side: .bottom, bgColor: lightGray, dimension: 1)
        passwordTextField.addBorderTo(side: .bottom, bgColor: lightGray, dimension: 1)
    }
    
    private func layoutUI() {
        view.addSubviews(profileImageView, backgroundFillerView, slideupView)
        
        profileImageView.center(to: view, by: .centerX)
        profileImageView.center(to: view, by: .centerY, withMultiplierOf: 0.6)
        profileImageView.makePerfectSquare(anchor: view.widthAnchor, multiplier: profileImageViewSizeMultiplier)

        backgroundFillerView.anchor(trailing: view.trailingAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor)
        backgroundFillerView.setDimension(height: view.heightAnchor, hMult: 0.45)
        slideupView.anchor(trailing: view.trailingAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor)
        slideupView.setDimension(height: view.heightAnchor, hMult: 0.5)
        
        slideupView.addSubview(formStack)
        formStack.center(x: slideupView.centerXAnchor, y: slideupView.centerYAnchor)
        formStack.setDimension(width: slideupView.widthAnchor, height: slideupView.heightAnchor, wMult: 0.8, hMult: 0.8)
        registerButton.setDimension(width: formStack.widthAnchor, wMult: 0.3)
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
            
        registerButton.setTitleColor(registerVM.isFormValid ? .black : .lightGray, for: .normal)
        registerButton.isEnabled = registerVM.isFormValid ? true : false
    }
    
    @objc func handleSignUpTapped() {
        
    }
}

// MARK: - UIImagePickerController, UINavigationControllerDelegate
extension RegisterVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[.originalImage] as? UIImage else { return }
        registerVM.bindableImage.value = pickedImage
        dismiss(animated: true, completion: nil)
    }
}
