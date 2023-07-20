//
//  ProfileController+.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/06/30.
//

import UIKit
import Firebase

// MARK: UICollectionViewDataSource
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentDataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tweetCellIdentifier, for: indexPath) as? TweetCell
        
        guard let cell = cell else { fatalError("cell Error") }
        cell.tweet = currentDataSource[indexPath.row]
        cell.delegate = self
        
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tweet = currentDataSource[indexPath.row]
        let controller = TweetController(tweet: tweet, user: tweet.user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileController: UICollectionViewDelegateFlowLayout {
    // Header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        var height: CGFloat = 300
        
        if !user.bio.isEmpty {
            height += 50
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    // Cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 동적 사이즈: Cell 높이
        let viewModel = TweetViewModel(tweet: currentDataSource[indexPath.row])
        var height = viewModel.size(forWidth: view.frame.width).height + 72
        
        if currentDataSource[indexPath.row].isReply {
            height += 20
        }
        return CGSize(width: view.frame.width, height: height)
    }
}

// MARK: - ProfileHeaderDelegate
extension ProfileController: ProfileHeaderDelegate {
    func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }
    
    func handleEditProfileFollow(_ header: ProfileHeader) {
        
        if user.isCurrentUser {
            let controller = EditProfileController(user: user)
            controller.delegate = self
            let navigation = UINavigationController(rootViewController: controller)
            navigation.modalPresentationStyle = .formSheet
            present(navigation, animated: true)
            
            return
        }
        
        // 본인 계정이 아닌경우
        if user.isFollowed { // Unfollow 하는 로직
            UserService.shared.unfollowUser(uid: user.uid) { error, ref in
                self.user.isFollowed = false
                self.collectionView.reloadData()
            }
        } else { // Follow 하는 로직
            UserService.shared.followUser(uid: user.uid) { error, ref in
                self.user.isFollowed = true
                self.collectionView.reloadData()
                
                NotificationService.shared.uploadNotification(toUser: self.user, type: .follow)
            }
        }
    }
    
    func didSelect(filter: ProfileFilterOptions) {
        self.selectedFilter = filter
    }
}

// MARK: - EditProfileControllerDelegate
extension ProfileController: EditProfileControllerDelegate {
    func controller(_ controller: EditProfileController, wantsToUpdate user: User) {
        controller.dismiss(animated: true)
        self.user = user
        self.collectionView.reloadData()
    }
    
    func handleLogout() {
        do {
            try Auth.auth().signOut()
            let logInNavigation = UINavigationController(rootViewController: LoginController())
            logInNavigation.modalPresentationStyle = .fullScreen
            self.present(logInNavigation, animated: true)

        } catch let error {
            print("DEBUG: SignOut error - \(error.localizedDescription)")
        }
        
    }
}

extension ProfileController: TweetCellDelegate {
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
    
    func handleFetchUser(withUserName userName: String) {
        UserService.shared.fetchUser(withUserName: userName) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
