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
    @State var rambtitle = ""

    var body: some View {
    
        VStack {
            Handle()
            
            Spacer().frame(height: 5)
            
            TextField("Enter username...", text: $rambtitle)
                .padding()
                .frame(width: nil, height: nil, alignment: .center)
            
            Text("0:07")
            
            Spacer().frame(height: 10)
            
            Text("Audio vizualizer")
        
            Spacer().frame(height: 10)
            
            if audioRecorder.recording == false {
                Button(action: {print(self.audioRecorder.startRecording())}) {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipped()
                        .foregroundColor(.red)
                }
            } else {
                Button(action: {self.audioRecorder.stopRecording()}) {
                    Image(systemName: "stop.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipped()
                        .foregroundColor(.red)
                }
            }
            
            HStack {
                Button(action: {self.audioRecorder.postRamb()}) {
                    Image(systemName: "plus.square")
                        .resizable()
                        .frame(width: 30, height: 30)
                        
                }
                
                Spacer().frame(width: 120)
                
                Button(action: {print("delete function")}) {
                    Image(systemName: "trash")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
            }.padding()
                        
            Spacer()
            
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color.gray.opacity(0.14))
    }
}

struct RecordPopOverView_Previews: PreviewProvider {
static var previews: some View {
    RecordPopOverView(audioRecorder: AudioRecorder())
    }
}

