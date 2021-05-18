//
//  EditSettingsAgeVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/17/21.
//

import UIKit

class EditSettingsAgeVC: EditSettingsRootVC {
    // MARK: - Properties
    let ages = Array(stride(from: 0, through: 100, by: 1))
    
    // MARK: - Views
    private let ageLabel = PawLabel(text: "Your Age", textColor: .black, font: .systemFont(ofSize: 45, weight: .bold), alignment: .left)
    private let captionLabel = PawLabel(text: "We use this to tailor the app and allows other users to better match up with you.", textColor: .gray, font: .systemFont(ofSize: 16, weight: .medium), alignment: .left)
    private lazy var labelStack = PawStackView(views: [ageLabel, captionLabel], spacing: 10, axis: .vertical, distribution: .fill, alignment: .fill)
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = bgLightGray
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Helpers
    override func configureUI() {
        super.configureUI()
        captionLabel.numberOfLines = 0
    }
    
    override func layoutUI() {
        super.layoutUI()
        view.addSubviews(labelStack, collectionView)
        labelStack.center(to: view, by: .centerY, withMultiplierOf: 0.5)
        labelStack.anchor(trailing: view.trailingAnchor, leading: view.leadingAnchor, paddingTrailing: 15, paddingLeading: 15)

        collectionView.anchor(top: labelStack.bottomAnchor, trailing: view.trailingAnchor, leading: view.leadingAnchor, paddingTop: 15)
        collectionView.setDimension(height: view.widthAnchor, hMult: 0.4)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension EditSettingsAgeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = view.frame.width * 0.3
        return .init(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 15, bottom: 0, right: 15)
    }
}
