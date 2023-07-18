//
//  Tweet.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/06/27.
//

import Foundation

struct Tweet {
    let caption: String
    let tweetID: String
    var likes: Int
    var timestamp: Date?
    let retweetCount: Int
    let user: User
    var didLike = false
    var replyingTo: String?
    
    var isReply: Bool { return replyingTo != nil }
    
    init(tweetID: String, user: User, dictionary: [String: Any]) {
        self.tweetID = tweetID
        self.user = user
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.retweetCount = dictionary["retweets"] as? Int ?? 0
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        
        if let replyingTo = dictionary["replyingTo"] as? String {
            self.replyingTo = replyingTo
        }
    }
}
