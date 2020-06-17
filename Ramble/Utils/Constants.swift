//
//  Constants.swift
//  Ramble
//
//  Created by Peter Keating on 6/8/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")

let DB_REF = Firestore.firestore()
let REF_USERS = Firestore.firestore().collection("users")
let REF_USER_CLAPS = DB_REF.collection("user-claps")

let REF_RAMBS = Firestore.firestore().collection("rambs")
let REF_USER_RAMBS = DB_REF.collection("user-rambs")

