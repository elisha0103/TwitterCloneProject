//
//  Notification.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/07/17.
//

import Foundation

enum NotificationType: Int {
    case none
    case follow
    case like
    case reply
    case retweet
    case mention
}

struct Notification {
    let tweetID: String? // tweet like or retweet or reply
    var timestamp: Date // Notification timestamp
    let user: User // 알림 보낸 User 정보
    var tweet: Tweet?  // Tweet like or retweet or reply
    var type: NotificationType?
    
    init(user: User, dictionary: [String: AnyObject]) {
        self.user = user
        
        self.tweetID = dictionary["tweetID"] as? String ?? ""
        
        let timestamp = dictionary["timestamp"] as? Double ?? 0
        self.timestamp = Date(timeIntervalSince1970: timestamp)
        
        let type = dictionary["type"] as? Int ?? 0
        self.type = NotificationType(rawValue: type)
    }
}
