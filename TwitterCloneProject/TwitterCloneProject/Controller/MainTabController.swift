//
//  MainTabController.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/06/16.
//

import UIKit

class MainTabController: UITabBarController {

    // MARK: - Properties
    let actionButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(MainTabController.self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewControllers()
        configureUI()
    }
    
    // MARK: - Selectors
    @objc func actionButtonTapped() {
        print("123")
    }
    
    // MARK: - Helpers
    func configureUI() {
    
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
    }
    
    func configureViewControllers() {
        let feedController = FeedController()
        let feedNavigation: UINavigationController = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: feedController)
        
        let exploreController = ExploreController()
        let exploreNavigation: UINavigationController = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: exploreController)
        
        let notificationsController = NotificationsController()
        let notificationsNavigation: UINavigationController = templateNavigationController(image: UIImage(named: "like_unselected"), rootViewController: notificationsController)
        
        let conversationsController = ConversationsController()
        let conversationsNavigation: UINavigationController = templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: conversationsController)
        
        viewControllers = [feedNavigation, exploreNavigation, notificationsNavigation, conversationsNavigation]
        
    }
    
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let navigation: UINavigationController = UINavigationController(rootViewController: rootViewController)
        navigation.tabBarItem.image = image
//        navigation.navigationBar.barTintColor = .white
        
        return navigation
    }
}
