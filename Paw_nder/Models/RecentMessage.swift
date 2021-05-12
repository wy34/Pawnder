//
//  RecentMessage.swift
//  Paw_nder
//
//  Created by William Yeung on 5/11/21.
//

import Foundation
import Firebase


struct RecentMessage {
    let otherUserId: String
    let name: String
    let profileImageUrl: String
    let message: String
    let timestamp: Timestamp
    
    init(dictionary: [String: Any]) {
        self.otherUserId = dictionary["otherUserId"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.message = dictionary["message"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? .init()
    }
}
