//
//  AudioPlayer.swift
//  Ramble
//
//  Created by Peter Keating on 11/10/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import AVKit

struct GlobalPlayerView: View {
    @EnvironmentObject var globalPlayer: GlobalPlayer
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
                }) {
                    Image(systemName: "gobackward.15")
                        .font(.system(size: 30))
                }

                Spacer()

                Button(action: {
                    if self.globalPlayer.isPlaying {
                        self.globalPlayer.globalRambPlayer!.pause()
                        self.globalPlayer.isPlaying.toggle()
                    } else {
                        self.globalPlayer.globalRambPlayer!.play()
                        self.globalPlayer.isPlaying.toggle()
                    }
                 }) {
                    Image(systemName: self.globalPlayer.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 50))

                }.buttonStyle(BorderlessButtonStyle())

                Spacer()

                Button(action: {

                    print("Skip ahead to next song")

                }) {

                    Image(systemName: "goforward.15")
                        .font(.system(size: 30))
                }

                Spacer()

            }
                .padding(.vertical)
                .foregroundColor(.primary)
        }
//        .onAppear {
//            self.isPlaying = true
//        }
    }
}

struct GlobalPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalPlayerView(player: testPlayer)
    }
}
