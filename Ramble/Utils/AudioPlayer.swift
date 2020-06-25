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

class AudioPlayer: AVPlayer, ObservableObject {
    
    override init() {
        super.init()
    }
    
    @Published var rambCurrentTime: Int = 0
    @Published var rambDuration: Int = 0
    
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
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ (_) in
                
//              Accessing current time and duration
                
                let floatCurrentTime = Float(CMTimeGetSeconds(self.audioPlayer.currentTime()))
                let floatDuration = Float(CMTimeGetSeconds(self.audioPlayer.currentItem!.asset.duration))
                
//              Converting to Integer

                self.rambCurrentTime = Int(floatCurrentTime)
                self.rambDuration = Int(floatDuration)
                
//              TODO: variables are now storing and being accessed by feed cell...but they don't update live in the UI(not sure why), and they aren't loading
                
                return
            }
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
