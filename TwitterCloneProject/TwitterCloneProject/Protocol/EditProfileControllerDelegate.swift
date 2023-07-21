//
//  EditProfileControllerDelegate.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/07/21.
//

import Foundation

protocol EditProfileControllerDelegate: AnyObject {
    func controller(_ controller: EditProfileController, wantsToUpdate user: User)
    func handleLogout()
}
