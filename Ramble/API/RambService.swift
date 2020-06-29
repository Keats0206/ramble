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
    static let shared = RambService()
    @ObservedObject var location = LocationManager()
    @Published var rambs = [Ramb]()
    @Published var userRambs = [Ramb]()
    
    
    var myQuery: GFQuery?
    
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
    
    func fetchRambs(){
//        I think this is sudo working...
//        TODO: Sort this by time and like, make radius an input field...
        
//      Get users ID...
        guard let uid = Auth.auth().currentUser?.uid else { return }

//     Take that user ID and query the location based off the user's current radius...
        
        GEO_REF_USERS.getLocationForKey("\(uid)") { (location, error) in
            if (error != nil) {
                print("An error occurred getting the location for \"current user is\": \(String(describing: error?.localizedDescription))")
            } else if (location != nil) {
                
//          Return the user's latitude and longitude, create a location for that user
                let userLat = location?.coordinate.latitude
                let userLong = location?.coordinate.longitude
                
                let location:CLLocation = CLLocation(latitude: CLLocationDegrees(userLat!), longitude: CLLocationDegrees(userLong!))
                
//          Query rambles based off that location and return an ID for every ramble, store that as Key
                
                self.myQuery = GEO_REF_RAMBS.query(at: location, withRadius: 25)
                self.myQuery?.observe(.keyEntered, with: { (key, location) in
//          Print("KEY:\(String(describing: key)) and location:\(String(describing: location))")
                    
//          For every ramble ID returned, build a RAMB and append it to the array...
                    let rambRef = REF_RAMBS.child(key)
                    
                    rambRef.observeSingleEvent(of: .value, with: { (snapshot) in
                        let id = snapshot.key
                        guard let dictionary = snapshot.value as? [String: Any] else { return }
                        guard let uid = dictionary["uid"] as? String else { return }
                        
                        UserService.shared.fetchUser(uid: uid) { user in
                            let ramb = Ramb(user: user, id: id, dictionary: dictionary)
                            self.rambs.append(ramb)
                        }
                    })
                })
            }
        }
    }
    
//    Old functions for fetching rambs hot and new, figured out a better sorting solution.
    
//    func fetchHotRambs() {
//        REF_RAMBS.queryOrdered(byChild: "claps").observe(.childAdded, with: { (snapshot) in
//            guard let dictionary = snapshot.value as? [String: Any] else { return }
//            guard let uid = dictionary["uid"] as? String else { return }
//            let id = snapshot.key
//
//            UserService.shared.fetchUser(uid: uid) { user in
//                let ramb = Ramb(user: user, id: id, dictionary: dictionary)
//                self.hotRambs.append(ramb)
//          }
//      })
//    }
    
//    func fetchNewRambs() {
//        REF_RAMBS.queryOrdered(byChild: "timestamp").observe(.childAdded, with: { (snapshot) in
//            guard let dictionary = snapshot.value as? [String: Any] else { return }
//            guard let uid = dictionary["uid"] as? String else { return }
//            let id = snapshot.key
//
//            UserService.shared.fetchUser(uid: uid) { user in
//                let ramb = Ramb(user: user, id: id, dictionary: dictionary)
//                self.newRambs.append(ramb)
//                return
//            }
//        })
//    }
    
    func fetchUserRambs(forUser user: User) {
        REF_USER_RAMBS.child(user.uid).observe(.childAdded) { snapshot in
            let id = snapshot.key
            
            REF_USER_RAMBS.child(user.uid).observe(.childAdded, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                
                UserService.shared.fetchUser(uid: uid) { user in
                    let ramb = Ramb(user: user, id: id, dictionary: dictionary)
                    self.userRambs.append(ramb)
                }
            })
        }
    }
        
// Note about claps - firebase is only capable of supporting ordering by "ascending". As a work around for this, claps is being stored as a negative value in the database, so we can use it as a sorting key... TLDR; -2 claps in the DB = 2 claps in the UI - user clicking Clap = -1
    
    func handleClap(ramb: Ramb) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let claps = ramb.didClap ? ramb.claps + 1 : ramb.claps - 1
        REF_RAMBS.child(ramb.id).child("claps").setValue(claps)
        
        if ramb.didClap {
            // unlike tweet
            REF_USER_CLAPS.child(uid).child(ramb.id).removeValue { (err, ref) in
                REF_RAMB_CLAPS.child(ramb.id).removeValue()
            }
        } else {
            // like tweet
            REF_USER_CLAPS.child(uid).updateChildValues([ramb.id: 1]) { (err, ref) in
                REF_RAMB_CLAPS.child(ramb.id).updateChildValues([uid: 1])
            }
        }
    }
    
    func checkIfUserLikedTweet(_ ramb: Ramb, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_CLAPS.child(uid).child(ramb.id).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
}
