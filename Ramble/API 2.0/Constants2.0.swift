//
//  Constants2.0.swift
//  Ramble
//
//  Created by Peter Keating on 10/1/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

let FBStorageRef = Storage.storage().reference(forURL:"gs://ramb-ecce1.appspot.com")
let FBStorageRambs = FBStorageRef.child("rambs")
let FBStorageProfileImages = FBStorageRef.child("profile-images")

let FBRef = Firestore.firestore()
let FBRefUsers = FBRef.collection("users")
let FBRefRambs = FBRef.collection("rambs")
let FBRefUserRambs = FBRef.collection("user-rambs")
