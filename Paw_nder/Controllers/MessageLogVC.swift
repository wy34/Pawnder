//
//  MessageLogVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/9/21.
//

import UIKit
import Firebase

class MessageLogVC: UIViewController {
    // MARK: - Properties
    var messages = [Message]()
    
    var messagesInputViewBottomAnchor: NSLayoutConstraint?
    var match: Match!
    
    // MARK: - Views
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(MessageBubbleCell.self, forCellWithReuseIdentifier: MessageBubbleCell.reuseId)
        cv.backgroundColor = bgLightGray
        return cv
    }()
    
    private lazy var messageInputView = MessageInputView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureUI()
        layoutUI()
        setupObservers()
        fetchMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.rootTabBarController.hideTabbar()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Helper
    func configureNavBar() {
        navigationItem.title = match.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: SFSymbols.ellipsis, style: .plain, target: nil, action: nil)
    }
    
    func configureUI() {
        messageInputView.delegate = self
    }
    
    func layoutUI() {
        view.addSubviews(messageInputView, collectionView)
        messageInputView.anchor(trailing: view.trailingAnchor, leading: view.leadingAnchor)
        messagesInputViewBottomAnchor = messageInputView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        messagesInputViewBottomAnchor?.isActive = true
        collectionView.anchor(top: view.topAnchor, trailing: view.trailingAnchor, bottom: messageInputView.topAnchor, leading: view.leadingAnchor)
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKBWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKBWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipe.direction = .down
        swipe.delegate = self
        view.addGestureRecognizer(swipe)
    }
    
    #warning("Refactor!!!")
    func fetchMessages() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("matches_messages").document(currentUserId).collection(match.matchedUserId).order(by: "timestamp").addSnapshotListener { [weak self] snapshots, error in
            guard let self = self else { return }
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            snapshots?.documentChanges.forEach({ change in
                if change.type == .added {
                    let dictionary = change.document.data()
                    self.messages.append(.init(dictionary: dictionary))
                }
            })
            
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Selector
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func handleKBWillShow(notification: Notification) {
        if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let kbHeight = frame.cgRectValue.height
            messagesInputViewBottomAnchor?.constant = -kbHeight
            view.layoutIfNeeded()
        }
    }
    
    @objc func handleKBWillHide() {
        messagesInputViewBottomAnchor?.constant = 0
        view.layoutIfNeeded()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MessageLogVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageBubbleCell.reuseId, for: indexPath) as! MessageBubbleCell
        cell.setupWith(message: messages[indexPath.item])
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

// MARK: - UIGestureRecognizerDelegate
extension MessageLogVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - MessageInputViewDelegate
extension MessageLogVC: MessageInputViewDelegate {
    func didPressSend(text: String) {
        #warning("Refactor!!!")
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let data: [String: Any] = ["text": text, "fromId": currentUserId, "toId": match.matchedUserId, "timestamp": Timestamp(date: Date())]
        
        Firestore.firestore().collection("matches_messages").document(currentUserId).collection(match.matchedUserId).document().setData(data) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self.collectionView.scrollToItem(at: IndexPath(item: self.messages.count - 1, section: 0), at: .bottom, animated: true)
        }
        
        Firestore.firestore().collection("matches_messages").document(match.matchedUserId).collection(currentUserId).document().setData(data) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self.collectionView.scrollToItem(at: IndexPath(item: self.messages.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    func didBeginEditing() {
        collectionView.scrollToItem(at: IndexPath(item: messages.count - 1, section: 0), at: .bottom, animated: true)
    }
}
