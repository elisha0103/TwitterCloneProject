//
//  ConversationsController.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/06/16.
//

import UIKit

class ConversationsController: UIViewController {

    // MARK: - Properties
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        navigationItem.title = "Messages"
    }

}
