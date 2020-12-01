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
    
    @Published var lastUploadRambID: String = ""
    
    func setUp(globalPlayer: GlobalPlayer) {
        self.globalPlayer = globalPlayer
    }
    func fetchRamb(rambId: String){
        let docRef = FBRefRambs.document(rambId)
        docRef.getDocument { (document, error) in
            let result = Result {
              try document?.data(as: Ramb2.self)
            }
            switch result {
            case .success(let ramb):
                if let ramb = ramb {
                    // A `City` value was successfully initialized from the DocumentSnapshot.
                    print("City: \(ramb)")
                } else {
                    // A nil value was successfully initialized from the DocumentSnapshot,
                    // or the DocumentSnapshot was nil.
                    print("Document does not exist")
                }
            case .failure(let error):
                // A `City` value could not be initialized from the DocumentSnapshot.
                print("Error decoding city: \(error)")
            }
        }
    }
    func addRamb(_ ramb: Ramb2) {
        let newRamb = FBRefRambs.document()
        let userId = ramb.user.id
        let rambId = newRamb.documentID
        do {
            let _ = try newRamb.setData(from: ramb)
                FBRefUserRambs.document(userId!).setData(["rambId": rambId], merge: true)
        }
        catch {
            print("There was an error while trying to save a ramb \(error.localizedDescription).")
        }
    }
    func fetchRambs() {
        FBRefRambs.order(by: "timestamp").addSnapshotListener { (querySnapshot, error) in // (2)
            if let querySnapshot = querySnapshot {
                self.allRambs = querySnapshot.documents.compactMap { document -> Ramb2? in // (3)
                    try? document.data(as: Ramb2.self) // (4)
                }
            }
        }
    }
    func fetchUserRambs(user: User, newRecording: Bool) {
        let userId = user.uid
        FBRefRambs.whereField("uid", isEqualTo: userId)
            .addSnapshotListener { [self] (querySnapshot, error) in // (2)
                if let querySnapshot = querySnapshot {
                    self.userRambs = querySnapshot.documents.compactMap { document -> Ramb2? in // (3)
                        try? document.data(as: Ramb2.self) // (4)
                    }
                if newRecording {
                    print("DEBUG: new recording")
                    self.userRambs.sort(by: { $0.timestamp < $1.timestamp })
                    if let ramb = self.userRambs.first {
                        self.globalPlayer?.setGlobalPlayer(ramb: ramb)
                        print("DEBUG: tried to set global ramb \(ramb)")
                    }
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
    func updateCaption(ramb: Ramb2, caption: String) {
//      This function breaks because the loaded ramb was created locally not with an ID via Codable...
        let rambRef = FBRefRambs.document(ramb.id!)
        rambRef.updateData(["caption": caption]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    func deleteRamb(ramb: Ramb2) {
        FBRefRambs.document(ramb.id!).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
}
