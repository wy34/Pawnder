//
//  PawView.swift
//  Paw_nder
//
//  Created by William Yeung on 4/19/21.
//

import UIKit

class PawView: UIView {
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    init(bgColor: UIColor = .clear) {
        super.init(frame: .zero)
        self.backgroundColor = bgColor
    }
}
