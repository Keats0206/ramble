//
//  UserService.swift
//  Ramble
//
//  Created by Peter Keating on 6/8/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Firebase

struct UserService {
    static let shared = UserService()
    
    func CreateUser(){
        
    }
}
    
//    func fetchUser(uid: String, completion: @escaping(User) -> Void) {
//        REF_USERS.addSnapshotListener() { snapshot, err in
//            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
//
//            let user = User(uid: uid, dictionary: dictionary)
//            completion(user)
//        }
//    }

//    func fetchUser(completion: @escaping([User]) -> Void) {
//        var users = [User]()
//        REF_USERS.addSnapshotListener({ _,_ in (snapshot, err in
//            let uid = snapshot.key
//            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
//            let user = User(uid: uid, dictionary: dictionary)
//            users.append(user)
//            completion(users)
//        }
//    }

