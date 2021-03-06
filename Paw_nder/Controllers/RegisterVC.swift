//
//  RegisterVC.swift
//  Paw_nder
//
//  Created by William Yeung on 4/21/21.
//

import UIKit
import Photos

class RegisterVC: LoadingViewController {
    // MARK: - Properties
    let registerVM = RegisterViewModel()
    let profileImageViewBorderSizeMultiplier: CGFloat = 0.525
    let profileImageViewSizeMultiplier: CGFloat = 0.5
    
    // MARK: - Views
    private let backgroundGradientView = GradientView()
    
    private let iconImageView = PawImageView(image: Assets.icon, contentMode: .scaleAspectFit)

    private let profileImageViewBorder = PawView(bgColor: Colors.lightGray)
    private let profileImageView = ProfileImageView()
    private let slideupView = PawView(bgColor: Colors.bgWhite, cornerRadius: 35)
    
    private let titleLabel = PawLabel(text: "Sign Up", font: markerFont(30), alignment: .left)
    
    private let maleButton = PawButton(image: Assets.male, tintColor: .lightGray)
    private let separatorView = PawView(bgColor: Colors.lightGray)
    private let femaleButton = PawButton(image: Assets.female, tintColor: .lightGray)
    private lazy var genderSelectStack = PawStackView(views: [maleButton, separatorView, femaleButton], spacing: 10, distribution: .fill)
    
    private lazy var headerStack = PawStackView(views: [titleLabel, genderSelectStack], spacing: 10, distribution: .fill)
    
    private let nameTextField = IconTextfield(placeholder: "Full name", font: markerFont(18), icon: SFSymbols.person)
    private let emailTextField = IconTextfield(placeholder: "Email", font: markerFont(18), icon: SFSymbols.envelope)
    private let passwordTextField = IconTextfield(placeholder: "Password", font: markerFont(18), icon: SFSymbols.lock)
    
    private let existingUserButton = PawButton(title: "Existing User?", textColor: .lightGray, font: markerFont(18))
    private let registerButton = PawButton(title: "Sign Up", textColor: .gray, font: markerFont(18))
    private lazy var buttonStack = PawStackView(views: [existingUserButton, registerButton], spacing: 15, distribution: .fillEqually)
    
    private lazy var formStack = PawStackView(views: [headerStack, nameTextField, emailTextField, passwordTextField, buttonStack], spacing: 18, axis: .vertical, distribution: .fillEqually, alignment: .fill)
        
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        nameTextField.addBorderTo(side: .bottom, bgColor: Colors.lightGray, dimension: 2)
        emailTextField.addBorderTo(side: .bottom, bgColor: Colors.lightGray, dimension: 2)
        passwordTextField.addBorderTo(side: .bottom, bgColor: Colors.lightGray, dimension: 2)
        passwordTextField.isSecureTextEntry = true
        separatorView.setDimension(wConst: 2, hConst: 25)
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
        
        genderSelectStack.setDimension(width: formStack.widthAnchor, height: titleLabel.heightAnchor, wMult: 0.25)
    }
    
    private func setupKeyboardListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupFormActions() {
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        maleButton.addTarget(self, action: #selector(handleGenderSelected(button:)), for: .touchUpInside)
        femaleButton.addTarget(self, action: #selector(handleGenderSelected(button:)), for: .touchUpInside)
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
    
    private func updateRegisterButtonStatus(){
        registerButton.setTitleColor(registerVM.formButtonColor.textColor, for: .normal)
        registerButton.backgroundColor = registerVM.formButtonColor.bgColor
        registerButton.isEnabled = registerVM.isFormValid ? true : false
    }
    
    private func presentImagePickerFor(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true)
    }
    
    // MARK: - Selector
    @objc func handleSelectPhoto() {
        showImageUploadOptions { [weak self] in
            self?.presentImagePickerFor(source: .photoLibrary)
        } cameraAction: { [weak self] in
            self?.presentImagePickerFor(source: .camera)
        }
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
    
    @objc func handleGenderSelected(button: UIButton) {
        registerVM.gender = button == maleButton ? .male : .female
        maleButton.tintColor = registerVM.genderSelectionColor.maleColor
        femaleButton.tintColor = registerVM.genderSelectionColor.femaleColor
        updateRegisterButtonStatus()
    }
    
    @objc func handleTextfieldChanged(textfield: UITextField) {
        if textfield == nameTextField {
            registerVM.fullName = textfield.text ?? ""
        } else if textfield == emailTextField {
            registerVM.email = textfield.text ?? ""
        } else {
            registerVM.password = textfield.text ?? ""
        }
            
        updateRegisterButtonStatus()
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
