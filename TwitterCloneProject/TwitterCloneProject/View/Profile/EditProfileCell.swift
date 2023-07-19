//
//  EditProfileCell.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/07/19.
//

import UIKit

class EditProfileCell: UITableViewCell {

    // MARK: - Properties
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - API
    
    // MARK: - Selectors
    
    // MARK: - Helpers

}
