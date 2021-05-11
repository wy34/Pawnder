//
//  Message.swift
//  Paw_nder
//
//  Created by William Yeung on 5/10/21.
//

import Foundation
import Firebase

struct Message {
    let senderId: String
    let toId: String
    let text: String
    let timestamp: Timestamp
    let isCurrentUser: Bool
    
    init(dictionary: [String: Any]) {
        self.senderId = dictionary["fromId"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp()
        self.isCurrentUser = Auth.auth().currentUser?.uid == self.senderId
    }
}
