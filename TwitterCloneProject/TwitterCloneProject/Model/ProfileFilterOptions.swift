//
//  ProfileFilterOptions.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/07/03.
//

import Foundation

enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
        case .tweets: return "Tweeets"
        case .replies: return "Tweets & Replies"
        case .likes: return "Likes"
        }
    }
}
