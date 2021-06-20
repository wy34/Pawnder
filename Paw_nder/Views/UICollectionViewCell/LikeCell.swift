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
        userImageView.backgroundColor = #colorLiteral(red: 0.8908709884, green: 0.894202292, blue: 0.9022397399, alpha: 1)
    }
    
    private func layoutUI() {
        addSubview(userImageView)
        userImageView.fill(superView: self)
    }
    
    func setupCellWith(user: User?) {
        guard let user = user, let imageUrls = user.imageUrls else { return }
        
        if let firstImage = imageUrls["1"] {
            userImageView.setImage(imageUrlString: firstImage, completion: nil)
        }
    }
}
