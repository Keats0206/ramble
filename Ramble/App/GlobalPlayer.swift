//
//  GlobalPlayer.swift
//  Ramble
//
//  Created by Peter Keating on 9/25/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation
import AVKit
import MediaPlayer
import MinimizableView
import SwimplyPlayIndicator

class GlobalPlayer: ObservableObject {
    @Published var playingRamb: Ramb2 = testRamb
    @Published var globalRambPlayer: AVPlayer = AVPlayer(url: URL(string: "\(testRamb.rambUrl)")!)
    @Published var isPlaying = false
    @Published var value : Float = 0
    
    let session = AVAudioSession.sharedInstance()
            
    func setGlobalPlayer(ramb: Ramb2) {
        let url = URL(string: "\(ramb.rambUrl)")
        self.globalRambPlayer = AVPlayer(url: url!)
        return
    }
    
    func play() {
        globalRambPlayer.play()
        isPlaying = true
        setupNowPlaying()
        setupRemoteTransportControls()
    }
    
    func pause() {
        globalRambPlayer.pause()
        isPlaying = false
    }

    func setupNowPlaying( ) {
// Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = playingRamb.caption
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = globalRambPlayer.currentItem?.currentTime().seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = globalRambPlayer.currentItem?.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = globalRambPlayer.rate
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            if self.globalRambPlayer.rate == 0.0 {
                self.globalRambPlayer.play()
                return .success
            }
            return .commandFailed
        }
        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.globalRambPlayer.rate == 1.0 {
                self.globalRambPlayer.pause()
                return .success
            }
            return .commandFailed
        }
    }
}
