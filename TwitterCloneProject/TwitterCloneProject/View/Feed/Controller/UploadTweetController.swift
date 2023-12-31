//
//  UploadTweetController.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/06/27.
//

import UIKit
import ActiveLabel

class UploadTweetController: UIViewController, UITextViewDelegate {
    // MARK: - Properties
    private let user: User
    private let config: UploadTweetConfiguration // Tweet 등록, Reply 등록 ViewController 선택할 플래그 변수
    private lazy var uploadTweetViewModel = UploadTweetViewModel(config: config)
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        
        button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.setDimensions(width: 48, height: 48)
        imageView.layer.cornerRadius = 48 / 2
        
        return imageView
    }()
    
    private let replyLabel: ActiveLabel = {
       let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.mentionColor = .twitterBlue
        
        return label
    }()
    
    private let captionTextView = InputTextView()
    
    // MARK: - Lifecycle
    init(user: User, config: UploadTweetConfiguration) {
        self.user = user
        self.config = config
        
        super.init(nibName: nil, bundle: nil)
        self.captionTextView.delegate = self

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureMentionHandler()
        
        switch config {
        case .tweet:
            print("DEBUG: Config is tweet")
        case .reply(let tweet):
            print("DEBUG: Replying to \(tweet.caption)")
        }

    }
    
    // MARK: -  Selectors
    @objc func handleUploadTweet() {
        guard let caption = captionTextView.text else { return }
        
        TweetService.shared.uploadTweet(caption: caption, type: config) { error, ref in
            if let error = error {
                print("DEBUG: Failed to upload tweet with error \(error.localizedDescription)")
                return
            }
            
            if case .reply(let tweet) = self.config {
                NotificationService.shared.uploadNotification(toUser: tweet.user, type: .reply, tweetID: tweet.tweetID)
            }
            
            let tweetID = ref.key
            self.uploadMentionNotification(forCaption: caption, tweetID: tweetID)
            
            self.dismiss(animated: true)
        }
        
    }
    
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    
    // MARK: - API
    fileprivate func uploadMentionNotification(forCaption caption: String, tweetID: String?) {
        guard caption.contains("@") else { return }
        let words = caption.components(separatedBy: .whitespacesAndNewlines)
        
        words.forEach { word in
            guard word.hasPrefix("@") else { return }
            
            var userName = word.trimmingCharacters(in: .symbols)
            userName = userName.trimmingCharacters(in: .punctuationCharacters)
            
            UserService.shared.fetchUser(withUserName: userName) { mentiondUser in
                NotificationService.shared.uploadNotification(toUser: mentiondUser, type: .mention, tweetID: tweetID)
            }
        }
    }
        
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        
//        captionTextView.backgroundColor = .red
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        imageCaptionStack.axis = .horizontal
        imageCaptionStack.spacing = 12
        imageCaptionStack.alignment = .leading
        
        let stack = UIStackView(arrangedSubviews: [replyLabel, imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        profileImageView.sd_setImage(with: user.profileImageUrl)
        actionButton.setTitle(uploadTweetViewModel.actionButtonTitle, for: .normal)
        captionTextView.placeholderLabel.text = uploadTweetViewModel.placeholderText
        
        replyLabel.isHidden = !uploadTweetViewModel.shouldShowReplyLabel
        guard let replyText = uploadTweetViewModel.replyText else { return }
        replyLabel.text = replyText
        
    }
    
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
    
    func configureMentionHandler() {
        replyLabel.handleMentionTap { mention in
            print("DEBUG: Mentioned user is \(mention)")
        }
    }

    // MARK: - Helpers
    func textViewDidChange(_ textView: UITextView) {
        captionTextView.placeholderLabel.isHidden = !captionTextView.text.isEmpty
    }


}
