//
//  Match.swift
//  Paw_nder
//
//  Created by William Yeung on 5/9/21.
//

import Foundation

struct Match {
    let matchedUserId: String
    let name: String
    let imageUrlString: String
    let startedConversation: Bool
    
    init(dictionary: [String: Any]) {
        self.matchedUserId = dictionary["matchedUserId"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.imageUrlString = dictionary["imageUrlString"] as? String ?? ""
        self.startedConversation = dictionary["startedConversation"] as? Bool ?? false
    }
    
    init(recentMessage: RecentMessage) {
        self.matchedUserId = recentMessage.otherUserId
        self.name = recentMessage.name
        self.imageUrlString = recentMessage.profileImageUrl
        self.startedConversation = true
    }
}