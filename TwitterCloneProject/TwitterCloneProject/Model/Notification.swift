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
    let user: User // 
    var tweet: Tweet?  // Tweet like or retweet or reply
    var type: NotificationType?
    
    init(user: User, tweet: Tweet?, dictionary: [String: AnyObject]) {
        self.user = user
        self.tweet = tweet
        
        self.tweetID = dictionary["tweetID"] as? String ?? ""
        
        let timestamp = dictionary["timestamp"] as? Double ?? 0
        self.timestamp = Date(timeIntervalSince1970: timestamp)
        
        let type = dictionary["type"] as? Int ?? 0
        self.type = NotificationType(rawValue: type)
    }
}
