//
//  EditSettingsBioViewViewController.swift
//  Paw_nder
//
//  Created by William Yeung on 5/17/21.
//

import UIKit

class EditSettingsBioVC: EditSettingsRootVC {
    // MARK: - Properties
    let bioCharacterLimit = 160
    
    // MARK: - Views
    private let placeholderLabel = PawLabel(text: "Add a bio", textColor: .lightGray, font: .systemFont(ofSize: 16, weight: .medium), alignment: .left)
    private let textView = PawTextView(placeholder: "", textColor: .black, bgColor: .clear)
    private let characterCountLabel = PawLabel(text: "Characters left: 160", textColor: .black, font: .systemFont(ofSize: 12), alignment: .right)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        settings?.preview = textView.text
        newSettingsVC?.updateNewSettingsPreview(settings: settings!)
    }

    // MARK: - Helpers
    override func configureUI() {
        super.configureUI()
        textView.delegate = self
        textView.layer.cornerRadius = 15
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 16, weight: .medium)
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
        placeholderLabel.anchor(top: textView.topAnchor, trailing: textView.trailingAnchor, bottom: textView.bottomAnchor, leading: textView.leadingAnchor, paddingTop: 10, paddingTrailing: 15, paddingBottom: 10, paddingLeading: 15)
        characterCountLabel.anchor(top: textView.bottomAnchor, trailing: textView.trailingAnchor, paddingTop: 5)
    }
    
    override func configureWith(setting: Setting) {
        super.configureWith(setting: setting)
        textView.text = setting.preview
        placeholderLabel.text = setting.emoji + " " + setting.name
        characterCountLabel.text = "Characters left: " + String(bioCharacterLimit - setting.preview!.count)
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
