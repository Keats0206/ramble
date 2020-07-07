//
//  RecordPopOverView.swift
//  Ramble
//
//  Created by Peter Keating on 4/23/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct RecordPopOverView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var viewModel = RambService()
    @ObservedObject var timerManager = TimerManager()
    @State var expandRecorder: Bool = true
    @State var caption = "What do you have to say?"

    var body: some View {
        VStack {
            
            HStack {

                Button(action: {
                    print("DEBUG: delete recording from storage....")
                    self.timerManager.reset()
                }) {
                    Text("Cancel")
                        .foregroundColor(.red)
                        .frame(width: 60)
                }
                
                Spacer().frame(width: 200)
                
                VStack{
                    
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
                    
                    Text("Post").font(.system(size: 12))
                }
                
            }.padding()
            
            TextField("Enter A Ramble Title", text: $caption).multilineTextAlignment(.center)
            
            ZStack {
                
                Image(systemName: "circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white)
                
                HStack{
                    if audioRecorder.recording == false {
                        
                        Button(action: {
                            self.audioRecorder.startRecording()
                            self.timerManager.start()
                        }) {
                            
                            Image(systemName: "waveform.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
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
                                .frame(width: 60, height: 60)
                                .foregroundColor(.red)
                        }
                    }
                }
            }
//          If I stop recording I want to see the time that i stopped recording, it shouldn't reset until I hit post or cancel...
            
            Text(String(format: "%.1f", self.timerManager.secondsElapsed))
                
            Spacer()
        }
    }
}

struct RecordPopOverView_Previews: PreviewProvider {
    static var previews: some View {
        RecordPopOverView(audioRecorder: AudioRecorder())
    }
}
