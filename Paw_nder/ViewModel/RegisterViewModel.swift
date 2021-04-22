//
//  RegisterViewModel.swift
//  Paw_nder
//
//  Created by William Yeung on 4/22/21.
//

import Foundation

class RegisterViewModel {
    // MARK: - Properties
    var fullName = ""
    var email = ""
    var password = ""
    
    var isFormValid: Bool {
        return fullName != "" && email != "" && password != ""
    }
}
