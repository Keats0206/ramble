//
//  RambService2.swift
//  Ramble
//
//  Created by Peter Keating on 10/1/20.
//  Copyright © 2020 Peter Keating. All rights reserved.

import SwiftUI
import Firebase
import Combine

class RambService2: ObservableObject {
    @Published var globalPlayer: GlobalPlayer?
    static let shared = RambService2()
    
    @Published var allRambs = [Ramb2]()
    @Published var followingRambs = [Ramb2]()
    @Published var userRambs = [Ramb2]()
    @Published var initialRamb : Ramb2?
    
    init() {
        fetchRambs(isInitialFetch: true)
    }
    
    func setUp(globalPlayer: GlobalPlayer) {
        self.globalPlayer = globalPlayer
    }
    
    //  This function is working!
    func addRamb(_ ramb: Ramb2) {
        let newRamb = FBRefRambs.document()
        let userId = ramb.user.id
        let rambId = newRamb.documentID
        
        do {
            let _ = try newRamb.setData(from: ramb)
            FBRefUserRambs.document(userId!).setData(["rambId":rambId], merge: true)
        }
        catch {
            print("There was an error while trying to save a ramb \(error.localizedDescription).")
        }
    }
    
//  Fetch all rambs for the for you page
    func fetchRambs(isInitialFetch : Bool = false) {
        FBRefRambs.order(by: "timestamp").addSnapshotListener { (querySnapshot, error) in // (2)
            if let querySnapshot = querySnapshot {
                self.allRambs = querySnapshot.documents.compactMap { document -> Ramb2? in // (3)
                    try? document.data(as: Ramb2.self) // (4)
                }
                if isInitialFetch {
                    self.allRambs.sort(by: { $0.plays > $1.plays })

                    if let ramb = self.allRambs.first {
                        self.globalPlayer?.globalRambs = [ramb]
                        self.globalPlayer?.setGlobalPlayer(ramb: ramb)
                        
                    }
                }
            }
        }
    }

//  Fetch user rambs
    func fetchUserRambs(user: User) {
        let userId = user.uid
        
        FBRefRambs.whereField("uid", isEqualTo: userId)
            .addSnapshotListener { (querySnapshot, error) in // (2)
                if let querySnapshot = querySnapshot {
                    self.userRambs = querySnapshot.documents.compactMap { document -> Ramb2? in // (3)
                        try? document.data(as: Ramb2.self) // (4)
                }
            }
        }
    }
    
    func updateUserData(user: User) {
        let dict = [
            "bio" : user.bio,
            "displayname" : user.displayname,
            "email" : user.email,
            "isFollowed" : user.isFollowed,
            "profileImageUrl" : user.profileImageUrl,
            "uid" : user.uid,
            "username" : user.username
        ] as [String : Any]
      
        FBRefRambs.whereField("uid", isEqualTo: user.uid).getDocuments(completion: { (snapshots, error) in
            if let error = error {
                print("Error " + error.localizedDescription)
                return
            } else if let snaps = snapshots?.documents {
                for snap in snaps {
                    snap.reference.updateData(["user" : dict])
                }
            }
        })
    }
    
    func addPlay(ramb: Ramb2) {
        let plays = ramb.plays + 1
        
        FBRefRambs.document(ramb.id!).updateData(["plays": plays]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}
