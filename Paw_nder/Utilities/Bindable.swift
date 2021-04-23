//
//  Bindable.swift
//  Paw_nder
//
//  Created by William Yeung on 4/22/21.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> Void)?
    
    func bind(observer: @escaping (T?) -> Void) {
        self.observer = observer
    }
}
