//
//  SessionStore.swift
//  Ramble
//
//  Created by Peter Keating on 4/22/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import UIKit
import Firebase
import Combine
import CoreLocation

class SessionStore : ObservableObject {
    var didChange = PassthroughSubject<SessionStore, Never>()
    
    @Published var session: User? {didSet {self.didChange.send(self) }}
//    @ObservedObject var locationManager = LocationManager()
    
    var handle: AuthStateDidChangeListenerHandle?
    
    func listen(){
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                    let uid = user.uid
                    let email = user.email
                self.session = User(id: uid, uid: uid, email: email!, username: "", displayname: "", profileImageUrl: "", bio: "", isFollowed: false)
            } else {
                self.session = nil
            }
        }
    }
    
    func signUp(
        email: String,
        password: String,
        fullname: String,
        username: String,
        profileImage: UIImage,
        handler: @escaping AuthDataResultCallback
    ){
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = FBStorageProfileImages.child(filename)
        
        storageRef.putData(imageData, metadata: nil) { (meta, error) in
            if error != nil {
                print("Don't put image")
                return
            }
            print("put image on firebase storage")
            storageRef.downloadURL(completion: { (url, error) in
                if error != nil {
                    print("Failed to download url:", error!)
                    return
                } else {
                    guard let profileImageUrl = url?.absoluteString else { return }
                    print(profileImageUrl)
                    
                    
                    Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                        if let error = error {
                            print("DEBUG: Error is \(error.localizedDescription)")
                            return
                        }
                        
                        let uid = result?.user.uid
                        let userRef = FBRefUsers.document(uid!)
                        let user = User(id: uid, uid: uid!, email: email, username: username, displayname: fullname, profileImageUrl: profileImageUrl, bio: "", isFollowed: false)
 
                        do {
                            let _ = try userRef.setData(from: user)
                        }
                        catch {
                            print("There was an error while trying to create the user \(error.localizedDescription).")
                        }
                    }
                }
            })
        }
    }
    
    func signIn(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
    ) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            self.session = nil
            return true
        } catch {
            print("Error while signing out!")
            return false
        }
    }
    
    func unbind () {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
