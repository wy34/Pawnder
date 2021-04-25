//
//  SettingsVC.swift
//  Paw_nder
//
//  Created by William Yeung on 4/24/21.
//

import UIKit

class SettingsVC: UIViewController {
    // MARK: - Properties
    var imagePickerButtonTag: Int?
    
    // MARK: - Views
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.reuseId)
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
    
    func setupImagePickerNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleSelectPhotoTapped(notification:)), name: .didOpenImagePicker, object: nil)
    }
    
    // MARK: - Selectors
    @objc func handleDoneTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSaveTapped() {
        
    }
    
    @objc func handleLogoutTapped() {

    }
    
    @objc func handleSelectPhotoTapped(notification: Notification) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePickerButtonTag = notification.userInfo?[buttonTag] as? Int
        present(imagePicker, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let imagePickerHeaderView = ImagePickerHeaderView()
            return imagePickerHeaderView
        } else if section == 5 {
            return nil
        } else {
            let headerLabel = PaddedLabel(text: "", font: .systemFont(ofSize: 16, weight: .bold))
            switch section {
                case 1:
                    headerLabel.text = "Name"
                case 2:
                    headerLabel.text = "Breed"
                case 3:
                    headerLabel.text = "Age"
                default:
                    headerLabel.text = "Bio"
            }
            return headerLabel
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300
        }
        return 40
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section != 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseId, for: indexPath) as! SettingsCell
            switch indexPath.section {
                case 1:
                    cell.setPlaceholder("Enter Name")
                case 2:
                    cell.setPlaceholder("Enter Breed")
                case 3:
                    cell.setPlaceholder("Enter Age")
                default:
                    cell.setPlaceholder("Enter Bio")
            }
            return cell
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            let logoutButton = PawButton(title: "Logout", textColor: .white, font: .systemFont(ofSize: 16, weight: .bold))
            logoutButton.backgroundColor = lightRed
            cell.contentView.addSubview(logoutButton)
            logoutButton.fill(superView: cell)
            return cell
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension SettingsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        NotificationCenter.default.post(Notification(name: .didSelectPhoto, object: nil, userInfo: [imagePickerButtonTag: selectedImage]))
        dismiss(animated: true, completion: nil)
    }
}
