//
//  AgeCell.swift
//  Paw_nder
//
//  Created by William Yeung on 6/26/21.
//

import UIKit

class AgeCell: UICollectionViewCell {
    // MARK: - Properties
    static let reuseId = "AgeCell"
    
    // MARK: - Views
    private let ageLabel = PawLabel(text: "35", textColor: .white, font: .systemFont(ofSize: 45, weight: .bold), alignment: .center)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helpers
    private func layoutUI() {
        addSubview(ageLabel)
        ageLabel.fill(superView: self)
    }
    
    func setupWith(age: Int) {
        ageLabel.text = "\(age)"
    }
    
    func handleViewFor(selection: Bool) {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.layer.cornerRadius = 10
            self?.layer.shadowOpacity = 0.25
            self?.layer.borderColor = Colors.lightTransparentGray.cgColor
            self?.layer.borderWidth = selection ? 3 : 0
            self?.backgroundColor = selection ? .white : Colors.lightRed
            self?.ageLabel.textColor = selection ? Colors.lightRed : .white
        }
    }
}
