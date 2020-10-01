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

let FB_STORAGE_REF = Storage.storage().reference(forURL:"gs://ramb-ecce1.appspot.com")
let FB_STORAGE_RAMBS = STORAGE_REF.child("rambs")
let FB_STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile-images")

let FB_REF = Firestore.firestore()
//let GEO_REF_USERS = GeoFire(firebaseRef: REF_USERS_LOCATIONS)
//let GEO_REF_RAMBS = GeoFire(firebaseRef: REF_RAMBS_LOCATIONS)

let FB_REF_USERS = FB_REF.collection("user")
let FB_REF_USERS_LOCATIONS = FB_REF.collection("user-locations")

let FB_REF_RAMBS = FB_REF.collection("rambs")
let FB_REF_RAMBS_LOCATIONS = FB_REF.collection("ramb-locations")

let FB_REF_USER_RAMBS = FB_REF.collection("user-rambs")
let FB_REF_USER_CLAPS = FB_REF.collection("user-claps")
let FB_REF_RAMB_CLAPS = FB_REF.collection("ramb-claps")

let FB_REF_USER_FOLLOWERS = FB_REF.collection("user-followers")
let FB_REF_USER_FOLLOWING = FB_REF.collection("user-following")
