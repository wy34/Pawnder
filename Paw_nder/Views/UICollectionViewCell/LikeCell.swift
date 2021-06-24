//
//  LikeCell.swift
//  Paw_nder
//
//  Created by William Yeung on 6/19/21.
//

import UIKit

class LikeCell: UICollectionViewCell {
    // MARK: - Properties
    static let reuseId = "LikeCell"
    
    // MARK: - Views
    private let userImageView = PawImageView(image: UIImage(named: "pawPrint")!, contentMode: .scaleAspectFill)
    private let gradientView = GradientView(color1: .clear, color2: .black)
    private let nameLabel = PawLabel(text: "Bob", textColor: .white, font: .systemFont(ofSize: 22, weight: .bold), alignment: .center)
    
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
        clipsToBounds = true
        layer.cornerRadius = 15
        layer.borderWidth = 3
        layer.borderColor = lightTransparentGray.cgColor
        userImageView.backgroundColor = #colorLiteral(red: 0.8908709884, green: 0.894202292, blue: 0.9022397399, alpha: 1)
        gradientView.layer.opacity = 0.35
    }
    
    private func layoutUI() {
        addSubviews(userImageView, gradientView, nameLabel)
        userImageView.fill(superView: self)
        gradientView.fill(superView: self)
        nameLabel.anchor(trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor, paddingBottom: 10)
    }
    
    func setupCellWith(user: User?) {
        guard let user = user, let imageUrls = user.imageUrls else { return }
        
        if let firstImage = imageUrls["1"] {
            userImageView.setImage(imageUrlString: firstImage, completion: nil)
        }
        
        nameLabel.text = user.name
    }
}
