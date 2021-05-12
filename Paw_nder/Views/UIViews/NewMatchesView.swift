//
//  NewMatchesVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/8/21.
//

import UIKit
import Firebase

protocol NewMatchesViewDelegate: AnyObject {
    func didPressMatchedUser(match: Match)
}

class NewMatchesView: UIViewController {
    // MARK: - Properties
    var matches = [Match]()
    
    weak var delegate: NewMatchesViewDelegate?
    
    // MARK: - Views
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(NewMatchMessageCell.self, forCellWithReuseIdentifier: NewMatchMessageCell.reuseId)
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = bgLightGray
        return cv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
        setupNotificationObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        #warning("don't want to put this here, instead find a way to do it when user logs in/out. Currently already refreshing when a new match is saved")
        fetchMatches()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Helpers
    private func configureUI() {

    }
    
    private func layoutUI() {
        view.addSubviews(collectionView)
        collectionView.fill(superView: view)
    }
    
    private func fetchMatches() {
        guard Auth.auth().currentUser != nil else { return }
        
        FirebaseManager.shared.fetchMatches { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .success(let matches):
                    DispatchQueue.main.async {
                        self.matches = matches
                        self.collectionView.reloadData()
                    }
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewMatchRefresh), name: .didFindMatch, object: nil)
    }
    
    // MARK: - Selector
    @objc func handleNewMatchRefresh() {
        fetchMatches()
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension NewMatchesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewMatchMessageCell.reuseId, for: indexPath) as! NewMatchMessageCell
        cell.setupWith(userMatch: matches[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.height, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didPressMatchedUser(match: matches[indexPath.item])
    }
}
