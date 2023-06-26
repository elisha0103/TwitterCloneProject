//
//  User.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/06/26.
//

import Foundation

struct User {
    let fullName: String
    let email: String
    let userName: String
    let profileImageUrl: String?
    let uid: String
    
    init(uid: String, dictionary: [String: AnyObject]) {
        self.uid = uid
        
        self.fullName = dictionary["fullName"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.userName = dictionary["userName"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
    }
}
