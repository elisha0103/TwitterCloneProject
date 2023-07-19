//
//  EditProfileViewModel.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/07/19.
//

import Foundation

struct EditProfileViewModel {
    
    private let user: User
    let option: EditProfileOptions
    
    var titleText: String {
        return option.destription
    }
    
    var optionValue: String? {
        switch option {
        case .userName: return user.userName
        case .fullName: return user.fullName
        case .bio: return user.bio
        }
    }
    
    var shouldHideTextField: Bool {
        return option == .bio
    }
    
    var shouldHideTextView: Bool {
        return option != .bio
    }
    
    init(user: User, option: EditProfileOptions) {
        self.user = user
        self.option = option
    }
}
