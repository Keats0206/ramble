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
    
    @Published var users = [User2]()
            

//  Need to figure out how to get this to query firebase and give the same result, still using old Database
    func fetchUser(uid: String, completion: @escaping(User2) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let values = snapshot.value as? [String: AnyObject] else { return }
            let user = User2(uid: uid, values: values)
            completion(user)
        }
    }
    
        func fetchUser(user: User2) {
            print(user)
//            print(user.id)
//            print(user.uid)
//            let userRef = FB_REF_USERS.document(user.id!)
//
//            userRef.getDocument { (querySnapshot, error) in
//                if let querySnapshot = querySnapshot {
//                    let user = try? querySnapshot.data(as: User2.self)
//                    return completion(user!)
//                }
//            }
        }
    
    func fetchUsers() {
        FB_REF_USERS.addSnapshotListener { (querySnapshot, error) in // (2)
            if let querySnapshot = querySnapshot {
                self.users = querySnapshot.documents.compactMap { document -> User2? in // (3)
                    try? document.data(as: User2.self) // (4)
                }
            }
        }
    }
        
    func fetchUser(completion: @escaping([User]) -> Void) {
//        REF_USERS.observe(.childAdded) { snapshot in
//            let uid = snapshot.key
//            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
//            let user = User(uid: uid, values: dictionary)
//            self.users.append(user)
//            completion(self.users)
//            print(self.users)
//        }
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
