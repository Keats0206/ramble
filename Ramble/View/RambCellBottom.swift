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
    
//    @State var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
//    @State var maxWidth = UIScreen.main.bounds.width / 2.2
//    @State var time : Float = 0
//    @State private var currentPlayerTime: Double = 0.0
    
    @State var seekPos = 0.0
    
    var ramb: Ramb
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            
            HStack{
                
                HStack {
                    
                    AudioView(player: AVPlayer(url: URL(string: "\(self.ramb.rambUrl)")!))
                    
                }
            }
        }
    }
}

import SwiftUI
import AVFoundation

struct AudioPlayerControlsView: View {
    
//    private enum PlaybackState: Int {
//        case waitingForSelection
//        case buffering
//        case playing
//    }
    
    let player: AVPlayer
    let timeObserver: PlayerTimeObserver
    let durationObserver: PlayerDurationObserver
//    let itemObserver: PlayerItemObserver
    
    @State private var currentTime: TimeInterval = 0
    @State private var currentDuration: TimeInterval = 0
    
    var body: some View {
        
        VStack {
            
            Slider(value: $currentTime,
                   in: 0...currentDuration,
                   onEditingChanged: sliderEditingChanged,
                   minimumValueLabel: nil,
                   maximumValueLabel: Text("\(TimeHelper.formatSecondsToHMS(currentTime)) / \(TimeHelper.formatSecondsToHMS(currentDuration))")) {
                    // I have no idea in what scenario this View is shown...
                    Text("Time")
                }.font(.system(size: 14))
            .accentColor(Color.red)
        }
            
        .padding()
        // Listen out for the time observer publishing changes to the player's time
        .onReceive(timeObserver.publisher) { time in
            // Update the local var
            self.currentTime = time
            // And flag that we've started playback
//            if time > 0 {
//                self.state = .playing
//            }
        }
        // Listen out for the duration observer publishing changes to the player's item duration
        .onReceive(durationObserver.publisher) { duration in
            // Update the local var
            self.currentDuration = duration
        }
        
        // TODO the below could replace the above but causes a crash
//        // Listen out for the player's item changing
//        .onReceive(player.publisher(for: \.currentItem)) { item in
//            self.state = item != nil ? .buffering : .waitingForSelection
//            self.currentTime = 0
//            self.currentDuration = 0
//        }
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
            // Editing finished, start the seek
//            state = .buffering
            let targetTime = CMTime(seconds: currentTime,
                                    preferredTimescale: 600)
            player.seek(to: targetTime) { _ in
                // Now the (async) seek is completed, resume normal operation
                self.timeObserver.pause(false)
//                self.state = .playing
            }
        }
    }
}

struct AudioView: View {
    
    @ObservedObject var playerModel = AudioPlayer()
    var player: AVPlayer
        
    var body: some View {
        
        HStack {
            
            AudioPlayerControlsView(player: playerModel.audioPlayer,
                                    timeObserver: PlayerTimeObserver(player: player),
                                    durationObserver: PlayerDurationObserver(player: player))
            Spacer()
            
            Button(action: {
            
            self.playerModel.isPlaying.toggle()
               
                if self.playerModel.isPlaying {
               
                    self.player.pause()
               
               }
               
               else {
                
                    self.player.play()
               
                }
                
             }) {
                Image(systemName: self.playerModel.isPlaying ? "play.fill" : "pause.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
            }.buttonStyle(BorderlessButtonStyle())
            
        }.onAppear{
            
            self.playerModel.isPlaying = false
            
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

//class PlayerItemObserver {
//    let publisher = PassthroughSubject<Bool, Never>()
//    private var itemObservation: NSKeyValueObservation?
//
//    init(player: AVPlayer) {
//        // Observe the current item changing
//        itemObservation = player.observe(\.currentItem) { [weak self] player, change in
//            guard let self = self else { return }
//            // Publish whether the player has an item or not
//            self.publisher.send(player.currentItem != nil)
//        }
//    }
//
//    deinit {
//        if let observer = itemObservation {
//            observer.invalidate()
//        }
//    }
//}
