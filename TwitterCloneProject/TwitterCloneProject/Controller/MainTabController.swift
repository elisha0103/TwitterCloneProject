//
//  MainTabController.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/06/16.
//

import UIKit

class MainTabController: UITabBarController {

    // MARK: - Properties
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewControllers()
    }
    
    // MARK: - Helpers
    func configureViewControllers() {
        let feedController = FeedController()
        let feedNavigation: UINavigationController = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: feedController)
        
        let exploreController = ExploreController()
        let exploreNavigation: UINavigationController = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: exploreController)
        
        let notificationsController = NotificationsController()
        let notificationsNavigation: UINavigationController = templateNavigationController(image: UIImage(named: "like_unselected"), rootViewController: notificationsController)
        
        let conversationsController = ConversationsController()
        let conversationsNavigation: UINavigationController = templateNavigationController(image: UIImage(named: "mail"), rootViewController: conversationsController)
        
        viewControllers = [feedNavigation, exploreNavigation, notificationsNavigation, conversationsNavigation]
        
    }
    
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let navigation: UINavigationController = UINavigationController(rootViewController: rootViewController)
        navigation.tabBarItem.image = image
//        navigation.navigationBar.barTintColor = .white
        
        return navigation
    }
}
