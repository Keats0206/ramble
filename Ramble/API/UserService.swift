//
//  UserService.swift
//  Ramble
//
//  Created by Peter Keating on 6/8/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase

class UserService: ObservableObject {
    static let shared = UserService()
    @Published  var users = [User]()
    
    func fetchUser(uid: String, completion: @escaping(User) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let values = snapshot.value as? [String: AnyObject] else { return }
            let user = User(uid: uid, values: values)
            completion(user)
        }
    }
    
    func updateUserRadius(uid: String, radius: Binding<Double>){
        REF_USERS.child(uid).setValue(["radius": radius])
        print("DEBUG: Updated user to have a discovery radius of \(radius)")
    }
    
    func fetchUser(completion: @escaping([User]) -> Void) {
        REF_USERS.observe(.childAdded) { snapshot in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(uid: uid, values: dictionary)
            self.users.append(user)
            completion(self.users)
            print(self.users)
        }
    }
}
