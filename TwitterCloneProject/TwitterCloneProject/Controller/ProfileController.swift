//
//  ProfileController.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/06/30.
//

import UIKit



class ProfileController: UICollectionViewController {
    // MARK: - Properties
    let user: User
    
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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
    }

    // MARK: - Helpers
    func configureCollectionView() {
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInsetAdjustmentBehavior = .never // content의 safeArea offset 조정 여부
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: tweetCellIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
}
