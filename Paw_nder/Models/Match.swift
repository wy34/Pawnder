//
//  Match.swift
//  Paw_nder
//
//  Created by William Yeung on 5/9/21.
//

import Foundation

struct Match {
    let name: String
    let imageUrlString: String
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.imageUrlString = dictionary["imageUrlString"] as? String ?? ""
    }
}
