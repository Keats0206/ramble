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
    
    func fetchUser(completion: @escaping([User]) -> Void) {
        var users = [User]()
        REF_USERS.observe(.childAdded) { snapshot in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(uid: uid, values: dictionary)
            users.append(user)
            completion(users)
        }
    }
}
