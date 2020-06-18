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
    @State var caption = "Enter A Ramb Title Here"

    var body: some View {
        VStack {
            Handle()
            
            Spacer().frame(height: 5)
            
            HStack {

                Spacer()

                TextField("Enter A Ramble Title", text: $caption)

                Spacer()
                
            }
            
            Text("\(self.audioRecorder.currentTime)")
            
            Spacer().frame(height: 10)
                    
            Spacer().frame(height: 10)
            
            ZStack {
                
                Image(systemName: "circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white)
                
                HStack{
                    if audioRecorder.recording == false {
                        
                        Button(action: {print(self.audioRecorder.startRecording())}) {
                            
                            Image(systemName: "mic.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .foregroundColor(.red)
                        }
                    } else {
                        
                        Button(action: {self.audioRecorder.stopRecording()}) {
                            
                            Image(systemName: "stop.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            
            HStack {
                Button(action: {
                    print("DEBUG: post-recording")
                    RambService.shared.uploadRamb(caption: self.caption, rambUrl: self.audioRecorder.rambUrl)
                }) {
                    Image(systemName: "plus.square")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
                Spacer().frame(width: 220)
                
                Button(action: {print("DEBUG: delete function")}) {
                    Image(systemName: "trash")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
            }.padding()
            
            Spacer()
            
        }
    }
}

struct RecordPopOverView_Previews: PreviewProvider {
    static var previews: some View {
        RecordPopOverView(audioRecorder: AudioRecorder())
    }
}
