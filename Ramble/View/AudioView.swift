//
//  AudioPlayer.swift
//  Ramble
//
//  Created by Peter Keating on 11/10/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import AVKit

struct AudioView: View {
    @State var isPlaying = false
    var player: AVPlayer
     
    var body: some View {
        
        VStack {
            
            AudioPlayerControlsView(player: player,
                                    timeObserver: PlayerTimeObserver(player: player),
                                    durationObserver: PlayerDurationObserver(player: player))
            
            HStack {
                
                Button(action: {
                    print("Go back to previous song")
                }) {
                    
                    Image(systemName: "goforward.15")
                        .font(.system(size: 20))
                }
                
                Spacer()
                
                Button(action: {
                    if self.isPlaying {
                        self.player.pause()
                        self.isPlaying.toggle()
                    } else {
                        self.player.play()
                        self.isPlaying.toggle()
                    }
                 }) {
                    Image(systemName: self.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 36))
                    
                }.buttonStyle(BorderlessButtonStyle())
                
                Spacer()
                
                Button(action: {
                    print("Skip ahead to next song")
                }) {
                    
                    Image(systemName: "gobackward.15")
                        .font(.system(size: 20))
                }
            }
                .foregroundColor(.primary)
            
            
            
        }.onAppear {
            self.isPlaying = true
        }
    }
}
