//
//  Constants.swift
//  Paw_nder
//
//  Created by William Yeung on 4/19/21.
//

import UIKit

// MARK: - Asset Images
struct Assets {
    static let icon = #imageLiteral(resourceName: "icon")
    static let tabMessage = #imageLiteral(resourceName: "bubble")
    static let crying = #imageLiteral(resourceName: "crying")
    static let dismiss = #imageLiteral(resourceName: "dismiss")
    static let female = #imageLiteral(resourceName: "female")
    static let filter = #imageLiteral(resourceName: "filter")
    static let house = #imageLiteral(resourceName: "house")
    static let launchBG = #imageLiteral(resourceName: "launchScreenBG")
    static let male = #imageLiteral(resourceName: "male")
    static let tabPaw = #imageLiteral(resourceName: "paw")
    static let placeholderPaw = #imageLiteral(resourceName: "pawPrint")
    static let location = #imageLiteral(resourceName: "pin")
    static let placeholderProfile = #imageLiteral(resourceName: "profile")
    static let refresh = #imageLiteral(resourceName: "refresh")
    static let tabThumb = #imageLiteral(resourceName: "thumb")
    static let tabUser = #imageLiteral(resourceName: "user")
}

// MARK: - SF Symbols
struct SFSymbols {
    static let person = UIImage(systemName: "person")!
    static let envelope = UIImage(systemName: "envelope")!
    static let lock = UIImage(systemName: "lock")!
    static let info = UIImage(systemName: "info.circle")!
    static let downArrow = UIImage(systemName: "arrow.down")!
    static let xmark = UIImage(systemName: "xmark")!
    static let photos = UIImage(systemName: "photo.fill.on.rectangle.fill")!
    static let chat = UIImage(systemName: "message")!
    static let checkmark = UIImage(systemName: "checkmark")!
    static let heart = UIImage(systemName: "heart")!
    static let rightArrow = UIImage(systemName: "arrow.right")!
    static let chevronLeft = UIImage(systemName: "chevron.left")!
    static let chevronRight = UIImage(systemName: "chevron.right")!
    static let ellipsis = UIImage(systemName: "ellipsis")!
    static let paperplane = UIImage(systemName: "paperplane")!
    static let gears = UIImage(systemName: "gearshape")!
    static let plus = UIImage(systemName: "plus")!
    static let saveCloud = UIImage(systemName: "icloud.and.arrow.up")!
    static let infoNoCircle = UIImage(systemName: "info")!
}

// MARK: - Colors
struct Colors {
    static let bgWhite = #colorLiteral(red: 0.9968960881, green: 0.9921532273, blue: 1, alpha: 1)
    static let bgLightGray = #colorLiteral(red: 0.9541934133, green: 0.9496539235, blue: 0.9577021003, alpha: 1)
    static let lightGray = #colorLiteral(red: 0.8566066027, green: 0.8525324464, blue: 0.8597565293, alpha: 1)
    static let lightOrange = #colorLiteral(red: 1, green: 0.5036935806, blue: 0.3973088861, alpha: 1)
    static let lightRed = #colorLiteral(red: 1, green: 0.3450980392, blue: 0.3921568627, alpha: 1)
    static let lightBlue = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
    static let lightTransparentGray = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.247749856)
    static let mediumTransparentGray = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5028261809)
    static let darkTransparentGray = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7460937501)
    static let lightPink = #colorLiteral(red: 1, green: 0.6349166036, blue: 1, alpha: 1)
}

// MARK: - Firestore Collections
struct Firebase {
    static let users = "users"
    static let matches_messages = "matches_messages"
    static let recentMessages = "recent_messages"
    static let matches = "matches"
    static let swipes = "swipes"
    static let usersWhoLikedMe = "usersWhoLikedMe"
}

// MARK: - Notification UserInfo key
let buttonTag = "tappedButtonTag"

// MARK: - No Breed Preference
let noBreedCaption = "No Breed"
let noBreedPrefCaption = "🐶 No Preference"

// MARK: - Max Distance
let maxDistance = 150


