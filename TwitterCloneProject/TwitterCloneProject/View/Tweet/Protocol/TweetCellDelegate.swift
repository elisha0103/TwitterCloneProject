//
//  TweetCellDelegate.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/07/20.
//

import Foundation

protocol TweetCellDelegate: AnyObject {
    func handleProfileImageTapped(_ cell: TweetCell)
    func handleReplyTapped(_ cell: TweetCell)
    func handleLikeTapped(_ cell: TweetCell)
    func handleFetchUser(withUserName userName: String)
}
