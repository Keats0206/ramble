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

struct RambCellBottom: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var selectedRamb: SelectedRamb
    @ObservedObject var viewModel = RambService()
    
//  Variable to manage the position of the slide
    @State var seekPos = 0.0
    
    var ramb: Ramb
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            
            HStack{
                
                HStack {

//  Load the AudioView with an AVPlayer using the Ramb streaming URL
                    
                    AudioView(player: AVPlayer(url: URL(string: "\(self.ramb.rambUrl)")!))
                    
                }
            }
        }
    }
}

import SwiftUI
import AVFoundation

struct AudioPlayerControlsView: View {
    let player: AVPlayer
    
//  Observing the time / duration of the current audio player
    
    let timeObserver: PlayerTimeObserver
    let durationObserver: PlayerDurationObserver
    @State private var currentTime: TimeInterval = 0
    @State private var currentDuration: TimeInterval = 0
    
    var body: some View {
        
        VStack {
            
            Slider(value: $currentTime,
                   in: 0...currentDuration,
                   onEditingChanged: sliderEditingChanged,
                   minimumValueLabel: nil,
                   maximumValueLabel: Text("\(TimeHelper.formatSecondsToHMS(currentTime)) / \(TimeHelper.formatSecondsToHMS(currentDuration))")) {
                    
// This seems to be required but not sure when it would ever show in the UI
                    Text("Duration")
                
            }.font(.system(size: 14))
            .accentColor(Color.red)
            
        }.padding()
        
// Listen out for the time observer publishing changes to the player's time
            
        .onReceive(timeObserver.publisher) { time in
            
            // Update the local var
            self.currentTime = time
            
        }

// Listen out for the duration observer publishing changes to the player's item duration
            
        .onReceive(durationObserver.publisher) { duration in
            // Update the local var
            self.currentDuration = duration
        }

    }
    
    // MARK: Private functions
    private func sliderEditingChanged(editingStarted: Bool) {
        
        if editingStarted {
            
            // Tell the PlayerTimeObserver to stop publishing updates while the user is interacting
            // with the slider (otherwise it would keep jumping from where they've moved it to, back
            // to where the player is currently at)
            
            timeObserver.pause(true)
            
        }
            
        else {
            
// Start the seek
            
            let targetTime = CMTime(seconds: currentTime,
                                    preferredTimescale: 600)
            
            player.seek(to: targetTime) { _ in
                
// Now the (async) seek is completed, resume normal operation
                
                self.timeObserver.pause(false)
                                
            }
        }
    }
}

struct AudioView: View {
    @State var isPlaying = false
    var player: AVPlayer
        
    var body: some View {
        
        HStack {
            
            AudioPlayerControlsView(player: player,
                                    timeObserver: PlayerTimeObserver(player: player),
                                    durationObserver: PlayerDurationObserver(player: player))
            Spacer()
            
            Button(action: {
                
                if self.isPlaying {
               
                    self.player.pause()
                    self.isPlaying.toggle()
               
               }
               
               else {
                
                    self.player.play()
                    self.isPlaying.toggle()
               
                }
                
             }) {
                
                Image(systemName: self.isPlaying ? "pause.fill" : "play.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
            
            }.buttonStyle(BorderlessButtonStyle())
            
        }.onAppear{
            
            self.isPlaying = false
            
        }
    }
}

import Combine

class PlayerTimeObserver {
    let publisher = PassthroughSubject<TimeInterval, Never>()
    private weak var player: AVPlayer?
    private var timeObservation: Any?
    private var paused = false
    
    init(player: AVPlayer) {
        self.player = player
        
        // Periodically observe the player's current time, whilst playing
        timeObservation = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: nil) { [weak self] time in
            guard let self = self else { return }
            
            // If we've not been told to pause our updates
            guard !self.paused else { return }
            
            // Publish the new player time
            self.publisher.send(time.seconds)
        }
    }
    
    deinit {
        if let player = player,
            let observer = timeObservation {
            player.removeTimeObserver(observer)
        }
    }
    
    func pause(_ pause: Bool) {
        paused = pause
    }
}

class PlayerDurationObserver {
    let publisher = PassthroughSubject<TimeInterval, Never>()
    private var cancellable: AnyCancellable?
    
    init(player: AVPlayer) {
        let durationKeyPath: KeyPath<AVPlayer, CMTime?> = \.currentItem?.duration
        cancellable = player.publisher(for: durationKeyPath).sink { duration in
            guard let duration = duration else { return }
            guard duration.isNumeric else { return }
            self.publisher.send(duration.seconds)
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
}
