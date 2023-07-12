//
//  ActionSheetViewModel.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/07/12.
//

import Foundation

struct ActionSheetViewModel {
    
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
        
        return results
    }
    
    init(user: User) {
        self.user = user
    }
}
