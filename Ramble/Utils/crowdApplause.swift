//
//  ApplauseHandler.swift
//  Ramble
//
//  Created by Peter Keating on 5/29/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation
import Firebase

func crowdApplause(applauseActive: Bool,applause: String, tagId: String) {

    let db = Firestore.firestore()

     //     Convert applause string to a number
    
            var applauseInt = Int(applause)!
    
    //      If applause state is false then add 1
                     
                 if applauseActive {
                    applauseInt -= 1
                } else {
                    applauseInt += 1
                }
    
            let applauseStr = String(applauseInt)
    
            let rambRef = db.collection("rambs").document("oktRTdtlbuN8VoYlfMhr")

            rambRef.updateData([
                "applause": "\(applauseStr)"
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        
//        update datee in the VIEW. It's all working perfectly except the data in the view is not updating after the fucntions run...
    
    return
}

