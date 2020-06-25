//
//  RambleDataModel.swift
//  Ramble
//
//  Created by Peter Keating on 6/8/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation

struct Ramb: Identifiable {
    let id: String
    let caption: String
    let claps: Int
    let length: String
    let name: String
    let rambUrl: String
    let userimage: String
    let uid: String
    var timestamp: Int
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        
        self.claps = dictionary["claps"] as? Int ?? 0
        self.caption = dictionary["caption"] as? String ?? ""
        self.length = dictionary["length"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.rambUrl = dictionary["rambUrl"] as? String ?? ""
        self.userimage = dictionary["userimage"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Int ?? 0
    }
}
