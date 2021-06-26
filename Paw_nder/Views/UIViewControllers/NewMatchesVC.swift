//
//  NewMatchesVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/8/21.
//

import UIKit
import Firebase

protocol NewMatchesVCDelegate: AnyObject {
    func didPressMatchedUser(match: Match)
}

class NewMatchesVC: UIViewController {
    // MARK: - Properties
    var matches = [Match]()
    
    weak var delegate: NewMatchesVCDelegate?
    
    // MARK: - Views
    private let titleLabel = PawLabel(text: "New Matches", textColor: .black, font: .systemFont(ofSize: 16, weight: .bold), alignment: .left)
    private let noMatchesLabel = PawLabel(text: "No New Matches", textColor: .black, font: .systemFont(ofSize: 14, weight: .medium), alignment: .center)
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(NewMatchMessageCell.self, forCellWithReuseIdentifier: NewMatchMessageCell.reuseId)
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = Colors.bgLightGray
        return cv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        setupNotificationObservers()
        fetchMatches()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Helpers
    private func layoutUI() {
        view.addSubviews(titleLabel, collectionView, noMatchesLabel)
        titleLabel.anchor(top: view.topAnchor, trailing: view.trailingAnchor, leading: view.leadingAnchor, paddingTrailing: 25, paddingLeading: 25)
        titleLabel.setDimension(hConst: 15)
        
        collectionView.anchor(top: titleLabel.bottomAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, paddingTop: 15)
        
        noMatchesLabel.center(x: view.centerXAnchor, y: view.centerYAnchor, yPadding: -15)
    }
    
    private func fetchMatches() {
        guard Auth.auth().currentUser != nil else { return }
        
        FirebaseManager.shared.fetchMatches { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .success(let matches):
                    DispatchQueue.main.async {
                        self.matches = matches.filter({ $0.startedConversation == false })
                        self.noMatchesLabel.isHidden = !self.matches.isEmpty
                        self.titleLabel.isHidden = self.matches.isEmpty
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
extension NewMatchesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewMatchMessageCell.reuseId, for: indexPath) as! NewMatchMessageCell
        cell.setupWith(userMatch: matches[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = view.frame.height * 0.7
        return .init(width: side, height: side)
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
