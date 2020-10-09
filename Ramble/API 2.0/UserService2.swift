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
            
    func fetchUser(uid: String, completion: @escaping(User) -> Void) {
        let userRef = FB_REF_USERS.document(uid)

        userRef.getDocument { (document, error) in
            let result = Result {
              try document?.data(as: User.self)
            }
            switch result {
            case .success(let user):
                if let user = user {
                    completion(user)
                } else {
                    print("DEBUG: Document does not exist")
                }
            case .failure(let error):
                print("DEBUG: Error decoding user: \(error)")
            }
        }
    }
    
    func fetchUsers() {
//        FB_REF_USERS.addSnapshotListener { (querySnapshot, error) in // (2)
//            if let querySnapshot = querySnapshot {
//                self.users = querySnapshot.documents.compactMap { document -> User? in // (3)
//                    try? document.data(as: User.self) // (4)
//                }
//            }
//        }
    }
    
    func saveUserProfile(user: User, username: String, fullname: String, bio: String){
        let userRef = FB_REF_USERS.document(user.uid)
        let newUser = User(id: user.id, uid: user.uid, email: user.email, username: username, displayname: fullname, profileImageUrl: user.profileImageUrl, bio: bio, isFollowed: user.isFollowed)
        
        do {
            try userRef.setData(from: newUser)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
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
