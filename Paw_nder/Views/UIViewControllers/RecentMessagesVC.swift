//
//  UserMessageVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/11/21.
//

import UIKit
import Firebase

protocol RecentMessagesVCDelegate: AnyObject {
    func handleRowTapped(match: Match)
}

class RecentMessagesVC: UIViewController {
    // MARK: - Properties
    var searchBarStackTrailingAnchor: NSLayoutConstraint!
    var recentMessages: [RecentMessage] = []
    weak var delegate: RecentMessagesVCDelegate?
    
    var isSearching = false
    var searchedMessages = [RecentMessage]()
    
    // MARK: - Views
    private let cancelButton = PawButton(title: "Cancel", font: .systemFont(ofSize: 16, weight: .medium))
    private let searchBar = UISearchBar()
    private lazy var searchBarStack = PawStackView(views: [searchBar, cancelButton], distribution: .fill, alignment: .fill)
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(RecentMessageCell.self, forCellReuseIdentifier: RecentMessageCell.reuseId)
        tv.backgroundColor = Colors.bgLightGray
        tv.separatorInset = .init(top: 0, left: 28, bottom: 0, right: 30)
        tv.rowHeight = 90
        tv.tableFooterView = UIView()
        return tv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
        setupActionsAndObservers()
        fetchRecentMessages()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Helpers
    private func configureUI() {
        searchBar.delegate = self
        searchBar.placeholder = "Search User"
        searchBar.backgroundImage = UIImage()
        cancelButton.alpha = 0
        view.layer.shadowOpacity = 0.15
        view.layer.shadowRadius = 15
        
        let tabbarHeight = UIApplication.rootTabBarController.tabBar.bounds.height
        tableView.contentInset = .init(top: 0, left: 0, bottom: tabbarHeight, right: 0)
        tableView.scrollIndicatorInsets = .init(top: 0, left: 0, bottom: tabbarHeight, right: 0)
    }
    
    private func layoutUI() {
        view.addSubviews(searchBarStack, tableView)
        
        searchBarStack.center(to: view, by: .centerX)
        searchBarStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, paddingTop: 15, paddingLeading: 20)
        searchBarStackTrailingAnchor = searchBarStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 55)
        searchBarStackTrailingAnchor.isActive = true
        cancelButton.setDimension(wConst: 75)
        
        tableView.anchor(top: searchBarStack.bottomAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor)
    }
    
    private func setupActionsAndObservers() {
        cancelButton.addTarget(self, action: #selector(handleCancelPressed), for: .touchUpInside)
    }
    
    private func showCancelButton(_ show: Bool) {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.cancelButton.alpha = show ? 1 : 0
            self.searchBarStackTrailingAnchor.isActive = false
            self.searchBarStackTrailingAnchor = self.searchBarStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: show ? -20 : 55)
            self.searchBarStackTrailingAnchor.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
    private func fetchRecentMessages() {
        FirebaseManager.shared.fetchRecentMessages { [weak self] result in
            switch result {
                case .success(let recentMsgs):
                    DispatchQueue.main.async {
                        self?.recentMessages = recentMsgs
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Selector
    @objc func handleCancelPressed() {
        view.endEditing(true)
        searchBar.text = nil
        showCancelButton(false)
        
        if isSearching {
            isSearching = false
            searchedMessages = []
            tableView.reloadData()
        }
    }
}

// MARK: - UISearchBarDelegate
extension RecentMessagesVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        showCancelButton(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchResults = recentMessages.filter({ $0.name.lowercased().contains(searchText.lowercased()) })
        
        if searchText != "" {
            isSearching = true
            searchedMessages = searchResults
        } else {
            isSearching = false
            searchedMessages = []
        }
        
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension RecentMessagesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? searchedMessages.count : recentMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentMessageCell.reuseId, for: indexPath) as! RecentMessageCell
        cell.setupWith(recentMessage: isSearching ? searchedMessages[indexPath.row] : recentMessages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        view.endEditing(true)
        delegate?.handleRowTapped(match: Match(recentMessage: isSearching ? searchedMessages[indexPath.row] : recentMessages[indexPath.row]))
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = PawLabel(text: "No New Messages", textColor: .black, font: .systemFont(ofSize: 14, weight: .medium), alignment: .center)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return recentMessages.isEmpty && searchedMessages.isEmpty ? view.frame.size.height * 0.6 / 2 : 0
    }
}
