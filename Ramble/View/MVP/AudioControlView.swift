//
//  AudioControlView.swift
//  Ramble
//
//  Created by Peter Keating on 11/10/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import AVKit
import Foundation
import Combine

struct AudioControlView: View {
    @State var player: AVPlayer
    @State var isPlaying = false
    @State var showControls = false
    @State var value: Float = 0

    var body: some View {
        VStack{
            ZStack {
                Controls(player: self.$player, isPlaying: self.$isPlaying)
            }
        }
    }
}

struct Controls : View {
    @Binding var player: AVPlayer
    @Binding var isPlaying: Bool

    var body : some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
//                        self.player.seek(to: CMTime(seconds: self.getSeconds() - 10, preferredTimescale: 1))
                    }) {
                        Image(systemName: "backward.end.fill")
                            .font(.system(size: 30))
                    }.buttonStyle(PlayerButtonStyle())
                    Spacer()
                    Button(action: {
                        if self.isPlaying {
                            self.player.pause()
                            self.isPlaying = false
                        } else {
                            self.player.play()
                            self.isPlaying = true
                        }
                    }) {
                        Image(systemName: self.isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 50))
                    }.buttonStyle(PlayerButtonStyle())
                    Spacer()
                    Button(action: {
//                        self.player.seek(to: CMTime(seconds: self.getSeconds() + 10, preferredTimescale: 1))
                    }) {
                        Image(systemName: "goforward.15")
                            .font(.system(size: 30))
                    }.buttonStyle(PlayerButtonStyle())
                    Spacer()
                }.foregroundColor(.primary)
            }
        }
//        .onAppear {
//        self.player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { (_) in
////            self.value = self.getSliderValue()
//            if self.value == 1.0 {
//                self.isPlaying = false
//            }
//        }
//    }
    }
//
//    func getSliderValue()-> Float {
//        return Float(self.player.currentTime().seconds / (self.player.currentItem?.duration.seconds)!)
//    }
//
//    func getSeconds()-> Double {
//        return Double(Double(self.value) * (self.player.currentItem?.duration.seconds)!)
//    }
}

//struct CustomProgressBar: UIViewRepresentable {
//    func makeCoordinator() -> CustomProgressBar.Coordinator {
//        return CustomProgressBar.Coordinator(parent1: self)
//    }
//    @Binding var value: Float
//    @Binding var player: AVPlayer
//    @Binding var isPlaying: Bool
//
//    func makeUIView(context: UIViewRepresentableContext<CustomProgressBar>) -> UISlider {
//        let slider = UISlider()
//        slider.minimumTrackTintColor = .systemGray3
//        slider.maximumTrackTintColor = .systemGray4
//        slider.thumbTintColor = .gray
//        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
//        slider.value = value
//        slider.addTarget(context.coordinator, action: #selector(context.coordinator.changed(slider:)), for: .valueChanged)
//        return slider
//    }
//
//    func updateUIView(_ uiView: UISlider, context: UIViewRepresentableContext<CustomProgressBar>) {
//        uiView.value = value
//    }
//
//    class Coordinator: NSObject {
//        var parent: CustomProgressBar
//        init(parent1: CustomProgressBar) {
//            parent = parent1
//        }
//        @objc func changed(slider : UISlider) {
//            if slider.isTracking{
//                parent.player.pause()
//                let sec = Double(slider.value * Float((parent.player.currentItem?.duration.seconds)!))
//                parent.player.seek(to: CMTime(seconds: sec, preferredTimescale: 1))
//            } else{
//                let sec = Double(slider.value * Float((parent.player.currentItem?.duration.seconds)!))
//                parent.player.seek(to: CMTime(seconds: sec, preferredTimescale: 1))
//                if parent.isPlaying{
//                    parent.player.play()
//                }
//            }
//        }
//    }
//}

@available(iOS 14.0, *)
class Host: UIHostingController<ContentView> {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

struct AudioPlayer : UIViewControllerRepresentable {
    @Binding var player : AVPlayer

    func makeUIViewController(context: UIViewControllerRepresentableContext<AudioPlayer>) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        return controller
    }
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<AudioPlayer>) {

    }
}


