//
//  getData.swift
//  Ramble
//
//  Created by Peter Keating on 4/21/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import Firebase

struct RambService {
    static let shared = RambService()
    
    func uploadRamb(caption: String, rambUrl: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_RAMBS.document().setData([
                "caption":"\(caption)",
                "claps":"0",
                "timestamp":Int(NSDate().timeIntervalSince1970),
                "length":"59s",
                "rambUrl": "\(rambUrl)",
                "userimage": "https://media-exp1.licdn.com/dms/image/C5603AQGbHL6OVW4A8A/profile-displayphoto-shrink_400_400/0?e=1596067200&v=beta&t=K0rDOMqlkKiL8xnxktJaVUDO_H8ct2bXqV4E_AVXQ2Y",
                "name":"@Pete",
                "location":"location",
                "uid": uid ])
        { (err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
        }
    }
}

func handleClap(didClap: Bool, claps: String, id: String) {
    var clapsInt = Int(claps)!
    let idStr = String(id)
    if didClap {
        clapsInt -= 1
    } else {
        clapsInt += 1
    }
    let clapsStr = String(clapsInt)
    
    REF_RAMBS.document("\(idStr)").updateData(["claps": "\(clapsStr)"]) { err in
        if let err = err {
            print("Error updating document: \(err)")
        } else {
            print("updating this ramb \(idStr) with this number of claps \(clapsStr)")
        }
    }
    return
}
