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
        
        VStack{
            //          Cell top
            
            VStack{
                
                if self.audioRecorder.recordingViewState == .stopped {
                    
                    TextField("Title your post here", text: $caption).multilineTextAlignment(.center)

                } else {
                    
                    HStack {
                        Text("Show visualizer")
                    }
                }
                
            }.background(Color(.red)).frame(height: 150)
                        
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
                    
                }
                    .offset(y: 15)
                    .frame(height: 50)
                    .background(Color(.orange))
                
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
                    
                }.background(Color(.blue)).offset(y: -15)
                
            }
                
            Spacer()
            
        }
    }
}

struct RecordPopOverView_Previews: PreviewProvider {
    static var previews: some View {
        RecordPopOverView(audioRecorder: AudioRecorder())
    }
}
