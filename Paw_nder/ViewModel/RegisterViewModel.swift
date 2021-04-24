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
    
    var isFormValid: Bool {
        return fullName != "" && email != "" && password != ""
    }
    
    // MARK: - Helpers
    func registerUser(completion: @escaping (Result<Bool, Error>) -> Void) {
        let credentials = Credentials(fullName: fullName, email: email, password: password, profileImage: bindableImage.value)
        FirebaseManager.shared.registerUser(credentials: credentials, completion: completion)
    }
}
