//
//  RecordPopOverView.swift
//  Ramble
//
//  Created by Peter Keating on 4/23/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

let numberOfSamples: Int = 10

struct RecordPopOverView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var viewModel = RambService()
    @ObservedObject var timerManager = TimerManager()
    @ObservedObject private var mic = MicrophoneMonitor(numberOfSamples: numberOfSamples)
    
    @Binding var isShown: Bool
    @State var expandRecorder: Bool = true
    @State var caption = ""
    
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.4, CGFloat(level) + 50) / 2 // between 0.1 and 25
        
        return CGFloat(level * (200 / 25)) // scaled to max at 300 (our height of our bar)
    }
    
    var body: some View {
        
        VStack{
            
            
            VStack(alignment: .leading){
                
                if self.audioRecorder.recordingViewState != .started {
                    
                    TextField("What do you have to say", text: $caption)
                        .multilineTextAlignment(.center)
                        .font(.body)
                    
                } else {
                    
//                    Some sort of animation if we need it
                    
//                    VStack{
//
//                        HStack(spacing: 4) {
//
//                            ForEach(mic.soundSamples, id: \.self) { level in
//
//                                BarView(value: self.normalizeSoundLevel(level: level))
//
//                            }.frame(width: 25)
//                        }
//                    }
                }
                
            }.frame(height: 150)
            
            //          Cell Bottom
            
            ZStack{
                
                HStack{
                    
                    HStack{
                        
                        Button(action: {
                            print("DEBUG: delete recording from storage....")
                            self.timerManager.reset()
                            self.isShown.toggle()
                            self.caption = "What do you have to say?"
                            
                        }) {
                            
                            Text("Cancel")
                                .foregroundColor(.red)
                                .frame(width: 60)
                        }
                        
                        Spacer()
                        
                        HStack{
                            
                            if audioRecorder.recordingViewState == .uploaded {
                                                                
                                Button(action: {
                                    
                                    print("DEBUG: post-recording")
                                    
                                    self.viewModel.uploadRamb(
                                        caption: self.caption,
                                        rambUrl: self.audioRecorder.rambUrl,
                                        rambFileId: self.audioRecorder.rambFileID
                                    )
                                    self.timerManager.reset()
                                    self.isShown.toggle()
                                    self.caption = ""
                                    
                                }) {
                                    
                                    Text("Post")
                                        .font(.system(size: 14))
                                        .foregroundColor(.red)
                                }
                            } else {
                                Spacer()
                            }
                        }
                        
                    }
                    
                }.offset(y: 15)
                    .frame(height: 50)
                
                
                VStack{
                    
                    if audioRecorder.recording == false {
                        
                        Button(action: {
                            
                            self.audioRecorder.startRecording()
                            self.timerManager.start()
                            
                        }) {
                            
                            Image(systemName: "waveform.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.red)
                        }
                        
                    } else {
                        
                        Button(action: {
                            
                            self.audioRecorder.stopRecording()
                            self.timerManager.stop()
                            
                        }) {
                            
                            Image(systemName: "stop.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.red)
                        }
                    }
                                        
                }.offset(y: -15)
                
            }
            
            Spacer()
            
        }
    }
}

struct BarView: View {
    var value: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(LinearGradient(gradient: Gradient(colors: [.red, .blue]),
                                     startPoint: .top,
                                     endPoint: .bottom))
                .frame(width: (UIScreen.main.bounds.width - CGFloat(numberOfSamples) * 10) / CGFloat(numberOfSamples), height: value)
        }.padding(10)
    }
}

