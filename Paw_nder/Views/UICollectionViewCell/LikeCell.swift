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
    private let placeholderImageView = PawImageView(image: UIImage(named: "pawPrint")!, contentMode: .scaleAspectFit)
    private let userImageView = PawImageView(image: nil, contentMode: .scaleAspectFill)
    private let gradientView = GradientView(color1: .clear, color2: .black)
    private let nameLabel = PawLabel(text: "", textColor: .white, font: .systemFont(ofSize: 22, weight: .bold), alignment: .center)
    
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
        layer.borderColor = Colors.lightTransparentGray.cgColor
        gradientView.layer.opacity = 0.3
    }
    
    private func layoutUI() {
        addSubviews(userImageView, placeholderImageView, gradientView, nameLabel)
        userImageView.fill(superView: self)
        placeholderImageView.setDimension(width: widthAnchor, height: heightAnchor, wMult: 0.5, hMult: 0.5)
        placeholderImageView.center(x: centerXAnchor, y: centerYAnchor)
        gradientView.fill(superView: self)
        nameLabel.anchor(trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor, paddingBottom: 10)
    }
    
    func setupCellWith(user: User?) {
        guard let user = user, let imageUrls = user.imageUrls else { return }
        
        if let firstImage = imageUrls["1"] {
            userImageView.setImage(imageUrlString: firstImage, completion: {
                self.nameLabel.text = user.name
                self.placeholderImageView.isHidden = true
            })
        }
    }
}
