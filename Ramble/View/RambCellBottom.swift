//
//  RambCellBottom.swift
//  Ramble
//
//  Created by Peter Keating on 9/4/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import AVKit
import Combine
import AVFoundation


struct RambCellBottom: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var globalPlayer: GlobalPlayer
    @ObservedObject var viewModel = RambService()
    
    var ramb: Ramb
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            
            HStack{
                
//              Build out a model to support likes comments sharing etc.
                    
//              Load the AudioView with an AVPlayer using the Ramb streaming URL
                
//              AudioView(player: AVPlayer(url: URL(string: "\(self.ramb.rambUrl)")!))
                    
            }
        }
    }
}
