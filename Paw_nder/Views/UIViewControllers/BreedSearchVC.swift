//
//  BreedSearchVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/27/21.
//

import UIKit

class BreedSearchVC: LoadingViewController {
    // MARK: - Properties
    let networkManager = NetworkManager()
    var timer: Timer?
    
    var searchResults = [Breed]()
    
    // MARK: - Views
    private let searchController = UISearchController(searchResultsController: nil)
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.backgroundColor = bgLightGray
        tv.tableFooterView = UIView()
        tv.keyboardDismissMode = .interactive
        return tv
    }()
    
    private let searchingIndicator = UIActivityIndicatorView(style: .large)
    private let searchingLabel = PawLabel(text: "Searching", textColor: .black, font: .systemFont(ofSize: 16, weight: .medium), alignment: .center)
    private lazy var searchingStack = PawStackView(views: [searchingIndicator, searchingLabel], spacing: -125, axis: .vertical, distribution: .fillEqually)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        configureUI()
        layoutUI()
    }
    
    // MARK: - Helpers
    private func setupNavBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.placeholder = "🐶 Search Breed"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func configureUI() {
    }
    
    private func layoutUI() {
        view.addSubviews(tableView)
        tableView.fill(superView: view)
    }
    
    private func search(breedName: String) {
        networkManager.fetch(breedName: breedName) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let breeds):
                    DispatchQueue.main.async {
                        self.searchingIndicator.stopAnimating()

                        if breeds.count == 0 {
                            self.searchingLabel.text = "No results"
                        } else {
                            self.searchResults = breeds
                            self.tableView.reloadData()
                        }
                    }
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Selectors
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension BreedSearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return PawLabel(text: "No results, please enter a search query.", textColor: .black, font: .systemFont(ofSize: 16, weight: .medium), alignment: .center)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return searchResults.count == 0 && searchController.searchBar.text == "" ? 200 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = bgLightGray
        cell.textLabel?.text = searchResults[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return searchingStack
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return searchResults.count == 0 && searchController.searchBar.text != "" ? 205 : 0
    }
}

// MARK: - UISearchBarDelegate
extension BreedSearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchingLabel.text = "Searching..."
        searchingIndicator.startAnimating()
        searchResults.removeAll()
        tableView.reloadData()
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.75, repeats: false, block: { [weak self] _ in
            guard !searchText.isEmpty else { self?.searchingIndicator.stopAnimating(); return }
            self?.search(breedName: searchText)
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResults.removeAll()
        tableView.reloadData()
        timer?.invalidate()
    }
}
