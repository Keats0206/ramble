//
//  RecorderView.swift
//  Ramble
//
//  Created by Peter Keating on 9/26/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct RecorderView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var viewModel = RambService()
    
    var body: some View {
        ZStack{
            VStack{
                
                NavigationLink(destination: RecorderPostView(audioRecorder: AudioRecorder())){
                    Text("Preview")
                        .foregroundColor(.blue)
                }

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
        }.navigationBarHidden(false)
        .navigationBarItems(leading:
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }){
                Text("Cancel")
                    .foregroundColor(.red)
            }
        )
    }
}

struct RecorderView_Previews: PreviewProvider {
    static var previews: some View {
        RecorderView(audioRecorder: AudioRecorder())
    }
}

struct RecorderPostView: View {
    @ObservedObject var viewModel = RambService()
    @ObservedObject var audioRecorder: AudioRecorder

    @State var caption = ""

    var body: some View {
        HStack{
            Button(action: {
                print("DEBUG: post-recording")
                self.viewModel.uploadRamb(
                    caption: self.caption,
                    rambUrl: self.audioRecorder.rambUrl,
                    rambFileId: self.audioRecorder.rambFileID
                )
            }) {
                Text("Post")
                    .font(.system(size: 14))
                    .foregroundColor(.red)
            }
        }
    }
}

