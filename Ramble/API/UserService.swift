//
//  UserService.swift
//  Ramble
//
//  Created by Peter Keating on 6/8/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//
//
//import Foundation
//import SwiftUI
//import Firebase

//class UserService: ObservableObject {
//    static let shared = UserService()
//    @Published var users = [User]()
//
//    func fetchUser(uid: String, completion: @escaping(User) -> Void) {
//        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
//            guard let values = snapshot.value as? [String: AnyObject] else { return }
//            let user = User(uid: uid, values: values)
//            completion(user)
//        }
//    }
//
//    func fetchUsers() {
//        REF_USERS.observe(.childAdded) { snapshot in
//            let uid = snapshot.key
//            guard let values = snapshot.value as? [String: AnyObject] else { return }
//            let user = User(uid: uid, values: values)
//            self.users.append(user)
//            print("Observed this many users \(self.users.count)")
//        }
//    }
//
//    func fetchUser(completion: @escaping([User]) -> Void) {
//        REF_USERS.observe(.childAdded) { snapshot in
//            let uid = snapshot.key
//            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
//            let user = User(uid: uid, values: dictionary)
//            self.users.append(user)
//            completion(self.users)
//            print(self.users)
//        }
//    }
//
//    func followUser(uid: String) {
//        guard let currentUid = Auth.auth().currentUser?.uid else { return }
//
//        REF_USER_FOLLOWING.child(currentUid).updateChildValues([uid: 1]) { (err, ref) in
//            REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUid: 1])
//        }
//    }
//
//    func unfollowUser(uid: String) {
//        guard let currentUid = Auth.auth().currentUser?.uid else { return }
//
//        REF_USER_FOLLOWING.child(currentUid).child(uid).removeValue { (err, ref) in
//            REF_USER_FOLLOWERS.child(uid).child(currentUid).removeValue()
//        }
//    }
//
//    func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void) {
//        guard let currentUid = Auth.auth().currentUser?.uid else { return }
//
//        REF_USER_FOLLOWING.child(currentUid).child(uid).observeSingleEvent(of: .value) { snapshot in
//            completion(snapshot.exists())
//        }
//    }
//}
