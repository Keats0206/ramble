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
        REF_RAMBS.observe(.childAdded) { snapshot in
            let id = snapshot.key
            if snapshot.value != nil{
                //there is data available
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                let ramb = Ramb(id: id, dictionary: dictionary)
                self.rambs.append(ramb)
  
            } else {
                //there is no data available. snapshot.value is nil
                print("No data available from snapshot.value!!!!")
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
