//
//  IconLabel.swift
//  Paw_nder
//
//  Created by William Yeung on 5/13/21.
//

import UIKit
import SwiftUI

class IconLabel: UIView {
    // MARK: - Properties
    var image: UIImage?
    var cornerRadius: CGFloat = 0
    
    var text: String? {
        didSet {
            guard let image = image, let text = text else { return }
            configureLabelWith(image: image, text: text, cornerRadius: cornerRadius)
        }
    }
    
    // MARK: - Views
    private let label = PaddedLabel(text: "", font: markerFont(16), padding: 6)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabelWith(image: SFSymbols.heart, text: "Insert some text")
        layouUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    init(text: String, image: UIImage, cornerRadius: CGFloat = 0) {
        super.init(frame: .zero)
        self.image = image
        self.cornerRadius = cornerRadius
        configureLabelWith(image: image, text: text, cornerRadius: cornerRadius)
        layouUI()
    }
    
    // MARK: - Helpers
    private func configureLabelWith(image: UIImage, text: String, cornerRadius: CGFloat = 0) {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image.withTintColor(.white)
        imageAttachment.bounds = CGRect(x: 0, y: -3, width: imageAttachment.image!.size.width * 0.7, height: imageAttachment.image!.size.height * 0.7)
        
        let completeText = NSMutableAttributedString(string: "")
        
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        completeText.append(attachmentString)
        let textAfterIcon = NSAttributedString(string: " " + text)
        completeText.append(textAfterIcon)
        
        label.textAlignment = .left
        label.backgroundColor = .lightGray
        label.layer.cornerRadius = cornerRadius
        label.clipsToBounds = true
        label.textColor = .white
        label.attributedText = completeText
    }
    
    private func layouUI() {
        addSubviews(label)
        label.fill(superView: self)
    }
}
