//
//  NewMatchesVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/8/21.
//

import UIKit
import Firebase

class NewMatchesView: UIView {
    // MARK: - Properties
    var matches = [Match]()
    
    // MARK: - Views
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(NewMatchMessageCell.self, forCellWithReuseIdentifier: NewMatchMessageCell.reuseId)
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .gray
        return cv
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        layoutUI()
        #warning("Need to find a way to call this again if user logs out and then logs in")
        fetchMatches()
        setupNotificationObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helpers
    private func configureUI() {

    }
    
    private func layoutUI() {
        addSubviews(collectionView)
        collectionView.fill(superView: self)
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
                    print(error.localizedDescription)
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
        return .init(width: frame.height, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -10
    }
}
