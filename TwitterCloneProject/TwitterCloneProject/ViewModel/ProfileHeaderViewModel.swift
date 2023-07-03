//
//  ProfileHeaderViewModel.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/07/03.
//

import UIKit

struct ProfileHeaderViewModel {
    
    private let user: User
    
    var followersString: NSAttributedString? {
        return attributedText(withValue: 0, text: "followers")
    }
    
    var followingString: NSAttributedString? {
        return attributedText(withValue: 2, text: "following")
    }
    
    var actionButtonTitle: String {
        // if user is current user then set to edit profile
        // else figure out following/not following
        if user.isCurrentUser {
            return "Edit Profile"
        } else {
            return "Follow"
        }
    }
    
    init(user: User) {
        self.user = user
    }
    
    func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: " \(text)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        return attributedTitle
    }
}
