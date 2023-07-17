//
//  NotificationController+.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/07/17.
//

import UIKit

extension NotificationsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? NotificationCell
        guard let cell = cell else { fatalError("Notification Cell Error") }
        
        cell.notification = notifications[indexPath.row]
        
        return cell
    }
}
