//
//  Constants.swift
//  Ramble
//
//  Created by Peter Keating on 6/8/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation
import Firebase

let STORAGE_REF = Storage.storage().reference(forURL:"gs://ramb-ecce1.appspot.com")
let STORAGE_RAMBS = STORAGE_REF.child("rambs")
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile-images")

let DB_REF = Database.database().reference()
//let GEO_REF_USERS = GeoFire(firebaseRef: REF_USERS_LOCATIONS)
//let GEO_REF_RAMBS = GeoFire(firebaseRef: REF_RAMBS_LOCATIONS)

let REF_USERS = DB_REF.child("user")
let REF_USERS_LOCATIONS = DB_REF.child("user-locations")

let REF_RAMBS = DB_REF.child("rambs")
let REF_RAMBS_LOCATIONS = DB_REF.child("ramb-locations")

let REF_USER_RAMBS = DB_REF.child("user-rambs")
let REF_USER_CLAPS = DB_REF.child("user-claps")
let REF_RAMB_CLAPS = DB_REF.child("ramb-claps")

let REF_USER_FOLLOWERS = DB_REF.child("user-followers")
let REF_USER_FOLLOWING = DB_REF.child("user-following")
