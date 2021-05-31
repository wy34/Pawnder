//
//  UserMessageCell.swift
//  Paw_nder
//
//  Created by William Yeung on 5/11/21.
//

import UIKit

class RecentMessageCell: UITableViewCell {
    // MARK: - Properties
    static let reuseId = "UserMessageCell"
    
    // MARK: - Views
    private let newMessageIndicator = PawView(bgColor: lightBlue, cornerRadius: 8/2)
    private let profileImageView = PawImageView(image: nil, contentMode: .scaleAspectFill)
    private let nameLabel = PawLabel(text: "", textColor: .black, font: .systemFont(ofSize: 16, weight: .bold), alignment: .left)
    private let msgPreviewLabel = PawLabel(text: "", textColor: .gray, font: .systemFont(ofSize: 14, weight: .medium), alignment: .left)
    
    private let timestampLabel = PaddedLabel(text: "", font: .systemFont(ofSize: 14, weight: .medium), padding: 0)
    private let disclosureIndicator = PawButton(image: SFSymbols.chevronRight, tintColor: .gray, font: .systemFont(ofSize: 12, weight: .medium))
    private lazy var timestampStack = PawStackView(views: [timestampLabel, disclosureIndicator], spacing: 10, distribution: .fill, alignment: .fill)
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        backgroundColor = bgLightGray
        profileImageView.layer.cornerRadius = 60 / 2
        msgPreviewLabel.numberOfLines = 2
        timestampLabel.textAlignment = .left
        timestampLabel.textColor = .gray
    }
    
    private func layoutUI() {
        addSubviews(newMessageIndicator, profileImageView, nameLabel, msgPreviewLabel, timestampStack)
        
        newMessageIndicator.setDimension(wConst: 8, hConst: 8)
        newMessageIndicator.center(to: self, by: .centerY)
        newMessageIndicator.anchor(leading: leadingAnchor, paddingLeading: 11)
        
        profileImageView.setDimension(wConst: 60, hConst: 60)
        profileImageView.center(to: self, by: .centerY)
        profileImageView.anchor(leading: leadingAnchor, paddingLeading: 28)
        
        nameLabel.anchor(top: topAnchor, leading: profileImageView.trailingAnchor, paddingTop: 13, paddingLeading: 10)
        nameLabel.setDimension(hConst: 30)
        
        msgPreviewLabel.anchor(top: nameLabel.bottomAnchor, trailing: trailingAnchor, leading: nameLabel.leadingAnchor, paddingTrailing: 28)
        
        timestampStack.anchor(top: nameLabel.topAnchor, trailing: msgPreviewLabel.trailingAnchor, bottom: nameLabel.bottomAnchor, leading: nameLabel.trailingAnchor, paddingLeading: 10)
    }
    
    func setupWith(recentMessage: RecentMessage?) {
        guard let recentMessage = recentMessage else { return }
        profileImageView.setImage(imageUrlString: recentMessage.profileImageUrl, completion: nil)
        nameLabel.text = recentMessage.name
        msgPreviewLabel.text = recentMessage.message
        timestampLabel.text = recentMessage.timestamp.dateValue().stringValue(format: "M/dd/yy")
        newMessageIndicator.isHidden = recentMessage.isRead
    }
}
