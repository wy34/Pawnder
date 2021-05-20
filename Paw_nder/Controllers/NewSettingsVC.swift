//
//  NewSettingsVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/16/21.
//

import UIKit

class NewSettingsVC: UIViewController {
    // MARK: - Properties
    let settingsVM = SettingsViewModel.shared
    
    // MARK: - Views
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.delegate = self
        tv.dataSource = self
        tv.register(NewSettingsCell.self, forCellReuseIdentifier: NewSettingsCell.reuseId)
        tv.backgroundColor = #colorLiteral(red: 0.9541934133, green: 0.9496539235, blue: 0.9577021003, alpha: 1)
        tv.tableFooterView = UIView()
        tv.automaticallyAdjustsScrollIndicatorInsets = true
        tv.rowHeight = 50
        return tv
    }()

    private let logoutButton = PawButton(title: "Log out", textColor: .white, bgColor: lightRed)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureUI()
        layoutUI()
        setupActionsAndObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - Helpers
    private func configureNavBar() {
        navigationItem.title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSaveSettings))
    }
    
    private func configureUI() {
        logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        logoutButton.layer.cornerRadius = 25
    }
    
    private func layoutUI() {
        view.addSubview(tableView)
        tableView.fill(superView: view)
    }
    
    private func setupActionsAndObservers() {
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
    }
    
    func updateNewSettingsPreview(settings: Setting) {
        let cell = tableView.cellForRow(at: IndexPath(row: settings.index, section: 0)) as! NewSettingsCell
        cell.configureWith(setting: settings)
        
        switch settings.title {
            case .name:
                settingsVM.user?.name = settings.preview ?? ""
            case .breed:
                settingsVM.user?.breed = settings.preview ?? ""
            case .age:
                settingsVM.user?.age = Int(settings.preview ?? "") ?? 0
            case .gender:
                settingsVM.user?.gender = Gender(rawValue: settings.preview ?? "") ?? .male
            case .bio:
                settingsVM.user?.bio = settings.preview ?? ""
            default:
                break
        }
    }
    
    // MARK: - Selector
    @objc func handleSaveSettings() {
        
    }
    
    @objc func handleLogout() {
        settingsVM.logoutUser {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                UIApplication.rootTabBarController.setupViewControllers()
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension NewSettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsVM.settingOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewSettingsCell.reuseId, for: indexPath) as! NewSettingsCell
        cell.configureWith(setting: settingsVM.settingOptions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc: EditSettingsRootVC
        
        switch indexPath.row {
            case 0, 1: vc = EditSettingsDefaultVC()
            case 2: vc = EditSettingsAgeVC()
            case 3: vc = EditSettingsGenderVC()
            case 4: vc = EditSettingsBioVC()
            default: vc = EditSettingsPreferenceVC()
        }
        
        vc.newSettingsVC = self
        vc.configureWith(setting: settingsVM.settingOptions[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
        navigationItem.backButtonTitle = ""
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let containerView = PawView(bgColor: .clear)
        containerView.addSubviews(logoutButton)
        logoutButton.center(to: containerView, by: .centerY)
        logoutButton.setDimension(width: containerView.widthAnchor, height: containerView.heightAnchor, hMult: 0.5)
        return containerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
}
