//
//  TweetViewModel.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/06/30.
//

import UIKit

struct TweetViewModel {
    let tweet: Tweet
    let user: User
    
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    var timeStamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        
        return formatter.string(from: tweet.timestamp ?? now, to: now) ?? "-1"
    }
    
    var userNameText: String {
        return "@\(user.userName)"
    }
    
    var headerTimeStamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd ・ a h:mm"
        
        return formatter.string(from: tweet.timestamp ?? Date())
    }
    
    var retweetsAttributedString: NSAttributedString? {
        return attributedText(withValue: tweet.retweetCount, text: "Retweets")
    }
    
    var likesAttributedString: NSAttributedString? {
        return attributedText(withValue: tweet.likes, text: "Likes")
    }
        
    var userInfoText: NSAttributedString {
        let title = NSMutableAttributedString(string: user.fullName, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        title.append(NSAttributedString(string: " @\(user.userName)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        title.append(NSAttributedString(string: " ・ \(timeStamp)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        return title
    }
    
    var likeButtonTintColor: UIColor {
        return tweet.didLike ? .red : .lightGray
    }
    
    var likeButtonImage: UIImage? {
        let imageName = tweet.didLike ? "like_filled" : "like"
        return UIImage(named: imageName)
    }

    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
    
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedTitle.append(NSAttributedString(string: "\(text)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        return attributedTitle
    }
    
    // Dynamic content size(about height)
    func size(forWidth width: CGFloat) -> CGSize {
        let measurementLabel = UILabel()    // 임시 UILabel 생성하여 보이지는 않지만 해당 UILabel을 바탕으로 사이즈 구하기
        measurementLabel.text = tweet.caption
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping // 줄바꿈 속성 - 줄바꿈할 때 단어를 다음줄로
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false// autolayout을 사용하면 automask는 비활성화
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        // UIView.layoutFittingExpanded: 가능한 큰 사이즈
        // UIView.layoutFittingCompressedSize: 가능한 작은 사이즈
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
