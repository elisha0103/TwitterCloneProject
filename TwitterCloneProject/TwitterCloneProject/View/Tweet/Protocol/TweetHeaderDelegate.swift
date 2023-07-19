//
//  TweetHeaderDelegate.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/07/12.
//

import Foundation

protocol TweetHeaderDelegate: AnyObject {
    func handleInteractAction()
    func handleReportAction()
    func handleFetchUser(withUserName userName: String)
}
