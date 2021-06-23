//
//  ImagePickerView.swift
//  Paw_nder
//
//  Created by William Yeung on 5/14/21.
//

import UIKit
import SwiftUI

class ImagePickerGridView: UIView {
    // MARK: - Properties
    var user: User?
    lazy var imagePickerViews = [imagePickerView1, imagePickerView2, imagePickerView3, imagePickerView4, imagePickerView5, imagePickerView6]
    
    // MARK: - Views
    private let imagePickerView1 = ImagePickerButtonView(imageCornerRadius: 15, tagNumber: 1)
    private let imagePickerView2 = ImagePickerButtonView(imageCornerRadius: 8, tagNumber: 2)
    private let imagePickerView3 = ImagePickerButtonView(imageCornerRadius: 8, tagNumber: 3)
    private let imagePickerView4 = ImagePickerButtonView(imageCornerRadius: 8, tagNumber: 4)
    private let imagePickerView5 = ImagePickerButtonView(imageCornerRadius: 8, tagNumber: 5)
    private let imagePickerView6 = ImagePickerButtonView(imageCornerRadius: 8, tagNumber: 6)
        
    private lazy var rightVStack = PawStackView(views: [imagePickerView2, imagePickerView3, imagePickerView4], axis: .vertical, distribution: .fillEqually, alignment: .fill)
    private lazy var bottomHStack = PawStackView(views: [imagePickerView5, imagePickerView6], axis: .horizontal, distribution: .fillEqually, alignment: .fill)
    
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
        addSubviews(imagePickerView1, rightVStack, bottomHStack)
        imagePickerView1.anchor(top: topAnchor, leading: leadingAnchor)
        imagePickerView1.setDimension(width: widthAnchor, height: widthAnchor, wMult: 0.6, hMult: 0.6)
        
        rightVStack.anchor(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leading: imagePickerView1.trailingAnchor)
        bottomHStack.anchor(top: imagePickerView1.bottomAnchor, trailing: rightVStack.leadingAnchor, bottom: bottomAnchor, leading: leadingAnchor)
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
        imagePickerButtonView.changeButtonTo(delete: true)
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
    
    private func viewFor(button: UIButton) -> ImagePickerButtonView {
        switch button.tag {
            case 1:
                return imagePickerView1
            case 2:
                return imagePickerView2
            case 3:
                return imagePickerView3
            case 4:
                return imagePickerView4
            case 5:
                return imagePickerView5
            default:
                return imagePickerView6
        }
    }
    
    // MARK: - Selector
    @objc func handleAddDeleteTapped(tappedButton: UIButton) {
        let imagePickerButtonView = viewFor(button: tappedButton)
        
        if imagePickerButtonView.imageView.image == nil {
            NotificationCenter.default.post(Notification(name: .didOpenImagePicker, object: nil, userInfo: [buttonTag: tappedButton.tag]))
        } else {
            imagePickerButtonView.removeImageFor(buttonTag: tappedButton.tag, user: user)
        }
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
            case 5:
                setImage(imagePickerButtonView: imagePickerView5, image: selectedImage)
            default:
                setImage(imagePickerButtonView: imagePickerView6, image: selectedImage)
        }
    }
}

