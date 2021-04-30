//
//  SettingsVC.swift
//  Paw_nder
//
//  Created by William Yeung on 4/24/21.
//

import UIKit
import Firebase

protocol SettingsVCDelegate: AnyObject {
    func updateCardDeck()
}

class SettingsVC: LoadingViewController {
    // MARK: - Properties
    var imagePickerButtonTag: Int?
    var settingsVM = SettingsViewModel.shared
    weak var delegate: SettingsVCDelegate?
    
    // MARK: - Views
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.delegate = self
        tv.dataSource = self
        tv.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.reuseId)
        tv.register(SliderCell.self, forCellReuseIdentifier: SliderCell.reuseId)
        tv.backgroundColor = #colorLiteral(red: 0.9541934133, green: 0.9496539235, blue: 0.9577021003, alpha: 1)
        tv.tableFooterView = UIView()
        tv.keyboardDismissMode = .interactive
        tv.allowsSelection = false
        return tv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        configureNavbar()
        configureUI()
        fetchCurrentUserInfo()
        setupKeyboardObserver()
        setupImagePickerNotificationObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.navigationBar.sizeToFit()
        }
    }

    // MARK: - Helpers
    func configureNavbar(){
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDoneTapped))
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSaveTapped))
        navigationItem.leftBarButtonItem = doneButton
        navigationItem.rightBarButtonItem = saveButton
    }
    
    func configureUI() {
        
    }
    
    func layoutUI() {
        view.addSubview(tableView)
        tableView.fill(superView: view)
    }
    
    func fetchCurrentUserInfo() {
        FirebaseManager.shared.fetchCurrentUser { [weak self] (result) in
            switch result {
            case .success(let user):
                self?.settingsVM.user = user
                self?.tableView.reloadData()
            case .failure(let error):
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    func setupKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupImagePickerNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleSelectPhotoTapped(notification:)), name: .didOpenImagePicker, object: nil)
    }
    
    func handleUpdateCompletion(error: Error?) {
        if let error = error {
           showAlert(title: "Error", message: error.localizedDescription)
        }
        
        dismissLoader()
        dismiss(animated: true) { self.delegate?.updateCardDeck() }
    }
    
    // MARK: - Selectors
    @objc func handleDoneTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSaveTapped() {
        showLoader()
        
        if settingsVM.selectedImages.count == 0 {
            settingsVM.updateUserInfo { [weak self] error in
                self?.handleUpdateCompletion(error: error)
            }
        } else {
            settingsVM.updateUserInfoWithImages { [weak self] error in
                self?.handleUpdateCompletion(error: error)
            }
        }
    }
    
    @objc func handleLogoutTapped() {
        settingsVM.logoutUser { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleSelectPhotoTapped(notification: Notification) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePickerButtonTag = notification.userInfo?[buttonTag] as? Int
        present(imagePicker, animated: true)
    }
    
    @objc func handleKeyboardShow(notification: Notification) {
        if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height - UIApplication.shared.windows[0].safeAreaInsets.bottom
            tableView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
            tableView.scrollIndicatorInsets = .init(top: 0, left: 0, bottom: height, right: 0)
        }
    }
    
    @objc func handleKeyboardHide() {
        tableView.contentInset = .zero
        tableView.scrollIndicatorInsets = .zero
    }
    
    @objc func handleNameTextfieldChanged(textField: UITextField) {
        settingsVM.user?.name = textField.text ?? ""
    }
    
    @objc func handleBreedTextfieldChanged(textField: UITextField) {
        settingsVM.user?.breed = textField.text ?? ""
    }
    
    @objc func handleAgeTextfieldChanged(textField: UITextField) {
        settingsVM.user?.age = Int(textField.text ?? "") ?? 0
    }
    
    @objc func handleBioTextfieldChanged(textField: UITextField) {
        settingsVM.user?.bio = textField.text ?? ""
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let imagePickerHeaderView = ImagePickerHeaderView()
            imagePickerHeaderView.setCurrentUserImage(urlStringsDictionary: settingsVM.user?.imageUrls)
            return imagePickerHeaderView
        } else if 1...5 ~= section {
            let headerLabel = PaddedLabel(text: "", font: .systemFont(ofSize: 16, weight: .bold))
            switch section {
                case 1:
                    headerLabel.text = "Name"
                case 2:
                    headerLabel.text = "Breed"
                case 3:
                    headerLabel.text = "Age"
                case 4:
                    headerLabel.text = "Bio"
                default:
                    headerLabel.text = "Preferred Age Range"
            }
            return headerLabel
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300
        }
        
        return 40
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if 0...4 ~= indexPath.section {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseId, for: indexPath) as! SettingsCell
            switch indexPath.section {
                case 1:
                    cell.setTextfield(text: settingsVM.user?.name, ph: "Enter Name")
                    cell.textfield.addTarget(self, action: #selector(handleNameTextfieldChanged(textField:)), for: .editingChanged)
                case 2:
                    cell.setTextfield(text: settingsVM.user?.breed, ph: "Enter Breed")
                    cell.textfield.addTarget(self, action: #selector(handleBreedTextfieldChanged(textField:)), for: .editingChanged)
                case 3:
                    cell.setTextfield(text: "\(settingsVM.user?.age ?? 0)", ph: "Enter Age")
                    cell.textfield.addTarget(self, action: #selector(handleAgeTextfieldChanged(textField:)), for: .editingChanged)
                default:
                    cell.setTextfield(text: "\(settingsVM.user?.bio ?? "")", ph: "Enter Bio")
                    cell.textfield.addTarget(self, action: #selector(handleBioTextfieldChanged(textField:)), for: .editingChanged)
            }
            return cell
        } else if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SliderCell.reuseId, for: indexPath) as! SliderCell
            cell.setSliderValues()
            return cell
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            let logoutButton = PawButton(title: "Logout", textColor: .white, font: .systemFont(ofSize: 16, weight: .bold))
            logoutButton.backgroundColor = lightRed
            cell.contentView.addSubview(logoutButton)
            logoutButton.fill(superView: cell)
            logoutButton.addTarget(self, action: #selector(handleLogoutTapped), for: .touchUpInside)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 5 {
            return 90
        } else {
            return UITableView.automaticDimension
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension SettingsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        settingsVM.selectedImages[imagePickerButtonTag!] = selectedImage
        NotificationCenter.default.post(Notification(name: .didSelectPhoto, object: nil, userInfo: [imagePickerButtonTag: selectedImage]))
        dismiss(animated: true, completion: nil)
    }
}
