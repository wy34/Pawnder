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
        cv.backgroundColor = Colors.bgLightGray
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.rootTabBarController.showTabbar()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Helper
    private func configureNavBar() {
        navigationItem.title = match.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: SFSymbols.person, style: .plain, target: self, action: #selector(showUserProfile))
    }
    
    private func configureUI() {
        messageInputView.delegate = self
    }
    
    private func layoutUI() {
        view.addSubviews(messageInputView, collectionView)
        messageInputView.anchor(trailing: view.trailingAnchor, leading: view.leadingAnchor)
        messagesInputViewBottomAnchor = messageInputView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        messagesInputViewBottomAnchor?.isActive = true
        collectionView.anchor(top: view.topAnchor, trailing: view.trailingAnchor, bottom: messageInputView.topAnchor, leading: view.leadingAnchor)
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKBWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKBWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipe.direction = .down
        swipe.delegate = self
        view.addGestureRecognizer(swipe)
    }
    
    private func fetchMessages() {
        FirebaseManager.shared.fetchMessages(match: match) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let messages):
                    DispatchQueue.main.async {
                        self.messages = messages
                        self.collectionView.reloadData()
                        self.collectionView.scrollToItem(at: IndexPath(item: self.messages.count - 1, section: 0), at: .bottom, animated: true)
                        self.markMessageAsRead()
                    }
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    private func markMessageAsRead() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection(Firebase.matches_messages).document(currentUserId).collection(Firebase.recentMessages).document(self.match.matchedUserId).updateData(["isRead": true])
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
    
    @objc func showUserProfile() {
        let cardVM = CardViewModel(user: match.matchedUser)
        let aboutVM = AboutViewModel(cardViewModel: cardVM)
        let aboutVC = AboutVC()
        aboutVC.aboutVM = aboutVM
        aboutVC.hideLikeDislikeButtons = true
        aboutVC.modalPresentationStyle = .fullScreen
        present(aboutVC, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MessageLogVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageBubbleCell.reuseId, for: indexPath) as! MessageBubbleCell
        cell.setupWith(match: match, message: messages[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dummyCell = MessageBubbleCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
        dummyCell.setupWith(match: match, message: messages[indexPath.item])
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
        FirebaseManager.shared.addMessage(text: text, match: match) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
            
            self.collectionView.scrollToItem(at: IndexPath(item: self.messages.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    func didBeginEditing() {
        collectionView.scrollToItem(at: IndexPath(item: messages.count - 1, section: 0), at: .bottom, animated: true)
    }
}
