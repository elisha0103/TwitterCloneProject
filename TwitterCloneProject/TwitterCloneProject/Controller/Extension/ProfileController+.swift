//
//  ProfileController+.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/06/30.
//

import UIKit

// MARK: UICollectionViewDataSource
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tweetCellIdentifier, for: indexPath) as? TweetCell
        
        guard let cell = cell else { fatalError("cell Error") }
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
        
}

// MARK: - UICollectionViewDelegate
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as? ProfileHeader
        
        guard let header = header else { fatalError("header Error") }
        header.user = user
        header.delegate = self
        
        return header
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileController: UICollectionViewDelegateFlowLayout {
    // Header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    
    // Cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}

// MARK: - ProfileHeaderDelegate
extension ProfileController: ProfileHeaderDelegate {
    func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }
    
    func handleEditProfileFollow(_ header: ProfileHeader) {
        
        print("DEBUG: User is followed is \(user.isFollowed) before button tap")
        if user.isFollowed { // Unfollow 하는 로직
            UserService.shared.unfollowUser(uid: user.uid) { error, ref in
                print("DEBUG: Did complete follow in backend...")
                self.user.isFollowed = false
                self.collectionView.reloadData()
            }
        } else { // Follow 하는 로직
            UserService.shared.followUser(uid: user.uid) { error, ref in
                print("DEBUG: Did unfollow user in backed...")
                self.user.isFollowed = true
                self.collectionView.reloadData()
            }
        }
    }
}
