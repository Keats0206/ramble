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
                                    timeObserver: PlayerTimeObserver(player: player))
            
            HStack{
                
                Spacer()
                
                Button(action: {
                    print("Go back to previous song")
                    rewindBtn()
                }) {
                    Image(systemName: "gobackward.15")
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
                    fastForwardBtn()
                }) {
                    Image(systemName: "goforward.15")
                        .font(.system(size: 20))
                }
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .foregroundColor(.primary)
        }
        .onAppear {
            self.isPlaying = true
        }
    }
    
    func fastForwardBtn() {
        let moveForword : Float64 = 15
        if let duration  = player.currentItem?.duration {
            let playerCurrentTime = CMTimeGetSeconds(player.currentTime())
            let newTime = playerCurrentTime + moveForword
            if newTime < CMTimeGetSeconds(duration) {
                let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
                player.seek(to: selectedTime)
            }
            player.pause()
            player.play()
        }
    }

    func rewindBtn() {
        let moveBackword: Float64 = 15
        let playerCurrenTime = CMTimeGetSeconds(player.currentTime())
        var newTime = playerCurrenTime - moveBackword
        if newTime < 0 {
            newTime = 0
        }
        player.pause()
        let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
        player.seek(to: selectedTime)
        player.play()
    }
}

struct AudioView_Previews: PreviewProvider {
    static var previews: some View {
        AudioView(player: testPlayer)
    }
}
