//
//  LoadingButton.swift
//  Paw_nder
//
//  Created by William Yeung on 4/24/21.
//

import UIKit
import Firebase

class ImagePickerButtonView: UIView {
    // MARK: - Views
    let imageView = PawImageView(image: nil, contentMode: .scaleAspectFill)
    let addDeleteButton = PawButton(image: SFSymbols.plus, tintColor: .white, font: .systemFont(ofSize: 10, weight: .black))
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI(imageCornerRadius: 0)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    init(imageCornerRadius: CGFloat, tagNumber: Int) {
        super.init(frame: .zero)
        self.addDeleteButton.tag = tagNumber
        configureUI(imageCornerRadius: imageCornerRadius)
        layoutUI()
    }
    
    // MARK: - Helpers
    private func configureUI(imageCornerRadius: CGFloat) {
        imageView.backgroundColor = Colors.lightGray
        imageView.layer.cornerRadius = imageCornerRadius
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = Colors.lightTransparentGray.cgColor
        addDeleteButton.backgroundColor = Colors.lightRed
        addDeleteButton.layer.cornerRadius = 23/2
        addDeleteButton.layer.shadowOpacity = 0.15
    }
    
    private func layoutUI() {
        addSubviews(imageView, addDeleteButton)
        imageView.fill(superView: self, withPaddingOnAllSides: 5)
        
        addDeleteButton.setDimension(wConst: 23, hConst: 23)
        addDeleteButton.anchor(top: imageView.topAnchor, leading: imageView.leadingAnchor, paddingTop: -5, paddingLeading: -5)
    }
    
    func changeButtonTo(delete: Bool) {
        if delete {
            addDeleteButton.setImage(SFSymbols.xmark.applyingSymbolConfiguration(.init(font: .systemFont(ofSize: 10, weight: .black)))!.withRenderingMode(.alwaysTemplate), for: .normal)
            addDeleteButton.backgroundColor = .white
            addDeleteButton.tintColor = Colors.lightRed
        } else {
            addDeleteButton.setImage(SFSymbols.plus.applyingSymbolConfiguration(.init(font: .systemFont(ofSize: 10, weight: .black)))!.withRenderingMode(.alwaysTemplate), for: .normal)
            addDeleteButton.backgroundColor = Colors.lightRed
            addDeleteButton.tintColor = .white
        }
    }
    
    func removeImageFor(buttonTag: Int, user: User?) {
        guard let user = user else { return }
        var imageUrls = user.imageUrls
        imageUrls!["\(buttonTag)"] = nil
        
        Firestore.firestore().collection(Firebase.users).document(user.uid).updateData(["imageUrls": imageUrls ?? ["": ""]]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
            self.imageView.image = nil
            self.changeButtonTo(delete: false)
        }
    }
}
