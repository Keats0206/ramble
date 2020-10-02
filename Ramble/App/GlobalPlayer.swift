//
//  globalPlayer.swift
//  Ramble
//
//  Created by Peter Keating on 9/25/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation
import AVKit

class GlobalPlayer: ObservableObject {
    @Published var globalRamb: Ramb2?
    @Published var rambQue: [Ramb2]?
    @Published var globalRambPlayer: AVPlayer?
    @Published var isPlaying = false
    
    func setGlobalPlayer(ramb: Ramb2){
        let url = URL(string: "\(ramb.rambUrl)")
        self.globalRambPlayer = AVPlayer(url: url!)
        return
    }
}
