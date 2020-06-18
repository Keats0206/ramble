//
//  RambleDataModel.swift
//  Ramble
//
//  Created by Peter Keating on 6/8/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation

struct Ramb {
    let id: String
    let caption: String
    let claps: String
    let length: String
    let name: String
    let rambUrl: String
    let userimage: String
    let uid: String
    var timestamp: Int
    let user: User
    
    init(user: User, id: String, dictionary: [String: Any]) {
        self.id = id
        self.user = user
        
        self.claps = dictionary["claps"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        self.length = dictionary["uid"] as? String ?? ""
        self.name = dictionary["uid"] as? String ?? ""
        self.rambUrl = dictionary["uid"] as? String ?? ""
        self.userimage = dictionary["uid"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.timestamp = dictionary["uid"] as? Int ?? 0
    }
}




