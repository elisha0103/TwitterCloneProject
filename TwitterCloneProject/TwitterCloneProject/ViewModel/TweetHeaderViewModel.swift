//
//  TweetHeaderViewModel.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/07/12.
//

import UIKit

struct TweetHeaderViewModel {
    
    private let user: User
    
    var options: [ActionSheetOptions] {
        var results: [ActionSheetOptions] = []
        
        if user.isCurrentUser {
            results.append(.delete)
        } else {
            let followOption: ActionSheetOptions = user.isFollowed ? .unfollow(user) : .follow(user)
            
            results.append(followOption)
        }
        
        results.append(.report)
        results.append(.blockUser)
        
        return results
    }
            
    init(user: User) {
        self.user = user
    }
    
    // MARK: - Helpers
    func actionButtonImage(option: ActionSheetOptions) -> UIImage? {
        switch option {
        case .follow:
            return UIImage(systemName: "person.fill.checkmark")
        case .unfollow(_):
            return UIImage(systemName: "person.fill.xmark")
        case .report:
            return UIImage(systemName: "flag")
        case .delete:
            return UIImage(systemName: "trash")
        case .blockUser:
            return UIImage(systemName: "nosign")
        }
    }
}

enum ActionSheetOptions {
    case follow(User)
    case unfollow(User)
    case report
    case delete
    case blockUser
    
    var description: String {
        switch self {
        case .follow(let user):
            return "Follow @\(user.userName)"
        case .unfollow(let user):
            return "Unfollow @\(user.userName)"
        case .report:
            return "Report Tweet"
        case .delete:
            return "Delete Tweet"
        case .blockUser:
            return "Block User"
        }
    }
}
