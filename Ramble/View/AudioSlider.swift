//
//  AudioPlayer.swift
//  Ramble
//
//  Created by Peter Keating on 9/23/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import AVKit
import Combine
import AVFoundation

struct AudioSlider: View {
    let player: AVPlayer
//  Observing the time / duration of the current audio player
    let timeObserver: PlayerTimeObserver
    let durationObserver: PlayerDurationObserver
    @State private var currentTime: TimeInterval = 0
    @State private var currentDuration: TimeInterval = 0
    @State private var finished = false

    var body: some View {
        VStack {
            Slider(value: $currentTime,
                   in: 0...currentDuration,
                   onEditingChanged: sliderEditingChanged,
                   minimumValueLabel: Text("\(TimeHelper.formatSecondsToHMS(currentTime))"),
                   maximumValueLabel: Text("\(TimeHelper.formatSecondsToHMS(currentDuration))")) {
// This seems to be required but not sure when it would ever show in the UI
                    Text("Duration")
            }
            .font(.caption)
            .foregroundColor(.primary)
        }
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
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        }
    }
        
    deinit {
        player?.removeTimeObserver(timeObservation as Any)
    }
    
    func pause(_ pause: Bool) {
        paused = pause
    }
    
    // Check if player finished

    @objc func playerDidFinishPlaying(note: NSNotification) {
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



