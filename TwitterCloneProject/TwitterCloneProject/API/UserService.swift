//
//  UserService.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/06/26.
//

import Foundation
import Firebase

struct UserService {
    static let shared = UserService()
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                        
            let user = User(uid: uid, dictionary: dictionary)
            
            print("DEBUG: userName is \(user.userName)")
            print("DEBUG: fullName is \(user.fullName)")
        }
    }
}
