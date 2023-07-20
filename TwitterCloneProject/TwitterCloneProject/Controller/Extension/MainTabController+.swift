//
//  MainTabController+.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/07/20.
//

import UIKit

extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let index = viewControllers?.firstIndex(of: viewController)
        let image = index == 3 ? UIImage(named: "mail") : UIImage(named: "new_tweet")
        self.actionButton.setImage(image, for: .normal)
        buttonConfig = index == 3 ? .message : .tweet
        
        
    }    
}
