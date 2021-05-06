//
//  RegisterViewModel.swift
//  Paw_nder
//
//  Created by William Yeung on 4/22/21.
//

import UIKit
import Firebase


class RegisterViewModel {
    // MARK: - Properties
    var bindableImage = Bindable<UIImage>()
    var fullName = ""
    var email = ""
    var password = ""
    var gender: Gender? = nil
    
    var genderSelectionColor: (maleColor: UIColor, femaleColor: UIColor) {
        if gender == .male {
            return (lightBlue, .lightGray)
        } else {
            return (.lightGray, lightRed)
        }
    }
    
    var isFormValid: Bool {
        return gender != nil && fullName != "" && email != "" && password != ""
    }
    
    var formButtonColor: (bgColor: UIColor, textColor: UIColor) {
        return isFormValid ? (lightRed, .white) : (.lightGray, .gray)
    }
    
    // MARK: - Helpers
    func registerUser(completion: @escaping (Result<Bool, Error>) -> Void) {
        let credentials = Credentials(gender: gender?.rawValue ?? "", fullName: fullName, email: email, password: password, profileImage: bindableImage.value)
        FirebaseManager.shared.registerUser(credentials: credentials, completion: completion)
    }
}
