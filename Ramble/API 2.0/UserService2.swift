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
        let userRef = FBRefUsers.document(uid)

        userRef.getDocument { (document, error) in
            let result = Result {
              try document?.data(as: User.self)
            }
            switch result {
            case .success(let user):
                if let user = user {
                    completion(user)
                    print("DEBUG: got user \(user)")
                } else {
                    print("DEBUG: Document does not exist")
                }
            case .failure(let error):
                print("DEBUG: Error decoding user: \(error)")
            }
        }
    }
    
    func fetchUsers() {
        FBRefUsers.addSnapshotListener { (querySnapshot, _) in // (2)
            if let querySnapshot = querySnapshot {
                self.users = querySnapshot.documents.compactMap { document -> User? in // (3)
                    try? document.data(as: User.self) // (4)
                }
            }
        }
    }
    
    func saveUserProfile(user: User) {
        let userRef = FBRefUsers.document(user.uid)
        let newUser = User(
            id: user.id,
            uid: user.uid,
            email: user.email,
            username: user.username,
            displayname: user.displayname,
            profileImageUrl: user.profileImageUrl,
            bio: user.bio, isFollowed:
            user.isFollowed)
        do {
            try userRef.setData(from: newUser)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }

    }
    
    func updateProfileImage(image: UIImage, completion: @escaping(String) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let ref = Storage.storage().reference().child("profileImage-\(uid)")
        ref.putData(image.jpegData(compressionQuality: 0.42)!, metadata: metadata) { (metadata, error) in
            if error != nil {
                print((error?.localizedDescription)!)
//                self.parent.isLoading = false
                return
            }
            ref.downloadURL { (url, error) in
//            self.parent.isLoading = false
                if error != nil {
                    print((error?.localizedDescription)!)
                    return
                }
                completion(url?.absoluteString ?? "")
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
