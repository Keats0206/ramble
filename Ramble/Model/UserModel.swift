//
//  UserDataModel.swift
//  Ramble
//
//  Created by Peter Keating on 5/31/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation

struct User {
    var uid: String
    var email: String?
    var displayName: String?
    var location: String?

    init(uid: String, displayName: String?, email: String?) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
    }
}
