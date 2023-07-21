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
        cell.delegate = self
        
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tweet = replies[indexPath.row]
        let controller = TweetController(tweet: tweet, user: tweet.user)
        navigationController?.pushViewController(controller, animated: true)
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
    func handleProfileImageTapped(_ header: TweetHeader) {
        guard let user = header.tweet?.user else { return }
        
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleReplyTapped(_ header: TweetHeader) {
        guard let tweet = header.tweet else { return }
        guard let currentUser = currentUser else { return }
        
        let controller = UploadTweetController(user: currentUser, config: .reply(tweet))
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
        
    }
    
    func handleLikeTapped(_ header: TweetHeader) {
        guard let tweet = header.tweet else { return }
        
        TweetService.shared.likeTweet(tweet: tweet) { err, ref in
            header.tweet?.didLike.toggle()
            let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
            header.tweet?.likes = likes
            
            // only upload notification if tweet6 is being liked
            guard !tweet.didLike else { return } // didLike == true 통과
            
            NotificationService.shared.uploadNotification(toUser: tweet.user, type: .like, tweetID: tweet.tweetID)
            
            
        }
    }

    func handleFetchUser(withUserName userName: String) {
        UserService.shared.fetchUser(withUserName: userName) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    
    func handleInteractAction() {
        if user.isCurrentUser {
            navigationController?.popViewController(animated: true)
            TweetService.shared.deleteTweet(forTweet: tweet) { error, ref in
                self.navigationController?.popViewController(animated: true)
            }
        } else if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { error, ref in
                self.user.isFollowed = false
                self.collectionView.reloadData()
            }
        } else {
            UserService.shared.followUser(uid: user.uid) { error, ref in
                self.user.isFollowed = true
                self.collectionView.reloadData()
            }
        }
    }
    
    func handleReportAction() {
        print("DEBUG: REPORT TWEET ACTION")
    }
    
}

extension TweetController: TweetCellDelegate {
    // Navigation Controll을 셀에서 할 수 없어서 셀로부터 데이터를 상위 뷰로 받아와 상위 뷰에서 Navigation Controll을 한다.
    func handleProfileImageTapped(_ cell: TweetCell) {
        guard let user = cell.tweet?.user else { return }
        
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleReplyTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        guard let currentUser = currentUser else { return }
        let controller = UploadTweetController(user: currentUser, config: .reply(tweet))
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    func handleLikeTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        
        TweetService.shared.likeTweet(tweet: tweet) { err, ref in
            cell.tweet?.didLike.toggle()
            let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
            cell.tweet?.likes = likes
            
            // only upload notification if tweet6 is being liked
            guard !tweet.didLike else { return } // didLike == true 통과
            
            NotificationService.shared.uploadNotification(toUser: tweet.user, type: .like, tweetID: tweet.tweetID)

        }
    }
}
