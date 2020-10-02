//
//  UserDataModel.swift
//  Ramble
//
//  Created by Peter Keating on 5/31/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore // (1)
import FirebaseFirestoreSwift

//struct User: Identifiable, Hashable{
//    @DocumentID var id : String?
//    var uid: String
//    var email: String
//    var username: String
//    var fullname: String
//    var profileImageUrl: URL?
//    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid }
//    var bio: String
//    var isFollowed: Bool
//
//    init(uid: String, values: [String: Any]) {
//        self.uid = uid
//        self.id = values["id"] as? String ?? ""
//        self.email = values["email"] as? String ?? ""
//        self.username = values["username"] as? String ?? ""
//        self.fullname = values["fullname"] as? String ?? ""
//        self.bio = values["bio"] as? String ?? ""
//        self.isFollowed = values["isFollowed"] as? Bool ?? false
//
//        if let profileImageUrlString = values["profileImageUrl"] as? String {
//            guard let url = URL(string: profileImageUrlString) else { return }
//            self.profileImageUrl = url
//        }
//    }
//}

struct User: Identifiable, Codable, Hashable{
    @DocumentID var id: String?
    var uid: String
    var email: String
    var username: String
    var displayname: String
    var profileImageUrl: String?
    var bio: String
    var isFollowed: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case uid
        case email
        case username
        case displayname
        case profileImageUrl
        case bio
        case isFollowed
    }
}
