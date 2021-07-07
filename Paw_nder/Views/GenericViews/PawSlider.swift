//
//  PawSlider.swift
//  Paw_nder
//
//  Created by William Yeung on 4/27/21.
//

import UIKit

class PawSlider: UISlider {
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    init(starting: Float, min: Float, max: Float, tintColor: UIColor = Colors.lightRed) {
        super.init(frame: .zero)
        self.value = starting
        self.minimumValue = min
        self.maximumValue = max
        self.tintColor = tintColor
    }
}
