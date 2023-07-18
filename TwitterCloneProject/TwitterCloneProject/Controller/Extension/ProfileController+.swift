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
        return currentDataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tweetCellIdentifier, for: indexPath) as? TweetCell
        
        guard let cell = cell else { fatalError("cell Error") }
        cell.tweet = currentDataSource[indexPath.row]
        
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
        
        // 동적 사이즈: Cell 높이
        let viewModel = TweetViewModel(tweet: currentDataSource[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width).height
        
        return CGSize(width: view.frame.width, height: height + 72)
    }
}

// MARK: - ProfileHeaderDelegate
extension ProfileController: ProfileHeaderDelegate {
    func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }
    
    func handleEditProfileFollow(_ header: ProfileHeader) {
        
        if user.isCurrentUser {
            print("DEBUG: Show edit profile controller")
            return
        }
        
        // 본인 계정이 아닌경우
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
                
                NotificationService.shared.uploadNotification(type: .follow, user: self.user)
            }
        }
    }
    
    func didSelect(filter: ProfileFilterOptions) {
        self.selectedFilter = filter
    }
}
