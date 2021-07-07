//
//  EditSettingsBioViewViewController.swift
//  Paw_nder
//
//  Created by William Yeung on 5/17/21.
//

import UIKit

class EditSettingsBioVC: EditSettingsRootVC {
    // MARK: - Properties
    let bioCharacterLimit = 200
    
    // MARK: - Views
    private let placeholderLabel = PawLabel(text: "Add a bio", textColor: .lightGray, font: markerFont(22), alignment: .left)
    private let textView = PawTextView(placeholder: "", textColor: .black, bgColor: .clear)
    private lazy var characterCountLabel = PawLabel(text: "Characters left: \(bioCharacterLimit)", textColor: .gray, font: markerFont(16), alignment: .right)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Helpers
    override func configureUI() {
        super.configureUI()
        textView.delegate = self
        textView.layer.cornerRadius = 15
        textView.isScrollEnabled = false
        textView.font = markerFont(22)
        textView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.becomeFirstResponder()
    }
    
    override func layoutUI() {
        super.layoutUI()
        view.addSubviews(textView, placeholderLabel, characterCountLabel)
        textView.anchor(top: view.topAnchor, paddingTop: 25)
        textView.center(to: view, by: .centerX)
        textView.setDimension(width: view.widthAnchor, wMult: 0.9)
        placeholderLabel.fill(superView: textView, withPadding: .init(top: 10, left: 15, bottom: 10, right: 15))
        characterCountLabel.anchor(top: textView.bottomAnchor, trailing: textView.trailingAnchor, paddingTop: 5)
    }
    
    override func configureWith(setting: Setting) {
        super.configureWith(setting: setting)
        textView.text = setting.preview
        placeholderLabel.text = setting.emoji + " " + setting.title.rawValue.capitalized
        characterCountLabel.text = "Characters left: " + String(bioCharacterLimit - setting.preview!.count)
    }
    
    override func handleSave() {
        settingsVM.user?.bio = textView.text
        super.handleSave()
    }
}

// MARK: - UITextViewDelegate
extension EditSettingsBioVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let range = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: range, with: text)
        if updatedText.count <= bioCharacterLimit {
            characterCountLabel.text = "Characters left: " + String(bioCharacterLimit - updatedText.count)
        }
        return updatedText.count <= bioCharacterLimit
    }
}
