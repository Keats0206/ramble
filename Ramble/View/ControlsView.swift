//
//  AudioControlView.swift
//  Ramble
//
//  Created by Peter Keating on 11/10/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import Foundation
import AVKit
import Combine

struct ControlsView: View {
    @EnvironmentObject var globalPlayer: GlobalPlayer
    
    var body : some View {
        ZStack {
            VStack {
                ProgressBarView(player: globalPlayer.globalRambPlayer!,
                                        timeObserver: PlayerTimeObserver(player: globalPlayer.globalRambPlayer!),
                                        durationObserver: PlayerDurationObserver(player: globalPlayer.globalRambPlayer!),
                                        itemObserver: PlayerItemObserver(player: globalPlayer.globalRambPlayer!))
    
                HStack {
                    
                    Spacer()
                    
                    Button(action: {
                        self.globalPlayer.globalRambPlayer?.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
                    }) {
                        Image(systemName: "backward.end.fill")
                            .font(.system(size: 25))
                    }.buttonStyle(PlayerButtonStyle())
                    
                    Spacer()
                    
                    Button(action: {
                        if self.globalPlayer.isPlaying {
                            self.globalPlayer.globalRambPlayer?.pause()
                            self.globalPlayer.isPlaying = false
                        } else {
                            self.globalPlayer.play()
                            self.globalPlayer.isPlaying = true
                        }
                    }) {
                        Image(systemName: self.globalPlayer.isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 40))
                    }.buttonStyle(PlayerButtonStyle())
                    
                    Spacer()
                    
                    Button(action: {
                        self.globalPlayer.globalRambPlayer?.seek(to: CMTime(seconds: getSeconds() + 15, preferredTimescale: 1))
                    }) {
                        Image(systemName: "goforward.15")
                            .font(.system(size: 25))
                    }.buttonStyle(PlayerButtonStyle())
                    
                    Spacer()
                }
                    .foregroundColor(.primary)
            }
        }
        .onAppear {
    //          Checks if player did finish
                self.globalPlayer.globalRambPlayer?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { (_) in
                    self.globalPlayer.value = self.getSliderValue()
                    if self.globalPlayer.value == 1.0 {
    //                  Set now playing to false
                        self.globalPlayer.isPlaying = false
    //                  Seek back to time zero
                        self.globalPlayer.globalRambPlayer?.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
                }
            }
        }
    }
    func getSliderValue() -> Float {
        return Float(
            (self.globalPlayer.globalRambPlayer?.currentTime().seconds)!
                /
            (self.globalPlayer.globalRambPlayer?.currentItem?.duration.seconds)!)
    }
    func getSeconds() -> Double {
        return Double(Double(self.globalPlayer.value) * (self.globalPlayer.globalRambPlayer?.currentItem?.duration.seconds)!)
    }
}

struct CustomProgressBar: UIViewRepresentable {
      func makeCoordinator() -> CustomProgressBar.Coordinator {
          return CustomProgressBar.Coordinator(parent1: self)
      }
      @Binding var value: Float
      @Binding var player: AVPlayer?
      @Binding var isplaying: Bool
      
      func makeUIView(context: UIViewRepresentableContext<CustomProgressBar>) -> UISlider {
          let slider = UISlider()
          slider.minimumTrackTintColor = .white
          slider.maximumTrackTintColor = .gray
          slider.thumbTintColor = .white
          slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
          slider.value = value
          slider.addTarget(context.coordinator, action: #selector(context.coordinator.changed(slider:)), for: .valueChanged)
          return slider
      }
      func updateUIView(_ uiView: UISlider, context: UIViewRepresentableContext<CustomProgressBar>) {
          uiView.value = value
      }
      class Coordinator: NSObject {
          var parent: CustomProgressBar
          init(parent1: CustomProgressBar) {
                parent = parent1
          }
          @objc func changed(slider: UISlider) {
              if slider.isTracking {
                  parent.player?.pause()
                  let sec = Double(slider.value * Float((parent.player?.currentItem?.duration.seconds)!))
                  parent.player?.seek(to: CMTime(seconds: sec, preferredTimescale: 100))
              } else {
                  let sec = Double(slider.value * Float((parent.player?.currentItem?.duration.seconds)!))
                  parent.player?.seek(to: CMTime(seconds: sec, preferredTimescale: 100))
                  if parent.isplaying {
                      parent.player?.play()
                  }
              }
          }
      }
  }

class Host: UIHostingController<ContentView> {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

struct AudioPlayer: UIViewControllerRepresentable {
    @Binding var player: AVPlayer
    func makeUIViewController(context: UIViewControllerRepresentableContext<AudioPlayer>) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        return controller
    }
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<AudioPlayer>) {
    }
}
