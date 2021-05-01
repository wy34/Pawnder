//
//  NewCard.swift
//  Paw_nder
//
//  Created by William Yeung on 5/1/21.
//

import UIKit
import SwiftUI

class NewCard: UIViewController {
    // MARK: - Views
    private let card = PawView(bgColor: .white, cornerRadius: 15)
    private let profileImageView = PawImageView(image: UIImage(named: bob3)!, contentMode: .scaleAspectFill)
    private let nameLabel = PawLabel(text: "Rex", textColor: .black, font: .boldSystemFont(ofSize: 24), alignment: .left)
    private let bioLabel = PawLabel(text: "Potty trained. Loves walks and belly rubs", textColor: .black, font: .systemFont(ofSize: 18, weight: .medium), alignment: .left)
    private let breedLabel = PawLabel(text: "Golden Retriever", textColor: lightRed, font: .systemFont(ofSize: 14, weight: .medium), alignment: .left)
    private let ageLabel = PawLabel(text: "5.5 years", textColor: lightRed, font: .systemFont(ofSize: 14, weight: .medium), alignment: .right)
    private lazy var bottomLabelStack = PawStackView(views: [breedLabel, ageLabel], distribution: .fillEqually, alignment: .fill)
    private lazy var overallLabelStack = PawStackView(views: [nameLabel, bioLabel, bottomLabelStack], axis: .vertical, distribution: .fillEqually, alignment: .fill)
    private let aboutButton = PawButton(image: info, tintColor: .white, font: .systemFont(ofSize: 24, weight: .bold))
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        configureUI()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        profileImageView.layer.cornerRadius = 15
        profileImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        card.layer.shadowOpacity = 0.75
        card.layer.shadowOffset = .init(width: 0, height: 0)
    }
    
    private func layoutUI() {
        view.addSubview(card)
        card.setDimension(width: view.widthAnchor, height: view.heightAnchor, wMult: 0.85, hMult: 0.65)
        card.center(x: view.centerXAnchor, y: view.centerYAnchor)
        
        card.addSubviews(profileImageView, overallLabelStack)
        profileImageView.setDimension(width: card.widthAnchor, height: card.heightAnchor, hMult: 0.75)
        profileImageView.anchor(top: card.topAnchor, trailing: card.trailingAnchor, leading: card.leadingAnchor)
        overallLabelStack.anchor(top: profileImageView.bottomAnchor, trailing: card.trailingAnchor, bottom: card.bottomAnchor, leading: card.leadingAnchor, paddingTop: 15, paddingTrailing: 15, paddingBottom: 15, paddingLeading: 15)
        
        #warning("Putting button onto imageview does not allow pressing")
        profileImageView.addSubview(aboutButton)
        aboutButton.anchor(trailing: profileImageView.trailingAnchor, bottom: profileImageView.bottomAnchor, paddingTrailing: 10, paddingBottom: 10)
        aboutButton.setDimension(wConst: 44, hConst: 44)
    }
}












struct NewCardView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> NewCard {
        let newCard = NewCard()
        return newCard
    }
    
    func updateUIViewController(_ uiViewController: NewCard, context: Context) {
        
    }
}


struct NewCardView_Previews: PreviewProvider {
    static var previews: some View {
        NewCardView()
    }
}
