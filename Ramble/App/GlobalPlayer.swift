//
//  globalPlayer.swift
//  Ramble
//
//  Created by Peter Keating on 9/25/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation

class GlobalPlayer: ObservableObject {
    @Published var user: User?
    @Published var playingRamb: Ramb?
    @Published var rambQue: [Ramb]?
}
