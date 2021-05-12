//
//  UserMessageVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/11/21.
//

import UIKit
import Firebase

class RecentMessagesVC: UIViewController {
    // MARK: - Properties
    var searchBarStackTrailingAnchor: NSLayoutConstraint!
    var recentMessages: [RecentMessage] = []
    
    // MARK: - Views
    private let cancelButton = PawButton(title: "Cancel", font: .systemFont(ofSize: 16, weight: .medium))
    private let searchBar = UISearchBar()
    private lazy var searchBarStack = PawStackView(views: [searchBar, cancelButton], distribution: .fill, alignment: .fill)
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(RecentMessageCell.self, forCellReuseIdentifier: RecentMessageCell.reuseId)
        tv.backgroundColor = bgLightGray
        tv.separatorInset = .init(top: 0, left: 28, bottom: 0, right: 30)
        tv.rowHeight = 90
        return tv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
        setupActions()
        fetchRecentMessages()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        searchBar.delegate = self
        searchBar.placeholder = "Search"
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
    
    private func setupActions() {
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
    
    #warning("Refactor this!")
    var recentMessagesDictionary = [String: RecentMessage]()
    
    private func fetchRecentMessages() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("matches_messages").document(currentUserId).collection("recent_messages").addSnapshotListener { [weak self] snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            snapshot?.documentChanges.forEach({ change in
                if change.type == .added || change.type == .modified {
                    let data = change.document.data()
                    let recentMessage = RecentMessage(dictionary: data)
                    self?.recentMessagesDictionary[recentMessage.otherUserId] = recentMessage
                }
            })

            self?.setRecentMessages()
        }
    }
    
    private func setRecentMessages() {
        let values = Array(recentMessagesDictionary.values)
        recentMessages = values.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
        tableView.reloadData()
    }
    
    // MARK: - Selector
    @objc func handleCancelPressed() {
        view.endEditing(true)
        showCancelButton(false)
    }
}

// MARK: - UISearchBarDelegate
extension RecentMessagesVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        showCancelButton(true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension RecentMessagesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentMessageCell.reuseId, for: indexPath) as! RecentMessageCell
        cell.setupWith(recentMessage: recentMessages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
