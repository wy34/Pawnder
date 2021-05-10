//
//  MessageLogVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/9/21.
//

import UIKit

class MessageLogVC: UICollectionViewController {
    // MARK: - Properties
    var messages = [Message(senderId: "YH1Z1YgTh4SUt5lyPjSNIG1gMpH2", text: "Hi, how are you?"), Message(senderId: "Pd7GRuZdKcd3WYwiU2w8YoijHmI3", text: "I am well, how are you?"), Message(senderId: "YH1Z1YgTh4SUt5lyPjSNIG1gMpH2", text: "Do you want to get lunch tomorrow? Do you want to get lunch tomorrow? Do you want to get lunch tomorrow? Do you want to get lunch tomorrow? Do you want to get lunch tomorrow? Do you want to get lunch tomorrow? Do you want to get lunch tomorrow? Do you want to get lunch tomorrow? Do you want to get lunch tomorrow? Do you want to get lunch tomorrow? Do you want to get lunch tomorrow? Do you want to get lunch tomorrow? Do you want to get lunch tomorrow? Do you want to get lunch tomorrow? Do you want to get lunch tomorrow? Do you want to get lunch tomorrow? Do you want to get lunch tomorrow? Do you want to get lunch tomorrow?")]
    
    // MARK: - Views
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureCollectionView()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.rootTabBarController.hideTabbar()
    }
    
    // MARK: - Helper
    func configureNavBar() {
        navigationItem.title = "Roxanne"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: SFSymbols.ellipsis, style: .plain, target: nil, action: nil)
    }
    
    func configureCollectionView() {
        collectionView.backgroundColor = bgLightGray
        collectionView.register(MessageBubbleCell.self, forCellWithReuseIdentifier: MessageBubbleCell.reuseId)
    }
    
    func configureUI() {
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MessageLogVC: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageBubbleCell.reuseId, for: indexPath) as! MessageBubbleCell
        cell.setupWith(message: messages[indexPath.item])
//        cell.backgroundColor = indexPath.item % 2 == 0 ? .green : .orange
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dummyCell = MessageBubbleCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
        dummyCell.setupWith(message: messages[indexPath.item])
        dummyCell.layoutIfNeeded()
        
        let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

