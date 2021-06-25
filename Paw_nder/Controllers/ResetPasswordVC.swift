//
//  ForgotPasswordVC.swift
//  Paw_nder
//
//  Created by William Yeung on 6/24/21.
//

import UIKit
import Firebase

class ResetPasswordVC: UIViewController {
    // MARK: - Properties
    
    // MARK: - Views
    private let gradientView = GradientView()
    private let iconImageView = PawImageView(image: Assets.icon, contentMode: .scaleAspectFit)
    
    private let containerView = PawView(bgColor: .white, cornerRadius: 35)

    private let titleLabel = PawLabel(text: "Reset Password", textColor: .black, font: .systemFont(ofSize: 16, weight: .medium), alignment: .center)
    private let captionLabel = PawLabel(text: "Enter your email address below to reset password", textColor: .gray, font: .systemFont(ofSize: 16, weight: .medium), alignment: .center)
    private let emailTextField = IconTextfield(placeholder: "Email", font: .systemFont(ofSize: 16, weight: .medium), icon: SFSymbols.envelope)
    
    private let backBtn = PawButton(title: "Back", textColor: .lightGray, font: UIFont.systemFont(ofSize: 16, weight: .bold))
    private let resetPasswordBtn = PawButton(title: "Reset", textColor: .gray, font: UIFont.systemFont(ofSize: 16, weight: .bold))
    private lazy var buttonStack = PawStackView(views: [backBtn, resetPasswordBtn], spacing: 0, distribution: .fillEqually)
    
    private lazy var textFieldButtonStack = PawStackView(views: [emailTextField, buttonStack], spacing: 5, axis: .vertical, distribution: .fillEqually, alignment: .fill)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
        setupActionsAndObservers()
    }

    // MARK: - Helpers
    private func configureUI() {
        captionLabel.numberOfLines = 0
        emailTextField.backgroundColor = .white
        emailTextField.addBorderTo(side: .bottom, bgColor: Colors.lightGray, dimension: 2)
        backBtn.contentHorizontalAlignment = .left
        backBtn.layer.cornerRadius = 10
        resetPasswordBtn.isEnabled = false
        resetPasswordBtn.layer.cornerRadius = 10
        resetPasswordBtn.backgroundColor = .lightGray
        emailTextField.becomeFirstResponder()
    }
    
    private func layoutUI() {
        view.addSubviews(gradientView, iconImageView, titleLabel, containerView)
        gradientView.fill(superView: view)
        iconImageView.center(to: view, by: .centerX)
        iconImageView.center(to: view, by: .centerY, withMultiplierOf: 0.185)
        iconImageView.setDimension(wConst: 45, hConst: 45)
        
        titleLabel.setDimension(width: view.widthAnchor, wMult: 0.8)
        titleLabel.center(to: view, by: .centerX)
        titleLabel.center(to: view, by: .centerY, withMultiplierOf: 0.34)
        
        containerView.setDimension(width: view.widthAnchor, height: view.widthAnchor, wMult: 0.8, hMult: 0.5)
        containerView.center(to: view, by: .centerX)
        containerView.center(to: view, by: .centerY, withMultiplierOf: 0.75)
        
        containerView.addSubviews(captionLabel, textFieldButtonStack)
        captionLabel.setDimension(width: containerView.widthAnchor, height: containerView.heightAnchor, wMult: 0.8, hMult: 0.25)
        captionLabel.anchor(top: containerView.topAnchor, paddingTop: 15)
        captionLabel.center(to: containerView, by: .centerX)
        textFieldButtonStack.anchor(top: captionLabel.bottomAnchor, trailing: captionLabel.trailingAnchor, bottom: containerView.bottomAnchor, leading: captionLabel.leadingAnchor, paddingBottom: 10)
    }
    
    private func setupActionsAndObservers() {
        backBtn.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        resetPasswordBtn.addTarget(self, action: #selector(sendResetEmail), for: .touchUpInside)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        emailTextField.addTarget(self, action: #selector(handleTextfieldChanged), for: .editingChanged)
    }
    
    // MARK: - Selectors
    @objc func dismissVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func handleTextfieldChanged() {
        guard let emailAddress = emailTextField.text else { return }
        resetPasswordBtn.isEnabled = !emailAddress.isEmpty
        resetPasswordBtn.backgroundColor = emailAddress.isEmpty ? .lightGray : Colors.lightRed
        resetPasswordBtn.setTitleColor(emailAddress.isEmpty ? .gray : .white, for: .normal)
    }
    
    @objc func sendResetEmail() {
        guard let emailAddress = emailTextField.text, !emailAddress.isEmpty else { return }

        Auth.auth().sendPasswordReset(withEmail: emailAddress) { error in
            if let error = error { self.showAlert(title: "Error", message: error.localizedDescription); return }
            self.showAlert(title: "Sent", message: "You should recieve an email shortly with instructions to reset your password.")
        }
    }
}
