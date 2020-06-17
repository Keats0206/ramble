//
//  RambViewModel.swift
//  Ramble
//
//  Created by Peter Keating on 6/8/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation
import Firebase

class RambViewModel: ObservableObject {
    @Published var rambs = [Ramb]()
    
    func fetchRambs() {
        REF_RAMBS.addSnapshotListener { (querySnapshot, error ) in
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            
            self.rambs = documents.map { (queryDocumentSnapshot) -> Ramb in
                
                let data = queryDocumentSnapshot.data()
                
                let id = queryDocumentSnapshot.documentID
                let caption = data["caption"] as? String ?? ""
                let claps = data["claps"] as? String ?? ""
                let timestamp = data["timestamp"] as? Int ?? 0
                let length = data["length"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let rambUrl = data["rambUrl"] as? String ?? ""
                let userimage = data["userimage"] as? String ?? ""
                let location = data["location"] as? String ?? ""
                let uid = data["uid"] as? String ?? ""
                
                return Ramb(id: id, caption: caption, claps: claps, timestamp: timestamp, length: length, name: name, rambUrl: rambUrl, userimage: userimage, uid: uid, location: location)
            }
        }
    }
}

// Date formatter for rambles

func formatDate(timestamp: Int) -> String {
    let timestampDbl = Double(timestamp)
    let from = Date(timeIntervalSince1970: timestampDbl)
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
    formatter.maximumUnitCount = 1
    formatter.unitsStyle = .abbreviated
    let now = Date()
    return formatter.string(from: from, to: now)!
}
