//
//  AudioPlayer.swift
//  Ramble
//
//  Created by Peter Keating on 4/21/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import AVKit
import AVFoundation

import Foundation
import SwiftUI
import Combine
import AVKit

class AudioPlayer: AVPlayer, ObservableObject {
    
    override init() {
        super.init()
    }
    
    @Published var rambCurrentTime: Double = 0
    @Published var rambDuration: Double = 60
    @Published var finish = false
    
    // this is to compute and show remaining time
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
            
            audioPlayer = AVPlayer(url: audio)
            audioPlayer.play()
            isPlaying = true
            
        }
    }
    
    func pausePlayback() {
        audioPlayer.pause()
        isPlaying = false
    }
}

