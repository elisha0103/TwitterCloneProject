//
//  FeedController+.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/06/30.
//

import UIKit

// MARK: - UICollectionViewDataSource

extension FeedController { // UICollectionViewDataSource methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tweetCellIdentifier, for: indexPath) as? TweetCell
        
        guard let cell = cell else { fatalError("cell Error") }
        cell.delegate = self
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}

// MARK: - TweetCellDelegate
extension FeedController: TweetCellDelegate {
    // Navigation Controll을 셀에서 할 수 없어서 셀로부터 데이터를 상위 뷰로 받아와 상위 뷰에서 Navigation Controll을 한다.
    func handleProfileImageTapped(_ cell: TweetCell) {
        let controller = ProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(controller, animated: true)
    }
}
