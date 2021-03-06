//
//  RecentMessage.swift
//  Paw_nder
//
//  Created by William Yeung on 5/11/21.
//

import Foundation
import Firebase


struct RecentMessage {
    // MARK: - Properties
    let otherUserId: String
    let name: String
    let profileImageUrl: String
    let message: String
    let timestamp: Timestamp
    let isRead: Bool
    let partner: User
    
    // MARK: - Init
    init(dictionary: [String: Any]) {
        self.otherUserId = dictionary["otherUserId"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.message = dictionary["message"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? .init()
        self.isRead = dictionary["isRead"] as? Bool ?? false
        self.partner = User(dictionary: dictionary["partner"] as? [String: Any] ?? ["": ""])
    }
}
