//
//  ExploreController+.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/07/04.
//

import UIKit

extension ExploreController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: exploreCellIdentifier, for: indexPath) as? UserCell
        
        guard let cell = cell else { fatalError("Explore Cell Error")}
        
        cell.user = users[indexPath.row]
        
        return cell
    }
}
