//
//  EditSettingsAgeVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/17/21.
//

import UIKit

class EditSettingsAgeVC: EditSettingsRootVC {
    // MARK: - Properties
    var ages = Array(repeating: false, count: 31)
    var initialScrollDone = false
    var userAge = 0
    
    // MARK: - Views
    private let ageLabel = PawLabel(text: "Your Age", textColor: .black, font: .systemFont(ofSize: 35, weight: .bold), alignment: .left)
    private let captionLabel = PawLabel(text: "We use this to tailor the app and allows other users to better match up with you.", textColor: .gray, font: .systemFont(ofSize: 16, weight: .medium), alignment: .left)
    private lazy var labelStack = PawStackView(views: [ageLabel, captionLabel], spacing: 10, axis: .vertical, distribution: .fill, alignment: .fill)
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = bgLightGray
        cv.showsHorizontalScrollIndicator = false
        cv.register(AgeCell.self, forCellWithReuseIdentifier: AgeCell.reuseId)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
        
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollToUserAge()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        settings?.preview = "\(userAge)"
        newSettingsVC?.updateNewSettingsPreview(settings: settings!)
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
        labelStack.anchor(trailing: view.trailingAnchor, leading: view.leadingAnchor, paddingTrailing: 25, paddingLeading: 25)

        collectionView.anchor(top: labelStack.bottomAnchor, trailing: view.trailingAnchor, leading: view.leadingAnchor, paddingTop: 15)
        collectionView.setDimension(height: view.widthAnchor, hMult: 0.4)
    }
    
    override func configureWith(setting: Setting) {
        super.configureWith(setting: setting)
        userAge = Int(setting.preview ?? "") ?? 0
    }
    
    private func scrollToUserAge() {
        guard initialScrollDone == false else { return }
        let indexPath = IndexPath(item: userAge, section: 0)
        collectionView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
        initialScrollDone = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.26) {
            let cell = self.collectionView.cellForItem(at: indexPath) as! AgeCell
            cell.handleViewFor(selection: true)
            self.ages[indexPath.item] = true
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension EditSettingsAgeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AgeCell.reuseId, for: indexPath) as! AgeCell
        cell.setupWith(age: indexPath.item)
        ages[indexPath.item] == true ? cell.handleViewFor(selection: true) : cell.handleViewFor(selection: false)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = view.frame.width * 0.3
        return .init(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 25, bottom: 0, right: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! AgeCell
        
        for cell in collectionView.visibleCells as! [AgeCell] {
            cell.handleViewFor(selection: false)
        }
        
        ages = Array(repeating: false, count: self.ages.count)
        ages[indexPath.item] = true
        
        cell.handleViewFor(selection: true)
        
        userAge = indexPath.item
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        cell.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        UIView.animate(withDuration: 0.65) {
            cell.alpha = 1
            cell.transform = .identity
        }
    }
}





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
            self?.layer.borderColor = lightTransparentGray.cgColor
            self?.layer.borderWidth = selection ? 3 : 0
            self?.backgroundColor = selection ? .white : lightRed
            self?.ageLabel.textColor = selection ? lightRed : .white
        }
    }
}
