//
//  MessageInputView.swift
//  Paw_nder
//
//  Created by William Yeung on 5/10/21.
//

import UIKit

protocol MessageInputViewDelegate: AnyObject {
    func didBeginEditing()
    func didPressSend(text: String)
}

class MessageInputView: UIView {
    // MARK: - Properties
    var inputTextViewBottomAnchor: NSLayoutConstraint?
    weak var delegate: MessageInputViewDelegate?
    
    // MARK: - Views
    private let placeHolderLabel = PawLabel(text: "Type your message...", textColor: .lightGray, font: .systemFont(ofSize: 16, weight: .medium))
    private let inputTextView = PawTextView(placeholder: "", textColor: .black, bgColor: .clear)
    private let sendButton = PawButton(image: SFSymbols.paperplane, tintColor: lightRed, font: .systemFont(ofSize: 14, weight: .bold))
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        layoutUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helpers
    func configureUI() {
        backgroundColor = .white
        inputTextView.isScrollEnabled = false
        inputTextView.delegate = self
        inputTextView.font = .systemFont(ofSize: 16, weight: .medium)
        inputTextView.layer.cornerRadius = 18
        inputTextView.textContainerInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        inputTextView.layer.borderWidth = 1
        inputTextView.layer.borderColor = lightGray.cgColor
        addBorderTo(side: .top, bgColor: lightGray, dimension: 1)
    }
    
    func layoutUI() {
        addSubviews(inputTextView, placeHolderLabel, sendButton)
        
        sendButton.anchor(trailing: trailingAnchor, bottom: inputTextView.bottomAnchor, paddingTrailing: 15)
        sendButton.setDimension(wConst: 35, hConst: 35)
        
        inputTextView.anchor(top: topAnchor, trailing: sendButton.leadingAnchor, leading: leadingAnchor, paddingTop: 10, paddingTrailing: 10, paddingLeading: 15)
        inputTextViewBottomAnchor = inputTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30)
        inputTextViewBottomAnchor?.isActive = true
        
        placeHolderLabel.anchor(top: inputTextView.topAnchor, trailing: inputTextView.trailingAnchor, bottom: inputTextView.bottomAnchor, leading: inputTextView.leadingAnchor, paddingLeading: 13)
    }
    
    func setupActions() {
        sendButton.addTarget(self, action: #selector(handleSendPressed), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    @objc func handleSendPressed() {
        guard let message = inputTextView.text, !message.isEmpty else { return }
        inputTextView.text = ""
        placeHolderLabel.isHidden = false
        delegate?.didPressSend(text: message)
    }
}

// MARK: - UITextViewDelegate
extension MessageInputView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        inputTextViewBottomAnchor?.constant = -10
        delegate?.didBeginEditing()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        inputTextViewBottomAnchor?.constant = -30
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let estimatedSize = textView.sizeThatFits(.init(width: frame.width, height: .infinity))
        
        inputTextView.constraints.forEach { constraints in
            if constraints.firstAttribute == .height {
                constraints.constant = estimatedSize.height
                
            }
        }
        
        placeHolderLabel.isHidden = !textView.text.isEmpty
    }
}