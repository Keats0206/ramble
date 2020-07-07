//
//  UserDataModel.swift
//  Ramble
//
//  Created by Peter Keating on 5/31/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation
import Firebase

struct User {
    var uid: String
    var email: String
    var username: String
    var fullname: String
    var profileImageUrl: URL?
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid }
    var bio: String?
    var radius: Double?

    init(uid: String, values: [String: Any]) {
        self.uid = uid

        self.email = values["email"] as? String ?? ""
        self.username = values["username"] as? String ?? ""
        self.fullname = values["fullname"] as? String ?? ""
        self.bio = values["bio"] as? String ?? ""
        self.radius = values["radius"] as? Double ?? nil

        
        if let profileImageUrlString = values["profileImageUrl"] as? String {
            guard let url = URL(string: profileImageUrlString) else { return }
            self.profileImageUrl = url
        }
    }
}
