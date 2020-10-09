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
    @EnvironmentObject var globalPlayer: GlobalPlayer
    static let shared = RambService2()
    
    @Published var allRambs = [Ramb2]()
    @Published var followingRambs = [Ramb2]()
    @Published var userRambs = [Ramb2]()
    
    init() {
        fetchRambs()
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
    func fetchRambs() {
        FB_REF_RAMBS.order(by: "timestamp").addSnapshotListener { (querySnapshot, error) in // (2)
            if let querySnapshot = querySnapshot {
                self.allRambs = querySnapshot.documents.compactMap { document -> Ramb2? in // (3)
                    try? document.data(as: Ramb2.self) // (4)
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