//
//  ExploreController.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/06/16.
//

import UIKit

class ExploreController: UITableViewController {

    // MARK: - Properties
    let exploreCellIdentifier: String = "exploreCell"
    var users: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        fetchUsers()
    }
    
    // MARK: - API
    func fetchUsers() {
        UserService.shared.fetchUsers { users in
            users.forEach { user in
                self.users = users
            }
        }
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Explore"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: exploreCellIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }
}
