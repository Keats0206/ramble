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
    
    @Published var rambs = [Ramb2]()
    @Published var userRambs = [Ramb2]()
    
    init() {
        loadRambs()
    }
    
    private func loadRambs() {
        FB_REF_RAMBS.order(by: "createdTime").addSnapshotListener { (querySnapshot, error) in // (2)
          if let querySnapshot = querySnapshot {
            self.rambs = querySnapshot.documents.compactMap { document -> Ramb2? in // (3)
              try? document.data(as: Ramb2.self) // (4)
            }
          }
        }
      }
    
    func addRamb(_ ramb: Ramb2) {
        do {
          let _ = try FB_REF_RAMBS.addDocument(from: ramb)
        }
        catch {
          print("There was an error while trying to save a task \(error.localizedDescription).")
        }
    }
    
    private func uploadRamb(caption: String, rambUrl: String, rambFileId: String) {
        
    }
        
    func fetchRamb() {

    }

    func fetchUserRambs() {

    }
    
    
//     Note about claps - firebase is only capable of supporting ordering by "ascending". As a work around for this, claps is being stored as a negative value in the database, so we can use it as a sorting key... TLDR; -2 claps in the DB = 2 claps in the UI - user clicking Clap = -1
    
    func handleClap(ramb: Ramb, didClap: Bool){

    }

    func checkIfUserLikedRamb(_ ramb: Ramb, completion: @escaping(Bool) -> Void) {

    }

    func deleteRamb(ramb: Ramb){

    }
}
