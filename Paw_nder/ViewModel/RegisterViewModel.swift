//
//  RegisterViewModel.swift
//  Paw_nder
//
//  Created by William Yeung on 4/22/21.
//

import UIKit

class RegisterViewModel {
    // MARK: - Properties
    var bindableImage = Bindable<UIImage>()
    var fullName = ""
    var email = ""
    var password = ""
    
    var isFormValid: Bool {
        return fullName != "" && email != "" && password != ""
    }
}
