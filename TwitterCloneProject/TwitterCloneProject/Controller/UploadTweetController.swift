//
//  UploadTweetController.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/06/27.
//

import UIKit

class UploadTweetController: UIViewController {
    // MARK: - Properties
    private let user: User
    
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
    
    // MARK: - Lifecycle
    init(user: User) {
        self.user = user
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        

    }
    // MARK: -  Selectors
    @objc func handleUploadTweet() {
        print("DEBUG: Upload tweet here")
        
    }
    
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    
    // MARK: - API
    
    // MARK: - Helpers
    func configureUI() {
        configureNavigationBar()
        view.backgroundColor = .white
        view.addSubview(profileImageView)
        profileImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, paddingTop: 16, paddingLeft: 16)
        profileImageView.sd_setImage(with: user.profileImageUrl)
    }
    
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }


}
