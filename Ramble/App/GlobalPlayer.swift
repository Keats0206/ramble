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
    @Published var globalRamb: Ramb?
    @Published var rambQue: [Ramb]?
    @Published var globalRambPlayer: AVPlayer?
    @Published var isPlaying = false
    
    func setGlobalPlayer(ramb: Ramb){
        let url = URL(string: "\(ramb.rambUrl)")
        self.globalRambPlayer = AVPlayer(url: url!)
        return
    }
}
