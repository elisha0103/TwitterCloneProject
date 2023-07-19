//
//  EditProfileOptions.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/07/19.
//

import Foundation

enum EditProfileOptions: Int, CaseIterable {
    case fullName
    case userName
    case bio
    
    var destription: String {
        switch self {
        case .userName: return "UserName"
        case .fullName: return "Name"
        case .bio: return "Bio"
        }
    }
}
