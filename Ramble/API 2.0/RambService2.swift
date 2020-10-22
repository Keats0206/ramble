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
        let newRamb = FB_REF_RAMBS.document()
        let userId = ramb.user.id
        let rambId = newRamb.documentID
        
        do {
            let _ = try newRamb.setData(from: ramb)
            FB_REF_USER_RAMBS.document(userId!).setData(["rambId":rambId], merge: true)
        }
        catch {
            print("There was an error while trying to save a task \(error.localizedDescription).")
        }
    }
    
//  Fetch all rambs for the for you page
    func fetchRambs(isInitialFetch : Bool = false) {
        FB_REF_RAMBS.order(by: "timestamp").addSnapshotListener { (querySnapshot, error) in // (2)
            if let querySnapshot = querySnapshot {
                self.allRambs = querySnapshot.documents.compactMap { document -> Ramb2? in // (3)
                    try? document.data(as: Ramb2.self) // (4)
                }
                if isInitialFetch {
                    self.allRambs.sort(by: { $0.plays > $1.plays })
                    if let ramb = self.allRambs.first {
                        self.globalPlayer?.globalRamb = [ramb]
                        self.globalPlayer?.setGlobalPlayer(ramb: ramb)
                    }
//                    globalPlayer.globalRambPlayer?.play()
//                    globalPlayer.isPlaying = true
                }
            }
        }
    }

//  Fetch user specific rambs by getting following uid's, then getting user rambs
    
//  Fetch user rambs
    func fetchUserRambs(user: User) {
        let userId = user.uid
        
        FB_REF_RAMBS.whereField("uid", isEqualTo: userId)
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
        FB_REF_RAMBS.whereField("uid", isEqualTo: user.uid).getDocuments(completion: { (snapshots, error) in
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

//    private func uploadRamb(caption: String, rambUrl: String, rambFileId: String) {
//
//    }
//
//    func fetchRamb() {
//
//    }
//
//     Note about claps - firebase is only capable of supporting ordering by "ascending". As a work around for this, claps is being stored as a negative value in the database, so we can use it as a sorting key... TLDR; -2 claps in the DB = 2 claps in the UI - user clicking Clap = -1
    
//    func handleClap(ramb: Ramb, didClap: Bool){
//
//    }
//
//    func checkIfUserLikedRamb(_ ramb: Ramb, completion: @escaping(Bool) -> Void) {
//
//    }

//    func removeRamb(_ ramb: Ramb2) {
//        if let rambID = ramb.id {
//          FB_REF_RAMBS.document(rambID).delete { (error) in // (1)
//            if let error = error {
//              print("Error removing document: \(error.localizedDescription)")
//            }
//          }
//        }
//      }
}
