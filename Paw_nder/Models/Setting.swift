//
//  Setting.swift
//  Paw_nder
//
//  Created by William Yeung on 5/17/21.
//

import Foundation

enum SettingType: String {
    case name, breed, age, gender, bio, preference
}

struct Setting {
    let index: Int
    let title: SettingType
    var preview: String?
    let emoji: String
}
