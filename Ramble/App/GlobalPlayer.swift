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
    @Published var globalRambs: [Ramb2]?
    @Published var rambQue: [Ramb2] = []
    @Published var globalRambPlayer: AVPlayer?
    @Published var isPlaying = false
    @Published var didSet = false
    @Published var playState: SwimplyPlayIndicator.AudioState = .stop
    
    let session = AVAudioSession.sharedInstance()
    
    var minimizableViewHandler = MinimizableViewHandler()
        
    func setGlobalPlayer(ramb: Ramb2) {
        do {
            try session.setCategory(AVAudioSession.Category.playback, mode: .default, policy: .longFormAudio, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            fatalError("*** Unable to set up the audio session: \(error.localizedDescription) ***")
        }
        rambQue.append(ramb)
        let url = URL(string: "\(ramb.rambUrl)")
        self.globalRambPlayer = AVPlayer(url: url!)
        self.didSet = true
        return
    }
    
    func play() {
        globalRambPlayer?.play()
        isPlaying = true
        setupNowPlaying()
        setupRemoteTransportControls()
        addPlay(ramb: (globalRambs!.first!))
        playState = .play
    }
    
    func addPlay(ramb: Ramb2) {
        RambService2.shared.addPlay(ramb: ramb)
    }
    
    func setupNowPlaying( ){
// Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = globalRambs?.first?.caption
//        if let image = UIImage(named: "Play-button") {
//            nowPlayingInfo[MPMediaItemPropertyArtwork] =
//                MPMediaItemArtwork(boundsSize: image.size) { size in
//                    return image
//            }
//        }
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
