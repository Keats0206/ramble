//
//  RambleDataModel.swift
//  Ramble
//
//  Created by Peter Keating on 6/8/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation

struct Ramb {
    let caption: String
    let rambID: String
    var claps: Int
    var timestamp: Date!
    var user: User
    var didClap = false
        
    init(user: User, rambID: String, dictionary: [String: Any]) {
        self.rambID = rambID
        self.user = user
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.claps = dictionary["likes"] as? Int ?? 0

        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
}
