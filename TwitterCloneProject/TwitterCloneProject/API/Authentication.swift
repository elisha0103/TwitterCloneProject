//
//  Authentication.swift
//  TwitterCloneProject
//
//  Created by 진태영 on 2023/06/23.
//

import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let fullName: String
    let userName: String
    let profileImage: UIImage?
}

struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func registerUser(credentials: AuthCredentials, completion: @escaping(Error?, DatabaseReference) -> Void) {
        let email: String = credentials.email
        let password: String = credentials.password
        let fullName: String = credentials.fullName
        let userName: String = credentials.userName
        
        guard let imageData: Data = credentials.profileImage?.jpegData(compressionQuality: 0.3) else { return }
        
        let fileName = UUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(fileName)

        storageRef.putData(imageData) { meta, error in
            storageRef.downloadURL { url, error in
                guard let profileImageUrl = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if let error = error {
                        print("DEBUG: Error is: \(error.localizedDescription)")
                        return
                    }
                    guard let uid = result?.user.uid else { return }
                    
                    let values = ["email": email,
                                  "fullName": fullName,
                                  "userName": userName,
                                  "profileImageUrl": profileImageUrl]
                    
                    // 회원가입 후의 completion 핸들러를 registerUser 함수 호출부에서 작성
                    // UI 핸들을 위한 작업
                    REF_USERS.child(uid).setValue(values, withCompletionBlock: completion)
                }
            }
        }

    }
}
