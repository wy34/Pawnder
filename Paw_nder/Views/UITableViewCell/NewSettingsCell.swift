//
//  NewSettingsCell.swift
//  Paw_nder
//
//  Created by William Yeung on 5/16/21.
//

import UIKit


class NewSettingsCell: UITableViewCell {
    // MARK: - Properties
    static let reuseId = "NewSettingsCell"
    
    // MARK: - Views
    private let settingsLabel = PaddedLabel(text: "Name", font: .systemFont(ofSize: 16, weight: .bold), padding: 5)
    private let previewLabel = PaddedLabel(text: "William Yeung", font: .systemFont(ofSize: 16), padding: 5)
    
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
        accessoryType = .disclosureIndicator
        previewLabel.textColor = .lightGray
        previewLabel.textAlignment = .right
//        settingsLabel.backgroundColor = .red
//        previewLabel.backgroundColor = .blue
    }
    
    private func layoutUI() {
        addSubviews(settingsLabel, previewLabel)
        settingsLabel.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, paddingLeading: 10)
        settingsLabel.setDimension(width: widthAnchor, wMult: 0.3)
        previewLabel.anchor(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, paddingTrailing: 35)
        previewLabel.setDimension(width: widthAnchor, wMult: 0.5)
    }
    
    func configureWith(setting: Setting) {
        settingsLabel.text = setting.name
        previewLabel.text = setting.preview
    }
}