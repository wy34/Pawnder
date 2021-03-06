//
//  NewSettingsVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/16/21.
//

import UIKit

class SettingsVC: LoadingViewController {
    // MARK: - Properties
    let settingsVM = SettingsViewModel.shared
    
    // MARK: - Views
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.delegate = self
        tv.dataSource = self
        tv.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.reuseId)
        tv.backgroundColor = #colorLiteral(red: 0.9541934133, green: 0.9496539235, blue: 0.9577021003, alpha: 1)
        tv.tableFooterView = UIView()
        tv.automaticallyAdjustsScrollIndicatorInsets = true
        tv.rowHeight = 50
        return tv
    }()

    private let logoutButton = PawButton(title: "Log out", textColor: .white, bgColor: Colors.lightRed)
    private let logoutViewLauncher = LogoutViewLauncher()
    
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
    }
    
    private func configureUI() {
        logoutButton.titleLabel?.font = markerFont(20)
        logoutButton.layer.cornerRadius = 25
    }
    
    private func layoutUI() {
        edgesForExtendedLayout = []
        view.addSubview(tableView)
        tableView.fill(superView: view)
    }
    
    private func setupActionsAndObservers() {
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
    }
    
    // MARK: - Selector
    @objc func handleLogout() {
        logoutViewLauncher.delegate = self
        logoutViewLauncher.showLogoutView()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsVM.settingOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseId, for: indexPath) as! SettingsCell
        cell.configureWith(setting: settingsVM.settingOptions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc: EditSettingsRootVC
        
        switch indexPath.row {
            case 0: vc = EditSettingsNameVC()
            case 1: vc = EditSettingsBreedVC()
            case 2: vc = EditSettingsAgeVC()
            case 3: vc = EditSettingsGenderVC()
            case 4: vc = EditSettingsBioVC()
            case 5: vc = EditSettingsLocationVC()
            default: vc = EditSettingsPreferenceVC()
        }
        
        vc.settingsVC = self
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

// MARK: - LogoutViewLauncherDelegate
extension SettingsVC: LogoutViewLauncherDelegate {
    func didTapLogout() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            self?.settingsVM.logoutUser {
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    UIApplication.rootTabBarController.setupViewControllers()
                }
            }
        }
    }
}
