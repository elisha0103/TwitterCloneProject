//
//  TweetController.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/07/10.
//

import UIKit

class TweetController: UICollectionViewController {

    // MARK: - Properties
    let tweet: Tweet
    let reuseIdentifier = "TweetCell"
    let headerIdentifier = "TweetHeader"
    var replies: [Tweet] = [] {
        didSet { collectionView.reloadData() }
    }
    
    // MARK: - Lifecycle
    init(tweet: Tweet) {
        self.tweet = tweet
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchReplies()
    }
    
    // MARK: - API
    func fetchReplies() {
        TweetService.shared.fetchReplies(forTweet: tweet) { tweets in
            self.replies = tweets
        }
    }
    
    // MARK: - Helpers
    func configureCollectionView() {
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

}
