//
//  NewSettingsVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/16/21.
//

import UIKit

class NewSettingsVC: UIViewController {
    // MARK: - Properties
    let settings = [
        Setting(name: "Name", preview: "God", emoji: "👤"),
        Setting(name: "Breed", preview: "Golden Retriever", emoji: "🐶"),
        Setting(name: "Age", preview: "34", emoji: "💯"),
        Setting(name: "Gender", preview: "Male", emoji: "👫"),
        Setting(name: "Location", preview: "Los Angeles", emoji: "📍"),
        Setting(name: "Bio", preview: "Golden Retriever Golden Retriever Golden Retriever Golden Retriever Golden Retriever Golden Retriever", emoji: "🧬")
    ]
    
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
    
    // MARK: - Selector
    @objc func handleSaveSettings() {
        
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension NewSettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewSettingsCell.reuseId, for: indexPath) as! NewSettingsCell
        cell.configureWith(setting: settings[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editSettingsVC = EditSettingsVC()
        navigationItem.backButtonTitle = ""
        editSettingsVC.configureWith(setting: settings[indexPath.row])
        navigationController?.pushViewController(editSettingsVC, animated: true)
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
