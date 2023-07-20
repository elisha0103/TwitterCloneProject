//
//  ExploreController.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/06/16.
//

import UIKit

enum SearchControllerConfiguration {
    case message
    case userSearch
}

class SearchController: UITableViewController {

    // MARK: - Properties
    private let config: SearchControllerConfiguration
    
    let exploreCellIdentifier: String = "exploreCell"
    var users: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // 검색 결과 나타날 ViewController를 searchResultsController이라고 한다.
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    /*
     searchResultsController를 활용하지 않고, filterUsers와 isSearchMode 프로퍼티를 활용하여
     기존의 ExploreController에 검색 결과를 나타낼 것
     */
    
    var filterUsers: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var isSearchMode: Bool { // 검색모드일 경우, 검색 결과를 반환하도록 함
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }
    
    // MARK: - Lifecycle
    init(config: SearchControllerConfiguration) {
        self.config = config
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureSearchController()
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - API
    func fetchUsers() {
        UserService.shared.fetchUsers { users in
            users.forEach { user in
                self.users = users
            }
        }
    }
    
    // MARK: - Selectors
    @objc func handleDismissal() {
        dismiss(animated: true)
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = config == .message ? "New Message" : "Explore"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: exploreCellIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
        if config == .message {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismissal))
        }
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self // 서치바 delegate 설정(입력 텍스트 감지)
        searchController.obscuresBackgroundDuringPresentation = false // 서치바 활성화동안 배경 어두워지지 않게
        searchController.hidesNavigationBarDuringPresentation = false // 서치바 활성화동안 NavigationBar 사라지지 않게
        searchController.searchBar.placeholder = "Search for a user"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}
