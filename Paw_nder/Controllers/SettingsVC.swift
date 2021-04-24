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
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.tableFooterView = UIView()
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
        navigationItem.leftBarButtonItem = doneButton
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let imagePickerHeaderView = ImagePickerHeaderView()
        return imagePickerHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let logoutBtn = PawButton(title: "Logout", bgColor: lightGray)
        logoutBtn.addTarget(self, action: #selector(handleLogoutTapped), for: .touchUpInside)
        return logoutBtn
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
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
