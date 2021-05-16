//
//  ImagePickerView.swift
//  Paw_nder
//
//  Created by William Yeung on 5/14/21.
//

import UIKit
import SwiftUI

class ImagePickerView: UIView {
    // MARK: - Properties
    lazy var imagePickerViews = [imagePickerView1, imagePickerView2, imagePickerView3, imagePickerView4, imagePickerView5]
    
    // MARK: - Views
    private let imagePickerView1 = ImagePickerButtonView(imageCornerRadius: 15, tagNumber: 1)
    private let imagePickerView2 = ImagePickerButtonView(imageCornerRadius: 8, tagNumber: 2)
    private let imagePickerView3 = ImagePickerButtonView(imageCornerRadius: 8, tagNumber: 3)
    private let imagePickerView4 = ImagePickerButtonView(imageCornerRadius: 8, tagNumber: 4)
    private let imagePickerView5 = ImagePickerButtonView(imageCornerRadius: 8, tagNumber: 5)
    private lazy var pickerButtonsStack = PawStackView(views: [imagePickerView3, imagePickerView4, imagePickerView5], spacing: 5, distribution: .fillEqually, alignment: .fill)
    
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
        addSubviews(imagePickerView1, imagePickerView2, pickerButtonsStack)
        imagePickerView1.setDimension(width: widthAnchor, height: widthAnchor, wMult: 0.4, hMult: 0.475)
        imagePickerView1.center(to: self, by: .centerX, withMultiplierOf: 0.65)
        imagePickerView1.anchor(top: topAnchor, paddingTop: 20)
        
        imagePickerView2.setDimension(width: widthAnchor, height: widthAnchor, wMult: 0.3, hMult: 0.75 / 2)
        imagePickerView2.center(y: imagePickerView1.centerYAnchor)
        imagePickerView2.anchor(leading: imagePickerView1.trailingAnchor, paddingLeading: 10)
        
        pickerButtonsStack.anchor(top: imagePickerView1.bottomAnchor)
        pickerButtonsStack.center(to: self, by: .centerX)
        pickerButtonsStack.setDimension(width: widthAnchor, wMult: 0.9)
        
        imagePickerView4.setDimension(height: widthAnchor, hMult: 0.75 / 2)
        imagePickerView4.transform = CGAffineTransform(translationX: 0, y: 25)
        imagePickerView5.transform = CGAffineTransform(translationX: 0, y: -20)
    }
    
    func setupButtonActions() {
        for view in imagePickerViews {
            view.addDeleteButton.addTarget(self, action: #selector(handleAddDeleteTapped(tappedButton:)), for: .touchUpInside)
        }
    }
    
    func setupDidSelectImageNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleImagePicked(notification:)), name: .didSelectPhoto, object: nil)
    }
    
    func setImage(imagePickerButtonView: ImagePickerButtonView, image: UIImage) {
        imagePickerButtonView.imageView.image = image
        imagePickerButtonView.imageView.contentMode = .scaleAspectFill
        imagePickerButtonView.imageView.clipsToBounds = true
        imagePickerButtonView.changeAddDeleteButtonImageTo(image: SFSymbols.xmark)
    }
    
    func setCurrentUserImage(urlStringsDictionary: [String: String]?) {
        guard let urlStringsDictionary = urlStringsDictionary else { return }
        
        let urlStringsArray = Array(urlStringsDictionary.values)

        for i in 0..<urlStringsDictionary.count {
            FirebaseManager.shared.downloadImage(urlString: urlStringsArray[i]) { (image) in
                if let image = image {
                    let buttonKey = Int(Array(urlStringsDictionary.keys)[i]) ?? 0
                    DispatchQueue.main.async { self.setImage(imagePickerButtonView: self.imagePickerViews[buttonKey - 1], image: image) }
                }
            }
        }
    }
    
    // MARK: - Selector
    @objc func handleAddDeleteTapped(tappedButton: UIButton) {
        NotificationCenter.default.post(Notification(name: .didOpenImagePicker, object: nil, userInfo: [buttonTag: tappedButton.tag]))
    }
    
    @objc func handleImagePicked(notification: Notification) {
        let tagNumber = notification.userInfo?.keys.first as? Int ?? 0
        let selectedImage = notification.userInfo?[tagNumber] as? UIImage ?? UIImage()

        switch tagNumber {
            case 1:
                setImage(imagePickerButtonView: imagePickerView1, image: selectedImage)
            case 2:
                setImage(imagePickerButtonView: imagePickerView2, image: selectedImage)
            case 3:
                setImage(imagePickerButtonView: imagePickerView3, image: selectedImage)
            case 4:
                setImage(imagePickerButtonView: imagePickerView4, image: selectedImage)
            default:
                setImage(imagePickerButtonView: imagePickerView5, image: selectedImage)
        }
    }
}

