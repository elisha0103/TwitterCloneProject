//
//  ActionSheetLauncher.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/07/12.
//

import UIKit

class ActionSheetLauncher: NSObject {
    
    // MARK: - Properties
    private let user: User
    private let tableView = UITableView()
    let tableViewCellIdentifier: String = "TableViewCell"
    private var window: UIWindow?
    
    init(user: User) {
        self.user = user
        super.init()
    }
    
    // MARK: - Helpers
    func show() {
        print("DEBUG: Show action sheet for user \(user.userName)")
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return }
        
        self.window = window
        window.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: window.frame.height - 300, width: window.frame.width, height: 300)
    }
    
    func configureTableView() {
        tableView.backgroundColor = .red
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 40
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
    }
}
