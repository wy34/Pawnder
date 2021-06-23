//
//  LikesVC.swift
//  Paw_nder
//
//  Created by William Yeung on 6/18/21.
//

import UIKit
import Firebase

class LikesVC: UIViewController {
    // MARK: - Properties
    let likesVM = LikesViewModel()
    var users = [User]()
    
    // MARK: - Views
    private let iconImageView = PawImageView(image: icon, contentMode: .scaleAspectFit)
    private let titleLabel = PawLabel(text: "0 user(s) has liked you", textColor: .black, font: .systemFont(ofSize: 18, weight: .medium), alignment: .center)
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(LikeCell.self, forCellWithReuseIdentifier: LikeCell.reuseId)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = bgLightGray
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
        fetchUsersWhoLikedMe()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        
    }
    
    private func layoutUI() {
        view.addSubviews(iconImageView, titleLabel, collectionView)
        iconImageView.center(to: view, by: .centerX)
        iconImageView.center(to: view, by: .centerY, withMultiplierOf: 0.1875)
        iconImageView.setDimension(wConst: 45, hConst: 45)
        titleLabel.anchor(top: iconImageView.bottomAnchor, trailing: view.trailingAnchor, leading: view.leadingAnchor, paddingTop: 25)
        collectionView.anchor(top: titleLabel.bottomAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, paddingTop: 15)
    }
    
    private func fetchUsersWhoLikedMe() {
        likesVM.fetchUsersWhoLikedMe(addedCompletion: { result in
            switch result {
                case .success(let users):
                    DispatchQueue.main.async {
                        self.users += users
                        self.collectionView.reloadData()
                        self.updateTitleLabel()
                    }
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }, removedCompletion: { userToRemove in
            guard let userToRemove = userToRemove else { return }
            if let userToRemoveIndex = self.users.firstIndex(where: { $0 == userToRemove }) {
                self.users.remove(at: userToRemoveIndex)
                self.collectionView.reloadData()
                self.updateTitleLabel()
            }
        })
    }
    
    private func updateTitleLabel() {
        titleLabel.text = users.count == 0 ? "0 user(s) has liked you" : "\(users.count) user(s) has liked you"
    }
    
    // MARK: - Selectors
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension LikesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var cellSpacing: (hSpacing: CGFloat, vSpacing: CGFloat) {
        return (15, 15)
    }
    
    var insetSpacing: (top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        return (15, 15, 15, 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikeCell.reuseId, for: indexPath) as! LikeCell
        cell.setupCellWith(user: users[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let aboutVC = AboutVC()
        aboutVC.modalPresentationStyle = .fullScreen
        present(aboutVC, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - cellSpacing.hSpacing - insetSpacing.right - insetSpacing.left) / 2
        let height = view.frame.height / 4
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing.vSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing.hSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: insetSpacing.top, left: insetSpacing.left, bottom: insetSpacing.bottom, right: insetSpacing.right)
    }
}
