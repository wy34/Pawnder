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
        
        fetchUsersWhoLikedMe { result in
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
        }
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
    
    #warning("What to do if someone likes me, but i dislike them. Currently, they will still be showing up in my likes page")
    func fetchUsersWhoLikedMe(completion: @escaping (Result<[User], Error>) -> Void) {
        let currentUserId = Auth.auth().currentUser!.uid
        var users = [User]()
        
        Firestore.firestore().collection("usersWhoLikedMe").document(currentUserId).collection("users").addSnapshotListener { snapshot, error in
            if let error = error { print(error.localizedDescription); return }
            users.removeAll()
            
            snapshot?.documentChanges.forEach({ change in
                let user = User(dictionary: change.document.data())
                
                if change.type == .added {
                    self.checkIfAlreadyMatch(currentUserId: currentUserId, otherUserId: user.uid) { match in
                        if !match {
                            users.append(user)
                            completion(.success(users))
                        }
                    }
                } else if change.type == .removed {
                    if let userToRemoveIndex = self.users.firstIndex(where: { $0 == user }) {
                        self.users.remove(at: userToRemoveIndex)
                        self.collectionView.reloadData()
                        self.updateTitleLabel()
                    }
                }
            })
        }
    }
    
    func checkIfAlreadyMatch(currentUserId: String, otherUserId: String, completion: @escaping (Bool) -> Void) {
        Firestore.firestore().collection(fsMatches_Messages).document(currentUserId).collection(fsMatches).document(otherUserId).getDocument { snapshot, error in
            if let snapshot = snapshot {
                if snapshot.exists {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    private func updateTitleLabel() {
        if users.count == 0 {
            titleLabel.text = "0 user(s) has liked you"
        } else {
            titleLabel.text = "\(users.count) user(s) has liked you"
        }
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
