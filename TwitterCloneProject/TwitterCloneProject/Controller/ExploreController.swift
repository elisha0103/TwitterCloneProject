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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
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
