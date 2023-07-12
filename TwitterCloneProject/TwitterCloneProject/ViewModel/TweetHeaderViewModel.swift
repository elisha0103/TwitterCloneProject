//
//  TweetHeaderViewModel.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/07/12.
//

import UIKit

struct TweetHeaderViewModel {
    
    private let user: User
    
    let userNameText: String
        
    var actionButtonTitle: String {
        // if user is current user then set to edit profile
        // else figure out following / not following
        if user.isCurrentUser {
            return "Delete Tweet"
        }
        
        return user.isFollowed ? "UnFollow @\(user.userName)" : "Follow @\(user.userName)"
        
    }
    
    var actionButtonImage: UIImage? {
        if user.isCurrentUser {

            return UIImage(systemName: "trash")
        }
        
        return user.isFollowed ? UIImage(systemName: "person.fill.xmark") : UIImage(systemName: "person.fill.checkmark")
    }
    
    init(user: User) {
        self.user = user
        self.userNameText = "@" + user.userName
    }
    
    func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: " \(text)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        return attributedTitle
    }
}
