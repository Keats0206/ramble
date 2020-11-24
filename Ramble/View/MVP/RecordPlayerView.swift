//
//  RecordView.swift
//  Ramble
//
//  Created by Peter Keating on 11/19/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import AVKit

struct RecordPlayerView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var globalPlayer: GlobalPlayer
    
    @ObservedObject var timerManager = TimerManager()
    @ObservedObject var audioRecorder = AudioRecorder()
        
    @State private var animateRecording = false
    @State var openAudioUpload = false
    @State var animateUploading = false
    @State var txt = ""
    
    @State var player: AVPlayer
    
    @Binding var viewControl: ViewControl
    
    var user: User
        
    var buttonSize: CGFloat {
        130
    }
    
    var body: some View {
        ZStack {
            if viewControl == .create {
                recordView
            }
            if viewControl == .recordings {
                playerView
            }
        }
        .animation(.interactiveSpring())
        .onAppear {
            animateUploading = false
        }
    }
}

private extension RecordPlayerView {
    var recordView: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4)
                .foregroundColor(Color.accent3)
                .frame(width: buttonSize + 10, height: buttonSize + 10)
            
            Text(String(format: "%.1f", timerManager.secondsElapsed))
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .offset(y: -100)
            
                switch audioRecorder.recorderState {
                case .ready:
                    Button(action: {
                        audioRecorder.startRecording()
                        timerManager.start()
                    }) {
                        Image(systemName: "mic.circle")
                            .resizable()
                            .frame(width: buttonSize, height: buttonSize)
                    }.buttonStyle(PlayerButtonStyle())
                case .started:
                    Button(action: {
                        audioRecorder.stopRecording()
                        timerManager.stop()
                    }) {
                        Image(systemName: "stop.circle.fill")
                            .frame(width: buttonSize, height: buttonSize)
                    }
                case .stopped:
                    LoadingAnimation()
                case.uploaded:
                    Spacer()
                        .onAppear {
                            viewControl = .recordings
                    }
                }
            }
    }
    var playerView: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading){
                    TextField("\(globalPlayer.playingRamb.caption)", text: $txt)
                        .font(.system(size: 23, weight: .bold))
                    Text("\(globalPlayer.playingRamb.timestamp)")
                        .font(.system(size: 18, weight: .bold))
                        .bold()
                        .opacity(0.5)
                }.frame(width: UIScreen.main.bounds.width - 50)
            }.padding(.vertical)
            
            AudioControlView(player: player)
            
//            HStack {
//                Spacer()
//                Button(action: {
//                    self.player.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
//                }) {
//                    Image(systemName: "backward.end.fill")
//                        .font(.system(size: 30))
//                }.buttonStyle(PlayerButtonStyle())
//                Spacer()
//                Button(action: {
//                    if self.isPlaying {
//                        self.player.pause()
//                        self.isPlaying = false
//                    } else {
//                        self.player.play()
//                        self.isPlaying = true
//                    }
//                }) {
//                    Image(systemName: self.isPlaying ? "pause.fill" : "play.fill")
//                        .font(.system(size: 50))
//                }.buttonStyle(PlayerButtonStyle())
//                Spacer()
//                Button(action: {
//                    self.player.seek(to: CMTime(seconds: self.getSeconds() + 10, preferredTimescale: 1))
//                }) {
//                    Image(systemName: "goforward.15")
//                        .font(.system(size: 30))
//                }.buttonStyle(PlayerButtonStyle())
//                Spacer()
//            }
        }
    }
}

struct RecordPlayer_Previews: PreviewProvider {
    static var previews: some View {
        RecordPlayerView(player: testPlayer, viewControl: .constant(.create), user: testUser)
    }
}

struct PlayerButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding()
            .scaleEffect(configuration.isPressed ? 1.3 : 1.0)
    }
}
