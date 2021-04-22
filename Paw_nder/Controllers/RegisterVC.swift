//
//  RegisterVC.swift
//  Paw_nder
//
//  Created by William Yeung on 4/21/21.
//

import UIKit

class RegisterVC: UIViewController {
    // MARK: - Properties
    let registerVM = RegisterViewModel()
    
    // MARK: - Views
    private let backgroundFillerView = PawView(bgColor: bgWhite)
    private let profileImageButton = PawButton(image: placeholderProfile)
    private let slideupView = PawView(bgColor: bgWhite, cornerRadius: 35)
    
    private let titleLabel = PawLabel(text: "Sign Up", font: .systemFont(ofSize: 30, weight: .bold), alignment: .left)
    private let nameTextField = PawTextField(placeholder: "Full name")
    private let emailTextField = PawTextField(placeholder: "Email")
    private let passwordTextField = PawTextField(placeholder: "Password")
    
    private let alreadyHaveAccountButton = PawButton(title: "Already have an account?", textColor: .red, font: UIFont.systemFont(ofSize: 16, weight: .medium))
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
        setupTextfieldTargets()
    }

    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .red
        slideupView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        alreadyHaveAccountButton.contentHorizontalAlignment = .left
        registerButton.contentHorizontalAlignment = .right
        registerButton.isEnabled = false
        nameTextField.addBorderTo(side: .bottom, bgColor: textFieldBorderGray, dimension: 1)
        emailTextField.addBorderTo(side: .bottom, bgColor: textFieldBorderGray, dimension: 1)
        passwordTextField.addBorderTo(side: .bottom, bgColor: textFieldBorderGray, dimension: 1)
    }
    
    func layoutUI() {
        view.addSubviews(profileImageButton, backgroundFillerView, slideupView)
        
        profileImageButton.center(to: view, by: .centerX)
        profileImageButton.center(to: view, by: .centerY, withMultiplierOf: 0.6)
        profileImageButton.setDimension(width: view.widthAnchor, height: view.widthAnchor, wMult: 0.75, hMult: 0.75)
        
        backgroundFillerView.anchor(trailing: view.trailingAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor)
        backgroundFillerView.setDimension(height: view.heightAnchor, hMult: 0.45)
        slideupView.anchor(trailing: view.trailingAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor)
        slideupView.setDimension(height: view.heightAnchor, hMult: 0.5)
        
        slideupView.addSubview(formStack)
        formStack.center(x: slideupView.centerXAnchor, y: slideupView.centerYAnchor)
        formStack.setDimension(width: slideupView.widthAnchor, height: slideupView.heightAnchor, wMult: 0.8, hMult: 0.8)
        registerButton.setDimension(width: formStack.widthAnchor, wMult: 0.3)
    }
    
    func setupKeyboardListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupTextfieldTargets() {
        nameTextField.addTarget(self, action: #selector(handleTextfieldChanged), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(handleTextfieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextfieldChanged), for: .editingChanged)
    }
    
    func setupSwipeGesture() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipeDown.direction = .down
        slideupView.addGestureRecognizer(swipeDown)
    }
    
    // MARK: - Selector
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
}
