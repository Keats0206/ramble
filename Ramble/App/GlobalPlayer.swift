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
    static let shared = GlobalPlayer()
    
    @Published var playingRamb: Ramb2?
    @Published var globalRambPlayer: AVPlayer?
    @Published var isPlaying = false
    @Published var value : Float = 0
    @Published var caption = ""

    let session = AVAudioSession.sharedInstance()
        
    func setGlobalPlayer(ramb: Ramb2) {
        do {
            try session.setCategory(AVAudioSession.Category.playback, mode: .default, policy: .longFormAudio, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            fatalError("*** Unable to set up the audio session: \(error.localizedDescription) ***")
        }
        playingRamb = ramb
        let url = URL(string: "\(ramb.rambUrl)")
        globalRambPlayer = AVPlayer(url: url!)
        caption = ramb.caption
        return
    }
    func play() {
        globalRambPlayer?.play()
        isPlaying = true
        setupNowPlaying()
        setupRemoteTransportControls()
    }
    func pause() {
        globalRambPlayer?.pause()
        isPlaying = false
    }
    func setupNowPlaying( ) {
// Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = playingRamb?.caption
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = globalRambPlayer?.currentItem?.currentTime().seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = globalRambPlayer?.currentItem?.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = globalRambPlayer?.rate
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            if self.globalRambPlayer?.rate == 0.0 {
                self.globalRambPlayer?.play()
                return .success
            }
            return .commandFailed
        }
        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.globalRambPlayer?.rate == 1.0 {
                self.globalRambPlayer?.pause()
                return .success
            }
            return .commandFailed
        }
    }
}
