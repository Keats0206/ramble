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
    
    @Binding var isShown: Bool
    @Binding var hideNav: Bool
    @State var caption = ""
    
    var body: some View {
        
        VStack{
            
            VStack(alignment: .leading){
                
                TextField("What do you have to say", text: $caption)
                    .multilineTextAlignment(.center)
                    .font(.body)
                
            }.frame(height: 150)

//          Cell Bottom
            
            ZStack{
                
                HStack{
                    
                    HStack{
                        
                        Button(action: {
                            self.isShown.toggle()
                            self.hideNav.toggle()
                            self.caption = "What do you have to say?"
                        }) {
                            Text("Cancel")
                                .foregroundColor(.red)
                                .frame(width: 60)
                        }
                        
                        Spacer()
                        
                        HStack{
                            if audioRecorder.recordingUploaded {
                                Spacer()
                            } else {
                                Button(action: {
                                    print("DEBUG: post-recording")
                                    self.viewModel.uploadRamb(
                                        caption: self.caption,
                                        rambUrl: self.audioRecorder.rambUrl,
                                        rambFileId: self.audioRecorder.rambFileID
                                    )
                                    self.isShown.toggle()
                                    self.caption = ""
                                }) {
                                    Text("Post")
                                        .font(.system(size: 14))
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        
                    }
                    
                }.offset(y: 15)
                    .frame(height: 50)
                
                
                VStack{
                    
                    if audioRecorder.recording == false {
                        
                        Button(action: {
                            
                            self.audioRecorder.startRecording()
                            
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

struct RecordPopOverView_Previews: PreviewProvider {
    @State static var value1 = true
    @State static var value2 = true
    
    static var previews: some View {
        RecordPopOverView(audioRecorder: AudioRecorder(), isShown: $value1, hideNav: $value2)
    }
}
