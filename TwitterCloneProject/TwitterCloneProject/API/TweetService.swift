//
//  TweetService.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/06/27.
//

import Foundation
import Firebase

struct TweetService {
    static let shared = TweetService()
    
    // 트윗 게시
    func uploadTweet(caption: String, type: UploadTweetConfiguration, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values = ["uid": uid,
                      "timestamp": Date().timeIntervalSince1970,
                      "likes": 0,
                      "retweets": 0,
                      "caption": caption] as [String: Any]
        
        switch type {
        case .tweet:
            REF_TWEETS.childByAutoId().setValue(values) { error, ref in
                // 트윗 업로드 후 'user-tweet' 데이터 구조 업데이트
                guard let tweetID = ref.key else { return }
                REF_USER_TWEETS.child(uid).updateChildValues([tweetID: 1], withCompletionBlock: completion)
            }
            
        case .reply(let tweet):
            values["replyingTo"] = tweet.user.userName
            REF_TWEET_REPLIES.child(tweet.tweetID).childByAutoId()
                .updateChildValues(values) { err, ref in
                    guard let replyKey = ref.key else { return }
                    REF_USER_REPLIES.child(uid).updateChildValues([tweet.tweetID: replyKey], withCompletionBlock: completion)
                }
        }
    }
    
    // refreshHandler fetch Tweets
    func refreshFetchTweets(completion: @escaping([Tweet]) -> Void) {
        print("DEBUG: REFRESH FETCH")
        guard let currentuid = Auth.auth().currentUser?.uid else { return }
        REF_USER_FOLLOWING.child(currentuid).removeAllObservers()
        self.fetchTweets(completion: completion)
    }
    
    // 모든 트윗 fetch
    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        var tweets: [Tweet] = []
        guard let currentuid = Auth.auth().currentUser?.uid else { return }

        REF_USER_FOLLOWING.child(currentuid).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                // following 한 사람들 목록
                REF_USER_FOLLOWING.child(currentuid).observe(.childAdded) { snapshot in
                    let followinguid = snapshot.key

                    // following 한 사람들의 tweet 목록
                    REF_USER_TWEETS.child(followinguid).observe(.childAdded) { snapshot in
                        let tweetID = snapshot.key
                        self.fetchTweet(withTweetID: tweetID) { tweet in
                            tweets.append(tweet)
                            completion(tweets)
                        }
                    }
                }
            } else {
                completion(tweets)
            }
        }
        
        REF_USER_TWEETS.child(currentuid).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                REF_USER_TWEETS.child(currentuid).observe(.childAdded) { snapshot in
                    let tweetID = snapshot.key
                    self.fetchTweet(withTweetID: tweetID) { tweet in
                        tweets.append(tweet)
                        completion(tweets)
                    }
                }
            } else {
                completion(tweets)
            }
        }
        
        
        REF_USER_FOLLOWING.child(currentuid).observe(.childRemoved) { snapshot in
            let followinguid = snapshot.key
            
            tweets.forEach { tweet in
                if let index = tweets.firstIndex(where: { $0.user.uid == followinguid }) {
                    tweets.remove(at: index)
                }
            }
            
            completion(tweets)
        }
        
    }
    
    
    // 한 개의 트윗 fetch
    func fetchTweet(withTweetID tweetID: String, completion: @escaping(Tweet) -> Void) {
        REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(tweetID: tweetID, user: user, dictionary: dictionary)
                completion(tweet)
            }
        }
    }
    
    // 유저 트윗 fetch
    func fetchTweets(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var tweets: [Tweet] = []
        
        REF_USER_TWEETS.child(user.uid).observe(.childAdded) {snapshot in
            let tweetID = snapshot.key
            
            self.fetchTweet(withTweetID: tweetID) { tweet in
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    // User의 Replies 트윗 fetch
    func fetchReplies(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var replies: [Tweet] = []
        
        REF_USER_REPLIES.child(user.uid).observe(.childAdded) { snapshot in
            let tweetKey = snapshot.key // tweetID
            guard let replyKey = snapshot.value as? String else { return } // tweetID의 reply ID
            
            REF_TWEET_REPLIES.child(tweetKey).child(replyKey).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                
                UserService.shared.fetchUser(uid: uid) { user in
                    let reply = Tweet(tweetID: replyKey, user: user, dictionary: dictionary)
                    replies.append(reply)
                    completion(replies)
                }
            }
        }
    }
    
    // Replies 트윗 fetch
    func fetchReplies(forTweet tweet: Tweet, completion: @escaping([Tweet]) -> Void) {
        var tweets: [Tweet] = []
        
        REF_TWEET_REPLIES.child(tweet.tweetID).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetID = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(tweetID: tweetID, user: user, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    // 유저가 좋아요한 트윗 fetch
    func fetchLikes(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var tweets: [Tweet] = []
        
        REF_USER_LIKES.child(user.uid).observe(.childAdded) {snapshot in
            let tweetID = snapshot.key
            self.fetchTweet(withTweetID: tweetID) { likedTweet in
                var tweet = likedTweet
                tweet.didLike = true
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    // 트윗 삭제
    func deleteTweet(forTweet tweet: Tweet, completion: @escaping(DatabaseCompletion)) {
        REF_TWEETS.child(tweet.tweetID).removeValue { error, ref in
            REF_TWEET_REPLIES.child(tweet.tweetID).removeValue(completionBlock: completion)
        }
    }
    
    // 트윗 like 변경
    func likeTweet(tweet: Tweet, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
        
        REF_TWEETS.child(tweet.tweetID).child("likes").setValue(likes)
        
        if tweet.didLike {
            // unlike tweet
            REF_USER_LIKES.child(uid).child(tweet.tweetID).removeValue { error, ref in
                REF_TWEET_LIKES.child(tweet.tweetID).removeValue(completionBlock: completion)
            }
        } else {
            // like tweet
            REF_USER_LIKES.child(uid).updateChildValues([tweet.tweetID: 1]) { err, ref in
                REF_TWEET_LIKES.child(tweet.tweetID).updateChildValues([uid: 1], withCompletionBlock: completion)
            }
        }
    }
    
    // 좋아요 체크
    func checkIfUserLikedTweet(_ tweet: Tweet, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_LIKES.child(uid).child(tweet.tweetID).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
}
