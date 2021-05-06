//
//  Notification.Name.swift
//  Paw_nder
//
//  Created by William Yeung on 4/24/21.
//

import Foundation

extension Notification.Name {
    static let didOpenImagePicker = Notification.Name("didOpenImagePicker")
    static let didSelectPhoto = Notification.Name("didSelectPhoto")
    static let didSaveSettings = Notification.Name("didSaveSettings")
    static let didRegisterNewUser  = Notification.Name("didRegisterNewUser")
    static let didFetchUsers = Notification.Name("didFetchUsers")
    static let didLikedUser = Notification.Name("didLikedUser")
    static let didDragCard = Notification.Name("didDragCard")
    static let didFinishDraggingCard = Notification.Name("didFinishDraggingCard")
}
