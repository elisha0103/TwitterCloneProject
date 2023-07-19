//
//  EditProfileController.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/07/19.
//

import UIKit

protocol EditProfileControllerDelegate: AnyObject {
    func controller(_ controller: EditProfileController, wantsToUpdate user: User)
}

class EditProfileController: UITableViewController {

    // MARK: - Properties
    var user: User
    private lazy var headerView = EditProfileHeader(user: user)
    let imagePicker = UIImagePickerController()
    weak var delegate: EditProfileControllerDelegate?
    
    var isUserInfoChanged = false
    
    var isImageChanged: Bool {
        return selectedImage != nil
    }
    
    var selectedImage: UIImage? {
        didSet { headerView.profileImageView.image = selectedImage }
    }
    
    let reuseableIdentifier: String = "EditProfileTableViewCell"
    
    // MARK: - Lifecycle
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
        configureImagePicker()
    }
    
    // MARK: - API
    func updateUserData() {
        if isImageChanged && !isUserInfoChanged {
            updateProfileImage()
        }
        
        if isUserInfoChanged && !isImageChanged {
            UserService.shared.saveUserData(user: user) { err, ref in
                print("DEBUG: Did update user info..")
                
                self.delegate?.controller(self, wantsToUpdate: self.user)
            }
        }
        
        if isUserInfoChanged && isImageChanged {
            UserService.shared.saveUserData(user: user) { err, err in
                self.updateProfileImage()
            }
        }
    }
    
    func updateProfileImage() {
        guard let image = selectedImage else { return }
        
        UserService.shared.updateProfileImage(image: image) { profileImageUrl in
            UserService.shared.deleteProfileImage(profileUrl: self.user.profileImageUrl) { error in
                if let error {
                    print("DEBUG: PROFILEIAMGE DELETE ERROR - \(String(describing: error.localizedDescription))")
                }
                self.user.profileImageUrl = profileImageUrl
                self.delegate?.controller(self, wantsToUpdate: self.user)
            }
        }
    }
    
    // MARK: - Selectors
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc func handleDone() {
        view.endEditing(true)
        guard isImageChanged || isUserInfoChanged else { return }
        updateUserData()
    }
        
    // MARK: - Helpers
    func configureNavigationBar() {
//        let appearance = UINavigationBarAppearance()
//                appearance.configureWithOpaqueBackground()
//                appearance.backgroundColor = .twitterBlue
//
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//        self.navigationController?.navigationBar.standardAppearance = appearance
//        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
//        self.navigationController?.navigationBar.barStyle = .black

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .black
                navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .twitterBlue
        navigationController?.navigationBar.tintColor = .white
                
        navigationItem.title = "Edit Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
    }
    
    func configureTableView() {
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        tableView.tableFooterView = UIView()
        headerView.delegate = self
        
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: reuseableIdentifier)
        
    }

    func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
}
