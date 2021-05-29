//
//  MessageBubbleCell.swift
//  Paw_nder
//
//  Created by William Yeung on 5/10/21.
//

import UIKit
import Firebase

class MessageBubbleCell: UICollectionViewCell {
    // MARK: - Properties
    static let reuseId = "MessageBubbleCell"
    
    var bubbleContainerViewLeadingAnchor: NSLayoutConstraint?
    var bubbleContainerViewTrailingAnchor: NSLayoutConstraint?
    var timestampLabelLeadingAnchor: NSLayoutConstraint?
    var timestampLabelTrailingAnchor: NSLayoutConstraint?
    
    // MARK: - Views
    private let bubbleContainerView = PawView(bgColor: .clear, cornerRadius: 20)
    private let messageTextView = PawTextView(placeholder: "Placeholder", textColor: .white, bgColor: .clear)
    private let timestampLabel = PawLabel(text: "3:07 PM", textColor: .gray, font: .systemFont(ofSize: 10), alignment: .center)
    private let profileImageView = PawImageView(image: UIImage(named: bob2)!, contentMode: .scaleAspectFill)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 35/2
        
        messageTextView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        messageTextView.isEditable = false
        messageTextView.isScrollEnabled = false
    }
    
    private func layoutUI() {
        addSubviews(profileImageView, bubbleContainerView)
        
        profileImageView.setDimension(wConst: 35, hConst: 35)
        profileImageView.anchor(bottom: bottomAnchor, leading: leadingAnchor, paddingBottom: 10, paddingLeading: 20)
        
        bubbleContainerView.anchor(top: topAnchor, bottom: profileImageView.bottomAnchor, paddingTop: 10, paddingBottom: 15)
        bubbleContainerView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.75).isActive = true
        bubbleContainerViewLeadingAnchor = bubbleContainerView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10)
        bubbleContainerViewTrailingAnchor = bubbleContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        
        bubbleContainerView.addSubviews(timestampLabel, messageTextView)
        
        timestampLabel.anchor(top: bubbleContainerView.bottomAnchor, bottom: profileImageView.bottomAnchor, paddingTop: 3)
        timestampLabelLeadingAnchor = timestampLabel.leadingAnchor.constraint(equalTo: bubbleContainerView.leadingAnchor)
        timestampLabelTrailingAnchor = timestampLabel.trailingAnchor.constraint(equalTo: bubbleContainerView.trailingAnchor)
        
        messageTextView.fill(superView: bubbleContainerView, withPaddingOnAllSides: 8)
    }
    
    private func setupBasedOn(isCurrentUser: Bool) {
        bubbleContainerView.backgroundColor = isCurrentUser ? lightRed : lightGray
        messageTextView.textColor = isCurrentUser ? .white : .black
        
        profileImageView.isHidden = isCurrentUser ? true : false
        bubbleContainerViewLeadingAnchor?.isActive = isCurrentUser ? false : true
        bubbleContainerViewTrailingAnchor?.isActive = isCurrentUser ? true : false
        timestampLabelLeadingAnchor?.isActive = isCurrentUser ? false : true
        timestampLabelTrailingAnchor?.isActive = isCurrentUser ? true : false
        
        bubbleContainerView.layer.maskedCorners = isCurrentUser ? [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner] : [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    func setupWith(match: Match?, message: Message?) {
        guard let message = message, let match = match else { return }
        messageTextView.text = message.text
        setupBasedOn(isCurrentUser: message.isCurrentUser)
        timestampLabel.text = message.timestamp.dateValue().stringValue(format: "M/dd/yy, h:mm a")
        profileImageView.setImage(imageUrlString: match.imageUrlString, completion: nil)
    }
}
