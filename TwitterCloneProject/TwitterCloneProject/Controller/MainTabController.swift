//
//  MainTabController.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/06/16.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {

    // MARK: - Properties
    var user: User? {
        didSet {
            /*
             feedNavigation -> viewControllers의 첫 번째 UINavigationController(FeedController의 UINavigationController)
             nav.viewControllers -> UINavigation에는 여러 개의 ViewController가 들어갈 수 있는데,
             nav는 feedNavigation을 가리키고, feedNavigation의 rootViewController는 nav.viewControlers.first(FeedController) 임
             */
            guard let feedNavigation = viewControllers?[0] as? UINavigationController else { return }
            guard let feedController = feedNavigation.viewControllers.first as? FeedController else { return }
            
            feedController.user = user
        }
    }
    
    private lazy var actionButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .twitterBlue
        authenticateUserAndConfigureUI()
    }
    
    // MARK: - API
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
        }
        
    }
    
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let logInNavigation = UINavigationController(rootViewController: LoginController())
                logInNavigation.modalPresentationStyle = .fullScreen
                self.present(logInNavigation, animated: true)
            }
        } else {
            configureViewControllers()
            configureUI()
            fetchUser()
        }
    }
        
    // MARK: - Selectors
    @objc func actionButtonTapped() {
        guard let user = user else { return }
        let uploadTweetController = UploadTweetController(user: user, config: .tweet)
        let navigation = UINavigationController(rootViewController: uploadTweetController)
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true)
    }
    
    // MARK: - Helpers
    func configureUI() {
    
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
    }
    
    func configureViewControllers() {
        // feedController는 Controller 자체를 CollectionView 용도로만 사용하기 때문에 UICollectionViewController로 선언
        let feedController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
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
