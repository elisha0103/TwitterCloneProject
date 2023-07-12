//
//  ActionSheetLauncher+.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/07/12.
//

import UIKit

// MARK: - UITableViewDataSource
extension ActionSheetLauncher: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath)
        
        return cell
    }
    
    
}

// MARK: - UITableViewDelegate
extension ActionSheetLauncher: UITableViewDelegate {
    
}

