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
import Combine

class RambService: ObservableObject {
    static let shared = RambService()
    
    @EnvironmentObject var sessionSettings: SessionSettings
    @ObservedObject var location = LocationManager()
    @Published var rambs = [Ramb]()
    @Published var userRambs = [Ramb]()
    
    var myQuery: GFQuery?
    
    func uploadRamb(caption: String, rambUrl: String, rambFileId: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = [
            "caption":"\(caption)",
            "claps": 0,
            "timestamp": Int(NSDate().timeIntervalSince1970) * -1,
            "length": Double(10),
            "rambUrl": "\(rambUrl)",
            "fileId":"\(rambFileId)",
            "didClap": false,
            "uid": uid ] as [String : Any]
        
        let ref = REF_RAMBS.childByAutoId()
        
        ref.updateChildValues(values) { (err, ref) in
            guard let rambId = ref.key else { return }
            REF_USER_RAMBS.child(uid).updateChildValues([rambId: rambId])
            GEO_REF_RAMBS.setLocation(self.location.lastLocation!, forKey: rambId)
        }
    }
    
    //  Rewrite my fetch function.........I think this needs to ve converted to an observer...and not just an observe single event of.
    
    func observeRambs(radius: Double){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        print("DEBUG: Fetching rambs for a users within this radius \(radius)")
        
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
                
                self.myQuery = GEO_REF_RAMBS.query(at: location, withRadius: radius)
                
//              updated view model to include
                self.myQuery?.observe(.keyEntered, with: { (key, location) in
                    self.fetchRambs(key: key)
                })
                
//                I don't think these are doing anything...
                
//                self.myQuery?.observe(.keyExited, with: { (key, location) in
//                    self.fetchRambs(key: key)
//                })
//
//                self.myQuery?.observe(.keyMoved, with: { (key, location) in
//                    self.fetchRambs(key: key)
//                })
            }
        }
    }
    
    func fetchRambs(key: String){
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
    }
    
    func fetchRamb(withrambId rambId: String, completion: @escaping(Ramb) -> Void) {
        REF_RAMBS.child(rambId).observe(DataEventType.value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { user in
                let ramb = Ramb(user: user, id: rambId, dictionary: dictionary)
                completion(ramb)
            }
        })
    }
    
    func fetchUserRambs(forUser user: User,  completion: @escaping([Ramb]) -> Void) {
        REF_USER_RAMBS.child(user.uid).observe(.childAdded) { snapshot in
            let rambId = snapshot.key
            
            self.fetchRamb(withrambId: rambId) { ramb in
                self.userRambs.append(ramb)
                completion(self.userRambs)
            }
        }
    }
    
    
    // Note about claps - firebase is only capable of supporting ordering by "ascending". As a work around for this, claps is being stored as a negative value in the database, so we can use it as a sorting key... TLDR; -2 claps in the DB = 2 claps in the UI - user clicking Clap = -1
    
    func handleClap(ramb: Ramb, didClap: Bool){        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let claps = didClap ? ramb.claps + 1 : ramb.claps - 1
            
        REF_RAMBS.child(ramb.id).child("claps").setValue(claps)
        REF_RAMBS.child(ramb.id).child("didClap").setValue(didClap)
        
        if didClap {
            // add ramb to user claps
            REF_USER_CLAPS.child(uid).updateChildValues([ramb.id : ramb.id])
        } else {
            // remove ramb to user claps
            REF_USER_CLAPS.child(uid).child(ramb.id).removeValue()
        }
    }

    func checkIfUserLikedRamb(_ ramb: Ramb, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_CLAPS.child(uid).child(ramb.id).observe(DataEventType.value, with: { snapshot in
            print("DEBUG: \(snapshot.exists())")
            completion(snapshot.exists())
        })
    }
    
    func deleteRamb(ramb: Ramb){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let rambId = ramb.id
        //      Everything deletes except this part AND the UI is not updating when the post is deleted...
        STORAGE_RAMBS.child(rambId).delete()
        //      delete from rambs
        REF_RAMBS.child(rambId).removeValue()
        //      delete from user ramb
        REF_USER_RAMBS.child(uid).child(rambId).removeValue()
        //      delete ramb claps
        REF_RAMB_CLAPS.child(rambId).removeValue()
        //      delete ramb location
        REF_RAMBS_LOCATIONS.child(rambId).removeValue()
        
        print("DEBUG: deleted ramb with id of \(rambId)")
    }
}
