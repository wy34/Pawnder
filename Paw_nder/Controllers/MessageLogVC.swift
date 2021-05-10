//
//  MessageLogVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/9/21.
//

import UIKit

class MessageLogVC: UICollectionViewController {
    // MARK: - Properties
    
    // MARK: - Views
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureCollectionView()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Helper
    func configureNavBar() {
        navigationItem.title = "Roxanne"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: SFSymbols.ellipsis, style: .plain, target: nil, action: nil)
    }
    
    func configureCollectionView() {
        collectionView.backgroundColor = bgLightGray
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    func configureUI() {
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MessageLogVC: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 50)
    }
}

