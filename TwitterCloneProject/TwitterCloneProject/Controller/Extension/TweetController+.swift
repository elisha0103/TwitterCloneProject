//
//  TweetController+.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/07/10.
//

import UIKit

// MARK: UICollectionViewDataSource
extension TweetController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return replies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? TweetCell
        
        guard let cell = cell else { fatalError("TweetController Cell Error") }
        cell.tweet = replies[indexPath.row]
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as? TweetHeader
        guard let header = header else { fatalError("TweetController Header Error") }
        header.tweet = tweet
        header.user = user
        header.delegate = self
        
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TweetController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        // 동적 사이즈: Cell 높이
        let viewModel = TweetViewModel(tweet: tweet)
        let captionHeight = viewModel.size(forWidth: view.frame.width).height
        
        return CGSize(width: view.frame.width, height: captionHeight + 260)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}
 
// MARK: - TweetHeaderDelegate
extension TweetController: TweetHeaderDelegate {
    func handleInteractAction() {
        
        
        if user.isCurrentUser {
            print("DEBUG: DELETE TWEET ACTION")
            navigationController?.popViewController(animated: true)
            TweetService.shared.deleteTweet(forTweet: tweet) { error, ref in
                self.navigationController?.popViewController(animated: true)
            }
        } else if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { error, ref in
                print("DEBUG: Did complete follow in backend...")
                self.user.isFollowed = false
                self.collectionView.reloadData()
            }
        } else {
            UserService.shared.followUser(uid: user.uid) { error, ref in
                print("DEBUG: Did unfollow user in backed...")
                self.user.isFollowed = true
                self.collectionView.reloadData()
            }
        }
    }
    
    func handleReportAction() {
        print("DEBUG: REPORT TWEET ACTION")
    }
    
    
}
