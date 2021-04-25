//
//  ImagePickerHeaderView.swift
//  Paw_nder
//
//  Created by William Yeung on 4/24/21.
//

import UIKit
import SwiftUI

class ImagePickerHeaderView: UIView {
    // MARK: - Properties
    
    // MARK: - Views
    private let imageButton1 = PawButton(title: "Select Photo", textColor: lightRed, font: .systemFont(ofSize: 16, weight: .bold))
    private let imageButton2 = PawButton(title: "Select Photo", textColor: lightRed, font: .systemFont(ofSize: 16, weight: .bold))
    private let imageButton3 = PawButton(title: "Select Photo", textColor: lightRed, font: .systemFont(ofSize: 16, weight: .bold))
    private lazy var rightButtonStack = PawStackView(views: [imageButton2, imageButton3], spacing: 10, axis: .vertical, distribution: .fillEqually, alignment: .fill)
    private lazy var buttonStack = PawStackView(views: [imageButton1, rightButtonStack], spacing: 10, distribution: .fillEqually, alignment: .fill)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
        setupButtonActions()
        configureUI()
        setupDidSelectImageNotificationObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helpers
    func layoutUI() {
        addSubview(buttonStack)
        buttonStack.fill(superView: self, withPaddingOnAllSides: 16)
    }
    
    func configureUI() {
        for button in [imageButton1, imageButton2, imageButton3] {
            button.layer.cornerRadius = 10
            button.backgroundColor = .white
        }
    }
    
    func setupButtonActions() {
        for (index, button) in [imageButton1, imageButton2, imageButton3].enumerated() {
            button.tag = index + 1
            button.addTarget(self, action: #selector(handleSelectImageTapped(tappedButton:)), for: .touchUpInside)
        }
    }
    
    func setupDidSelectImageNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleImagePicked(notification:)), name: .didSelectPhoto, object: nil)
    }
    
    func setSelectedImage(button: UIButton, image: UIImage) {
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
    }
    
    // MARK: - Selector
    @objc func handleSelectImageTapped(tappedButton: UIButton) {
        NotificationCenter.default.post(Notification(name: .didOpenImagePicker, object: nil, userInfo: [buttonTag: tappedButton.tag]))
    }
    
    @objc func handleImagePicked(notification: Notification) {
        let tagNumber = notification.userInfo?.keys.first as? Int ?? 0
        let selectedImage = notification.userInfo?[tagNumber] as? UIImage ?? UIImage()

        switch tagNumber {
            case 1:
                setSelectedImage(button: imageButton1, image: selectedImage)
            case 2:
                setSelectedImage(button: imageButton2, image: selectedImage)
            default:
                setSelectedImage(button: imageButton3, image: selectedImage)
        }
    }
}
