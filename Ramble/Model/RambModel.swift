//
//  RambleDataModel.swift
//  Ramble
//
//  Created by Peter Keating on 6/8/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation
import FirebaseFirestore // (1)
import FirebaseFirestoreSwift

struct Ramb2: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var caption: String
    var length: Double
    var rambUrl: String
    var fileId: String
    var timestamp: Int
    var plays: Int
    var user: User
    var uid: String
    var isSelected: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case caption
        case length
        case rambUrl
        case fileId
        case timestamp
        case plays
        case user
        case uid
        case isSelected
    }
}
