//
//  Date.swift
//  Paw_nder
//
//  Created by William Yeung on 5/11/21.
//

import Foundation

extension Date {
    func stringValue(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
