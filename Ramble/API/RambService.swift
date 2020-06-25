//
//  getData.swift
//  Ramble
//
//  Created by Peter Keating on 4/21/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import Firebase
import GeoFire

class RambService: ObservableObject {
    @ObservedObject var location = LocationManager()
    
    @Published var hotRambs = [Ramb]()
    @Published var newRambs = [Ramb]()
    @Published var userRambs = [Ramb]()
    
    func uploadRamb(caption: String, rambUrl: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = [
            "caption":"\(caption)",
            "claps": 0,
            "timestamp": Int(NSDate().timeIntervalSince1970) * -1,
            "length":"59s",
            "rambUrl": "\(rambUrl)",
            "userimage": "https://media-exp1.licdn.com/dms/image/C5603AQGbHL6OVW4A8A/profile-displayphoto-shrink_400_400/0?e=1596067200&v=beta&t=K0rDOMqlkKiL8xnxktJaVUDO_H8ct2bXqV4E_AVXQ2Y",
            "name":"@Pete",
            "location":"location",
            "uid": uid ] as [String : Any]
                
        let ref = REF_RAMBS.childByAutoId()
        
        ref.updateChildValues(values) { (err, ref) in
            guard let rambID = ref.key else { return }
            REF_USER_RAMBS.child(uid).updateChildValues([rambID: 1])
        
            GEO_REF_RAMBS.setLocation(self.location.lastLocation!, forKey: rambID)
        }
    }
    
    func fetchHotRambs() {
//        Rewrite this query based on current users location...
        
//        Get users current location and radius
        
//        Query for ramble ID's based on that location and store them in an arry
        
//        For each id in that array query for ramb and store that in an array of local rambs...

//        Somehow sort that array by claps...done
        
        REF_RAMBS.queryOrdered(byChild: "claps").observe(.childAdded, with: { (snapshot) in
              let id = snapshot.key
              if snapshot.value != nil{
                  //there is data available
                print(snapshot)
                  guard let dictionary = snapshot.value as? [String: Any] else { return }
                  let ramb = Ramb(id: id, dictionary: dictionary)
                  self.hotRambs.append(ramb)

              } else {
                  //there is no data available. snapshot.value is nil
                  print("No data available from snapshot.value!!!!")
              }
          })
      }
    
    func fetchNewRambs() {
      REF_RAMBS.queryOrdered(byChild: "timestamp").observe(.childAdded, with: { (snapshot) in
            let id = snapshot.key
            if snapshot.value != nil{
                //there is data available
              print(snapshot)
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                let ramb = Ramb(id: id, dictionary: dictionary)
                self.newRambs.append(ramb)

            } else {
                //there is no data available. snapshot.value is nil
                print("No data available from snapshot.value!!!!")
            }
        })
    }
    
    func fetchUserRambs(forUser user: User) {
        REF_USER_RAMBS.child(user.uid).observe(.childAdded) { snapshot in
            let id = snapshot.key

            REF_RAMBS.child(id).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }

                UserService.shared.fetchUser(uid: uid) { user in
                    let ramb = Ramb(id: id, dictionary: dictionary)
                    self.userRambs.append(ramb)
                }
            }
        }
    }
        
        
//        Go into user rambs

    
// Note about claps - firebase is only capable of supporting ordering by "ascending". As a work around for this, claps is being stored as a negative value in the database, so we can use it as a sorting key... TLDR; -2 claps in the DB = 2 claps in the UI - user clicking Clap = -1
    
    func handleClap(didClap: Bool, claps: Int, id: String) {
        var claps = claps
        let idStr = String(id)
        if didClap {
            claps += 1
        } else {
            claps -= 1
        }
    
        REF_RAMBS.child("\(idStr)").updateChildValues(["claps": claps]) { err, ref in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("updating this ramb \(idStr) with this number of claps \(String(claps))")
            }
        }
        return
    }
}

