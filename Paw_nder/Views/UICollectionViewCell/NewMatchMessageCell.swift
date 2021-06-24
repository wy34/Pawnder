//
//  NewMatchMessageCell.swift
//  Paw_nder
//
//  Created by William Yeung on 5/8/21.
//

import UIKit

class NewMatchMessageCell: UICollectionViewCell {
    // MARK: - Properties
    static let reuseId = "NewMatchMessageCell"
    
    // MARK: - Views
    private let userImageView = PawImageView(image: nil, contentMode: .scaleAspectFill)
    private let userNameLabel = PawLabel(text: "Bob", font: .systemFont(ofSize: 14, weight: .regular), alignment: .center)
    
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
    func configureUI() {
        userImageView.layer.cornerRadius = 20
        userImageView.layer.borderWidth = 3
        userImageView.layer.borderColor = Colors.lightTransparentGray.cgColor
    }
    
    func layoutUI() {
        addSubviews(userImageView, userNameLabel)
        
        userImageView.setDimension(width: widthAnchor, height: widthAnchor, wMult: 0.7, hMult: 0.7)
        userImageView.anchor(top: topAnchor)
        userImageView.center(to: self, by: .centerX)
        userNameLabel.anchor(top: userImageView.bottomAnchor, trailing: userImageView.trailingAnchor, bottom: bottomAnchor, leading: userImageView.leadingAnchor)
    }
    
    func setupWith(userMatch: Match?) {
        guard let match = userMatch else { return }
        userImageView.setImage(imageUrlString: match.imageUrlString, completion: nil)
        userNameLabel.text = match.name
    }
}
