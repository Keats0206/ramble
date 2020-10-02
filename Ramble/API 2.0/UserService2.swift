//
//  UserService2.swift
//  Ramble
//
//  Created by Peter Keating on 10/1/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//
import SwiftUI
import Firebase
import Combine

class UserService2: ObservableObject {
    static let shared = UserService2()
    
    @Published var users = [User]()
            
    func fetchUser(user: User, completion: @escaping(User) -> Void) {
        let userRef = FB_REF_USERS.document(user.id!)

        userRef.getDocument { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                let user = try? querySnapshot.data(as: User.self)
                completion(user!)
            }
        }
    }
    
    func fetchUsers() {
        FB_REF_USERS.addSnapshotListener { (querySnapshot, error) in // (2)
            if let querySnapshot = querySnapshot {
                self.users = querySnapshot.documents.compactMap { document -> User? in // (3)
                    try? document.data(as: User.self) // (4)
                }
            }
        }
    }
        
    func followUser(uid: String) {
//        guard let currentUid = Auth.auth().currentUser?.uid else { return }
//
//        REF_USER_FOLLOWING.child(currentUid).updateChildValues([uid: 1]) { (err, ref) in
//            REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUid: 1])
//        }
    }
    
    func unfollowUser(uid: String) {
//        guard let currentUid = Auth.auth().currentUser?.uid else { return }
//
//        REF_USER_FOLLOWING.child(currentUid).child(uid).removeValue { (err, ref) in
//            REF_USER_FOLLOWERS.child(uid).child(currentUid).removeValue()
//        }
    }
    
//    func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void) {
//        guard let currentUid = Auth.auth().currentUser?.uid else { return }
//
//        REF_USER_FOLLOWING.child(currentUid).child(uid).observeSingleEvent(of: .value) { snapshot in
//            completion(snapshot.exists())
//        }
//    }
}
