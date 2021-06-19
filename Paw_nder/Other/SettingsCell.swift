////
////  SettingsCell.swift
////  Paw_nder
////
////  Created by William Yeung on 4/24/21.
////
//
//import UIKit
//
//class SettingsCell: UITableViewCell {
//    // MARK: - Properties
//    static let reuseId = "SettingsCell"
//    
//    // MARK: - Views
//    let textfield = PawTextField(placeholder: "", bgColor: .clear, cornerRadius: 0)
//    
//    // MARK: - Init
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        layoutUI()
//        configureUI()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError()
//    }
//    
//    // MARK: - Helpers
//    private func configureUI() {
//        textfield.textColor = .darkGray
//    }
//    
//    private func layoutUI() {
//        contentView.addSubview(textfield)
//        textfield.anchor(top: contentView.topAnchor, trailing: contentView.trailingAnchor, bottom: contentView.bottomAnchor, leading: contentView.leadingAnchor, paddingTop: 8, paddingTrailing: 12, paddingBottom: 8, paddingLeading: 12)
//        textfield.fill(superView: contentView, withPadding: .init(top: 8, left: 12, bottom: 8, right: 12))
//    }
//    
//    func setTextfield(text: String?, ph: String) {
//        textfield.placeholder = ph
//        textfield.text = text
//    }
//}
