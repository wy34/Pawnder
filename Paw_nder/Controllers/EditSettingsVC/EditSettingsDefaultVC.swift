//
//  EditSettingsVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/17/21.
//

import UIKit

class EditSettingsDefaultVC: EditSettingsRootVC {
    // MARK: - Properties
    let textFieldHeight: CGFloat = 45
    
    // MARK: - Views
    private let textfield = PaddedTextField(placeholder: "", bgColor: .clear, padding: .init(top: 0, left: 15, bottom: 0, right: 15))
    private let buttonContainerView = PawView(bgColor: .clear)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        settings?.preview = textfield.text
        newSettingsVC?.updateNewSettingsPreview(settings: settings!)
    }
        
    // MARK: - Helpers
    override func configureUI() {
        super.configureUI()
        textfield.layer.cornerRadius = textFieldHeight / 2
        textfield.textAlignment = .center
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.lightGray.cgColor
        textfield.font = .systemFont(ofSize: 16, weight: .medium)
        textfield.becomeFirstResponder()
    }
    
    override func layoutUI() {
        super.layoutUI()
        view.addSubview(textfield)
        textfield.anchor(top: view.topAnchor, paddingTop: 25)
        textfield.center(to: view, by: .centerX)
        textfield.setDimension(width: view.widthAnchor, wMult: 0.9)
        textfield.setDimension(hConst: textFieldHeight)
    }
        
    override func configureWith(setting: Setting) {
        super.configureWith(setting: setting)
        textfield.text = setting.preview
        textfield.placeholder = setting.emoji + " " + setting.title.rawValue.capitalized
    }
    
    // MARK: - Selector
}
