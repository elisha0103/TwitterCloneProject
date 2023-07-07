//
//  ExploreController+.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/07/04.
//

import UIKit

// MARK: - UITableViewDelegate
extension ExploreController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchMode ? filterUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: exploreCellIdentifier, for: indexPath) as? UserCell
        
        let user = isSearchMode ? filterUsers[indexPath.row] : users[indexPath.row]
        
        guard let cell = cell else { fatalError("Explore Cell Error")}
        
        cell.user = user
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = isSearchMode ? filterUsers[indexPath.row] : users[indexPath.row]
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension ExploreController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        // 검색 결과가 없는 경우, filterUsers 값이 변경되지 않으므로 검색 결과가 없다는 것을 나타내기 위해서 수동으로 reloadData 실행
        
        filterUsers = users.filter({ $0.userName.contains(searchText) })
    }
}
