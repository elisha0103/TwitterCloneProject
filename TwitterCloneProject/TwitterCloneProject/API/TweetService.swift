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
    
    func uploadTweet(caption: String, type: UploadTweetConfiguration, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["uid": uid,
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
            REF_TWEET_REPLIES.child(tweet.tweetID).childByAutoId()
                .updateChildValues(values, withCompletionBlock: completion)
        }
    }
    
    // 모든 트윗 fetch
    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        var tweets: [Tweet] = []
        
        REF_TWEETS.observe(.childAdded) { snapshot,_  in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetID = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(tweetID: tweetID, user: user, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    // 유저 트윗 fetch
    func fetchTweets(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var tweets: [Tweet] = []
        
        REF_USER_TWEETS.child(user.uid).observe(.childAdded) {snapshot in
            let tweetID = snapshot.key
            
            REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                
                UserService.shared.fetchUser(uid: uid) { user in
                    let tweet = Tweet(tweetID: tweetID, user: user, dictionary: dictionary)
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
        }
    }
    
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
}
