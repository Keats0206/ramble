//
//  AudioPlayer.swift
//  Ramble
//
//  Created by Peter Keating on 4/21/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation
import Firebase
import SwiftUI
import Combine
import AVKit
import AVFoundation

class AudioPlayer: AVPlayer, ObservableObject {
    
    let objectWillChange = PassthroughSubject<AudioPlayer, Never>()
    
    var isPlaying = false {
            didSet {
                objectWillChange.send(self)
            }
        }
    
    var audioPlayer = AVPlayer()

    func startPlayback(audio: URL) {
        
        let playbackSession = AVAudioSession.sharedInstance()
        
        do {
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing over the device's speakers failed")
        }
        
        do {
            audioPlayer = try AVPlayer(url: audio)
            audioPlayer.play()
            isPlaying = true
            
        } catch {
            print("Playback failed.")
    }
}
    
    func stopPlayback() {
        audioPlayer.pause()
        isPlaying = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
}
