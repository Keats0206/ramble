//
//  RambCell.swift
//  Ramble
//
//  Created by Peter Keating on 6/8/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import AVKit

struct RambCell : View {
    let player = AVPlayer()
    var ramb: Ramb
    
    var body: some View {
        VStack(alignment: .leading){
            
            RambCellTop(ramb: ramb)
            
            RambCellBottom(ramb: ramb)
            
        }
    }
}
