//
//  LoginViewModel.swift
//  Paw_nder
//
//  Created by William Yeung on 4/28/21.
//

import UIKit
import Firebase

class LoginViewModel {
    var email = ""
    var password = ""
    
    var isFormValid: Bool {
        return email != "" && password != ""
    }
    
    var formButtonColor: UIColor {
        return isFormValid ? .black : .lightGray
    }
    
    func loginUser(completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
}
