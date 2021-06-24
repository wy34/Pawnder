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
    var homeVC: HomeVC?
    
    // MARK: - Views
    private let iconImageView = PawImageView(image: Assets.icon, contentMode: .scaleAspectFit)
    private let titleLabel = PawLabel(text: "0 user(s) has liked you", textColor: .black, font: .systemFont(ofSize: 14, weight: .medium), alignment: .center)
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(LikeCell.self, forCellWithReuseIdentifier: LikeCell.reuseId)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = Colors.bgLightGray
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    private let infoButton = PawButton(image: SFSymbols.infoNoCircle, tintColor: .white, font: .systemFont(ofSize: 12))
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
        setupActionsAndObservers()
        fetchUsersWhoLikedMe()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        infoButton.backgroundColor = Colors.lightTransparentGray
        infoButton.layer.cornerRadius = 25 / 2
    }
    
    private func layoutUI() {
//        edgesForExtendedLayout = []
        view.addSubviews(iconImageView, titleLabel, collectionView, infoButton)
        iconImageView.center(to: view, by: .centerX)
        iconImageView.center(to: view, by: .centerY, withMultiplierOf: 0.1875)
        iconImageView.setDimension(wConst: 45, hConst: 45)
        titleLabel.anchor(top: iconImageView.bottomAnchor, trailing: view.trailingAnchor, leading: view.leadingAnchor, paddingTop: 25)
        collectionView.anchor(top: titleLabel.bottomAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, paddingTop: 15)
        infoButton.anchor(trailing: view.trailingAnchor, bottom: view.bottomAnchor, paddingTrailing: 18, paddingBottom: 18)
        infoButton.setDimension(wConst: 25, hConst: 25)
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
    
    private func setupActionsAndObservers() {
        infoButton.addTarget(self, action: #selector(showInfoAlert), for: .touchUpInside)
    }
    
    private func setupAndPresentAboutVC(withIndex index: Int) {
        let selectedUser = users[index]
        let selectedUserCardVM = CardViewModel(user: selectedUser)
        let selectedUserAboutVM = AboutViewModel(cardViewModel: selectedUserCardVM)
        let aboutVC = AboutVC()
        aboutVC.homeVC = homeVC
        aboutVC.aboutVM = selectedUserAboutVM
        aboutVC.modalPresentationStyle = .fullScreen
        present(aboutVC, animated: true, completion: nil)
    }
    
    // MARK: - Selectors
    @objc func showInfoAlert() {
        self.showAlert(title: "Heads Up", message: "If you are ever see user(s) appear and disappear from this list, its because they are undoing/redoing a swipe.")
    }
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
        setupAndPresentAboutVC(withIndex: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - cellSpacing.hSpacing - insetSpacing.right - insetSpacing.left) / 2
        let height = view.frame.height / 3.5
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
