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
    var claps: Int
    let length: Double
    let rambUrl: String
    let fileId: String
    let uid: String
    var timestamp: Int
    let user: User
    var didClap: Bool
    var isPlaying: Bool
    
    init(user: User, id: String, dictionary: [String: Any]) {
        self.id = id
        self.user = user
        
        self.claps = dictionary["claps"] as? Int ?? 0
        self.caption = dictionary["caption"] as? String ?? ""
        self.length = dictionary["length"] as? Double ?? 0
        self.rambUrl = dictionary["rambUrl"] as? String ?? ""
        self.fileId = dictionary["fileId"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Int ?? 0
        self.didClap = dictionary["didClap"] as? Bool ?? false
        self.isPlaying = dictionary["isPlaying"] as? Bool ?? false
    }
}
