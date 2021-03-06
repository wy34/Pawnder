//
//  LoginVC.swift
//  Paw_nder
//
//  Created by William Yeung on 4/28/21.
//

import UIKit
import SwiftUI

class LoginVC: LoadingViewController {
    // MARK: - Properties
    var loginVM = LoginViewModel()
    
    // MARK: - Views
    private let gradientView = GradientView()
    private let iconImageView = PawImageView(image: Assets.icon, contentMode: .scaleAspectFit)
    private let captionLabel = PawLabel(text: "Connecting the Dog Community", textColor: .black, font: markerFont(20), alignment: .center)
    private let containerView = PawView(bgColor: .white, cornerRadius: 35)
    private let titleLabel = PawLabel(text: "Login", font: markerFont(30), alignment: .left)
    private let emailTextField = IconTextfield(placeholder: "Email", font: markerFont(18), icon: SFSymbols.envelope)
    private let passwordTextField = IconTextfield(placeholder: "Password", font: markerFont(18), icon: SFSymbols.lock)
    private let newUserButton = PawButton(title: "New User?", textColor: .lightGray, font: markerFont(18))
    private let loginButton = PawButton(title: "Login", textColor: .gray, font: markerFont(18))
    private lazy var buttonStack = PawStackView(views: [newUserButton, loginButton], spacing: 15, distribution: .fillEqually)
    private lazy var formStack = PawStackView(views: [titleLabel, emailTextField, passwordTextField, buttonStack], spacing: 18, axis: .vertical, distribution: .fillEqually, alignment: .fill)
    private let forgotPasswordButton = PawButton(title: "Forgot Password?", textColor: .darkGray, bgColor: .clear)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
        setupFormActions()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        emailTextField.addBorderTo(side: .bottom, bgColor: Colors.lightGray, dimension: 2)
        passwordTextField.addBorderTo(side: .bottom, bgColor: Colors.lightGray, dimension: 2)
        passwordTextField.isSecureTextEntry = true
        loginButton.contentHorizontalAlignment = .center
        loginButton.isEnabled = false
        loginButton.backgroundColor = .lightGray
        loginButton.layer.cornerRadius = 10
        newUserButton.contentHorizontalAlignment = .left
        forgotPasswordButton.titleLabel?.font = markerFont(14)
    }
    
    private func layoutUI() {
        view.addSubviews(gradientView, iconImageView, captionLabel, containerView, forgotPasswordButton)
        gradientView.fill(superView: view)
        
        iconImageView.center(to: view, by: .centerX)
        iconImageView.center(to: view, by: .centerY, withMultiplierOf: 0.185)
        iconImageView.setDimension(wConst: 45, hConst: 45)
        
        captionLabel.setDimension(width: view.widthAnchor, wMult: 0.8)
        captionLabel.center(to: view, by: .centerX)
        captionLabel.center(to: view, by: .centerY, withMultiplierOf: 0.34)
        
        containerView.setDimension(width: view.widthAnchor, height: view.widthAnchor, wMult: 0.8, hMult: 0.6)
        containerView.center(to: view, by: .centerX)
        containerView.center(to: view, by: .centerY, withMultiplierOf: 0.75)
        
        containerView.addSubview(formStack)
        formStack.center(x: containerView.centerXAnchor, y: containerView.centerYAnchor)
        formStack.setDimension(width: containerView.widthAnchor, height: containerView.heightAnchor, wMult: 0.8, hMult: 0.8)
        
        forgotPasswordButton.anchor(top: containerView.bottomAnchor, leading: containerView.leadingAnchor, paddingTop: 5, paddingLeading: 31)
    }
    
    private func setupFormActions() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapToDismissKB)))
        newUserButton.addTarget(self, action: #selector(handleNewUserTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        emailTextField.addTarget(self, action: #selector(handleTextfieldChanged(textfield:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextfieldChanged(textfield:)), for: .editingChanged)
        forgotPasswordButton.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    @objc func handleTapToDismissKB() {
        view.endEditing(true)
    }
    
    @objc func handleNewUserTapped() {
        view.endEditing(true)
        navigationController?.pushViewController(RegisterVC(), animated: true)
    }
    
    @objc func loginTapped() {
        showLoader()
        loginVM.loginUser { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Error", message: error.localizedDescription)
                self?.dismissLoader()
                return
            }
            
            self?.dismissLoader()
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleTextfieldChanged(textfield: UITextField) {
        if textfield == emailTextField {
            loginVM.email = textfield.text ?? ""
        } else {
            loginVM.password = textfield.text ?? ""
        }
        
        loginButton.isEnabled = loginVM.isFormValid
        loginButton.backgroundColor = loginVM.formButtonColor.bgColor
        loginButton.setTitleColor(loginVM.formButtonColor.textColor, for: .normal)
    }
    
    @objc func handleForgotPassword() {
        let resetPasswordVC = ResetPasswordVC()
        navigationController?.pushViewController(resetPasswordVC, animated: true)
    }
}
