//
//  ProfileHeaderDelegate.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/07/03.
//

import Foundation

protocol ProfileHeaderDelegate: AnyObject {
    func handleDismissal()
    func handleEditProfileFollow(_ header: ProfileHeader)
    func didSelect(filter: ProfileFilterOptions)
}
