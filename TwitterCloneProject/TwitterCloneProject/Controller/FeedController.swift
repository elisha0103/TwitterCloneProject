//
//  FeedController.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/06/16.
//

import UIKit
import SDWebImage

// UICollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
class FeedController: UICollectionViewController {
    
    // MARK: - Properties
    var user: User? {
        didSet {
            configureLeftBarButton()
        }
    }
    
    let tweetCellIdentifier = "TweetCell"
    
    var tweets: [Tweet] = [] {
        didSet { collectionView.reloadData() }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchTweets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        self.navigationController?.navigationBar.standardAppearance = appearance
//        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance

        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Selectors
    @objc func handleRefresh() {
        fetchSingleEventTweet()
        
    }
    
    @objc func handleLeftNavigationItemTapped() {
        guard let user = user else { return }
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - API
    func fetchSingleEventTweet() {
        collectionView.refreshControl?.beginRefreshing()
        TweetService.shared.refreshFetchTweets { tweets in
            self.tweets = tweets.sorted(by: { $0.timestamp ?? Date() > $1.timestamp ?? Date() })
            self.checkIfUserLikedTweets(self.tweets)
            self.collectionView.refreshControl?.endRefreshing()

        }
        
    }
    
    func fetchTweets() {
                collectionView.refreshControl?.beginRefreshing()
        TweetService.shared.fetchTweets { tweets in
            self.tweets = tweets.sorted(by: { $0.timestamp ?? Date() > $1.timestamp ?? Date() })
            self.checkIfUserLikedTweets(self.tweets)
                        self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    func checkIfUserLikedTweets(_ tweets: [Tweet]) {
        self.tweets.forEach { tweet in
            TweetService.shared.checkIfUserLikedTweet(tweet) { didLike in
                guard didLike == true else { return }
                if let index = self.tweets.firstIndex(where: { $0.tweetID == tweet.tweetID }) {
                    self.tweets[index].didLike = true
                }
            }
        }
        //        for (index, tweet) in tweets.enumerated() {
        //            TweetService.shared.checkIfUserLikedTweet(tweet) { didLike in
        //                guard didLike == true else { return }
        //
        //                self.tweets[index].didLike = true
        //            }
        //        }
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .systemBackground
        // collectionView에 사용할 수 있는 customCell 등록
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: tweetCellIdentifier)
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    func configureLeftBarButton() {
        guard let user = user else { return }
        
        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.layer.masksToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleLeftNavigationItemTapped))
        profileImageView.addGestureRecognizer(tap)
        profileImageView.isUserInteractionEnabled = true
        
        profileImageView.sd_setImage(with: user.profileImageUrl)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
}
