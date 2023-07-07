//
//  ProfileController.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/06/30.
//

import UIKit



class ProfileController: UICollectionViewController {
    // MARK: - Properties
    var user: User
    
    var tweets: [Tweet] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let tweetCellIdentifier = "TweetCell"
    let headerIdentifier = "ProfileHeader"
    
    // MARK: - Lifecycle
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchTweets()
        checkIfUserIsFollowed()
        fetchUserStats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    // MARK: - API
    func fetchTweets() {
        TweetService.shared.fetchTweets(forUser: user) { tweets in
            self.tweets = tweets
        }
    }
    
    func checkIfUserIsFollowed() {
        UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData() // 초기 데이터에서 파베 데이터로 변경된 결과를 반영하기 위함
        }
    }
    
    func fetchUserStats() {
        UserService.shared.fetchUserState(uid: user.uid) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()
        }
    }

    // MARK: - Helpers
    func configureCollectionView() {
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInsetAdjustmentBehavior = .never // content의 safeArea offset 조정 여부
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: tweetCellIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
}
