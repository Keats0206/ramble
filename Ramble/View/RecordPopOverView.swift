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
    @State var expandRecorder: Bool = true
    @State var caption = "What do you have to say?"

    var body: some View {
        VStack {
            HStack {
                VStack{
                    
                    Button(action: {
                        print("DEBUG: post-recording")
                        
                        self.viewModel.uploadRamb(caption: self.caption, rambUrl: self.audioRecorder.rambUrl)
                    }) {
                        Image(systemName: "plus.square")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.red)
                    }
                    
                    Text("Post").font(.system(size: 12))
                }
                
                Spacer().frame(width: 250)
                
                VStack{
                    
                    Button(action: {print("DEBUG: delete function")}) {
                        Image(systemName: "trash")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.red)
                    }
                    
                    Text("Delete").font(.system(size: 12))
                    
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

            if audioRecorder.recording == false {
                Text("0:00")
                
            } else {
                Text("\(self.audioRecorder.currentTime)")
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
