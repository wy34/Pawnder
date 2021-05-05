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
    private let iconImageView = PawImageView(image: icon, contentMode: .scaleAspectFit)
    private let containerView = PawView(bgColor: .white, cornerRadius: 35)
    private let titleLabel = PawLabel(text: "Login", font: .systemFont(ofSize: 30, weight: .bold), alignment: .left)
    private let emailTextField = IconTextfield(placeholder: "Email", font: .systemFont(ofSize: 16, weight: .medium), icon: SFSymbols.envelope)
    private let passwordTextField = IconTextfield(placeholder: "Password", font: .systemFont(ofSize: 16, weight: .medium), icon: SFSymbols.lock)
    private let newUserButton = PawButton(title: "New User?", textColor: .lightGray, font: UIFont.systemFont(ofSize: 16, weight: .bold))
    private let loginButton = PawButton(title: "Login", textColor: .gray, font: UIFont.systemFont(ofSize: 16, weight: .bold))
    private lazy var buttonStack = PawStackView(views: [newUserButton, loginButton], spacing: 15, distribution: .fillEqually)
    private lazy var formStack = PawStackView(views: [titleLabel, emailTextField, passwordTextField, buttonStack], spacing: 18, axis: .vertical, distribution: .fillEqually, alignment: .fill)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
        setupFormActions()
    }
    
    // MARK: - Helpers
    func configureUI() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        emailTextField.addBorderTo(side: .bottom, bgColor: lightGray, dimension: 2)
        passwordTextField.addBorderTo(side: .bottom, bgColor: lightGray, dimension: 2)
        passwordTextField.isSecureTextEntry = true
        loginButton.contentHorizontalAlignment = .center
        loginButton.isEnabled = false
        loginButton.backgroundColor = .lightGray
        loginButton.layer.cornerRadius = 10
        newUserButton.contentHorizontalAlignment = .left
    }
    
    func layoutUI() {
        view.addSubviews(gradientView, iconImageView, containerView)
        gradientView.fill(superView: view)
        
        iconImageView.center(to: view, by: .centerX)
        iconImageView.center(to: view, by: .centerY, withMultiplierOf: 0.175)
        iconImageView.setDimension(wConst: 45, hConst: 45)
        
        containerView.setDimension(width: view.widthAnchor, height: view.heightAnchor, wMult: 0.8, hMult: 0.3)
        containerView.center(to: view, by: .centerX)
        containerView.center(to: view, by: .centerY, withMultiplierOf: 0.75)
        
        containerView.addSubview(formStack)
        formStack.center(x: containerView.centerXAnchor, y: containerView.centerYAnchor)
        formStack.setDimension(width: containerView.widthAnchor, height: containerView.heightAnchor, wMult: 0.8, hMult: 0.8)
    }
    
    func setupFormActions() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapToDismissKB)))
        newUserButton.addTarget(self, action: #selector(handleNewUserTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        emailTextField.addTarget(self, action: #selector(handleTextfieldChanged(textfield:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextfieldChanged(textfield:)), for: .editingChanged)
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
}
