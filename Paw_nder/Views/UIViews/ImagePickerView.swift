//
//  ImagePickerView.swift
//  Paw_nder
//
//  Created by William Yeung on 5/14/21.
//

import UIKit
import SwiftUI

class ImagePickerView: UIView {
    // MARK: - Views
    private let mainImagePickerButton = ImagePickerButtonView(imageCornerRadius: 15, tagNumber: 1)
    private let secondaryPickerButton1 = ImagePickerButtonView(imageCornerRadius: 8, tagNumber: 2)
    private let secondaryPickerButton2 = ImagePickerButtonView(imageCornerRadius: 8, tagNumber: 3)
    private let secondaryPickerButton3 = ImagePickerButtonView(imageCornerRadius: 8, tagNumber: 4)
    private lazy var pickerButtonsStack = PawStackView(views: [secondaryPickerButton1, secondaryPickerButton2, secondaryPickerButton3], spacing: 5, distribution: .fillEqually, alignment: .fill)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
        setupButtonActions()
        setupDidSelectImageNotificationObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helpers
    private func layoutUI() {
        addSubviews(mainImagePickerButton, pickerButtonsStack)
        mainImagePickerButton.setDimension(width: widthAnchor, height: widthAnchor, wMult: 0.4, hMult: 0.475)
        mainImagePickerButton.center(to: self, by: .centerX)
        mainImagePickerButton.anchor(top: topAnchor, paddingTop: 20)
        
        pickerButtonsStack.anchor(top: mainImagePickerButton.bottomAnchor)
        pickerButtonsStack.center(to: self, by: .centerX)
        pickerButtonsStack.setDimension(width: widthAnchor, wMult: 0.9)
        
        secondaryPickerButton2.setDimension(height: widthAnchor, hMult: 0.75 / 2)
        secondaryPickerButton2.transform = CGAffineTransform(translationX: 0, y: 25)
    }
    
    func setupButtonActions() {
        for view in [mainImagePickerButton, secondaryPickerButton1, secondaryPickerButton2, secondaryPickerButton3] {
            view.addButton.addTarget(self, action: #selector(handleAddImageButtonTapped(tappedButton:)), for: .touchUpInside)
        }
    }
    
    func setupDidSelectImageNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleImagePicked(notification:)), name: .didSelectPhoto, object: nil)
    }
    
    func setImage(imageView: UIImageView, image: UIImage) {
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    func setCurrentUserImage(urlStringsDictionary: [String: String]?) {
        guard let urlStringsDictionary = urlStringsDictionary else { return }
        let views = [mainImagePickerButton, secondaryPickerButton1, secondaryPickerButton2, secondaryPickerButton3]
        
        let urlStringsArray = Array(urlStringsDictionary.values)

        for i in 0..<urlStringsDictionary.count {
            FirebaseManager.shared.downloadImage(urlString: urlStringsArray[i]) { (image) in
                if let image = image {
                    let buttonKey = Int(Array(urlStringsDictionary.keys)[i]) ?? 0
                    DispatchQueue.main.async { self.setImage(imageView: views[buttonKey - 1].imageView, image: image) }
                }
            }
        }
    }
    
    // MARK: - Selector
    @objc func handleAddImageButtonTapped(tappedButton: UIButton) {
        NotificationCenter.default.post(Notification(name: .didOpenImagePicker, object: nil, userInfo: [buttonTag: tappedButton.tag]))
    }
    
    @objc func handleImagePicked(notification: Notification) {
        let tagNumber = notification.userInfo?.keys.first as? Int ?? 0
        let selectedImage = notification.userInfo?[tagNumber] as? UIImage ?? UIImage()

        switch tagNumber {
            case 1:
                setImage(imageView: mainImagePickerButton.imageView, image: selectedImage)
            case 2:
                setImage(imageView: secondaryPickerButton1.imageView, image: selectedImage)
            case 3:
                setImage(imageView: secondaryPickerButton2.imageView, image: selectedImage)
            default:
                setImage(imageView: secondaryPickerButton3.imageView, image: selectedImage)
        }
    }
}

