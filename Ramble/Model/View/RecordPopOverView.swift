//
//  RecordPopOverView.swift
//  Ramble
//
//  Created by Peter Keating on 4/23/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

let numberOfSamples: Int = 20

struct RecordPopOverView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var viewModel = RambService()
    @ObservedObject var timerManager = TimerManager()
    @ObservedObject private var mic = MicrophoneMonitor(numberOfSamples: numberOfSamples)
    
    @State var expandRecorder: Bool = true
    @State var caption = "What do you have to say?"
    
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.4, CGFloat(level) + 50) / 2 // between 0.1 and 25
        
        return CGFloat(level * (300 / 25)) // scaled to max at 300 (our height of our bar)
    }
    
    var body: some View {
        
        VStack{
            //          Cell top
            
            VStack{
                
                if self.audioRecorder.recordingViewState != .started {
                
                    TextField("Title your post here", text: $caption).multilineTextAlignment(.center)

                } else {
                    
                    HStack(spacing: 4) {
                        ForEach(mic.soundSamples, id: \.self) { level in
                            BarView(value: self.normalizeSoundLevel(level: level))
                        }.frame(width: 25)
                    }
                }
                
            }.frame(height: 150)
                        
//          Cell Bottom
            
            ZStack{
                                
                HStack{
                    
                    HStack{
                        
                        Button(action: {
                                     
                                     print("DEBUG: delete recording from storage....")
                                     
                                     self.timerManager.reset()
                                     
                                 }) {
                                     
                                     Text("Cancel")
                                         .foregroundColor(.red)
                                         .frame(width: 60)
                                 }
                        
                        Spacer()
                        
                        HStack{
                            
                            if audioRecorder.recordingViewState == .uploaded {
                                
                                Text("Post").font(.system(size: 14)).foregroundColor(.red)
                                
                                Button(action: {
                                    
                                    print("DEBUG: post-recording")
                                    
                                    self.viewModel.uploadRamb(
                                        
                                        caption: self.caption,
                                        
                                        rambUrl: self.audioRecorder.rambUrl,
                                        
                                        rambFileId: self.audioRecorder.rambFileID
                                    )
                                    
                                    self.timerManager.reset()
                                    
                                }) {
                                    
                                    Image(systemName: "plus.square")
                                        .resizable()
                                        .frame(width: 25, height: 25)
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
                    
                    Text("0:00")
                    
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
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(gradient: Gradient(colors: [.red, .blue]),
                                     startPoint: .top,
                                     endPoint: .bottom))
                .frame(width: (UIScreen.main.bounds.width - CGFloat(numberOfSamples) * 4) / CGFloat(numberOfSamples), height: value)
        }.padding(20)
    }
}

struct RecordPopOverView_Previews: PreviewProvider {
    static var previews: some View {
        RecordPopOverView(audioRecorder: AudioRecorder())
    }
}
