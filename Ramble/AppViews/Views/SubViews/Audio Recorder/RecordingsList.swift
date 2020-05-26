//
//  Recordingsl.swift
//  Ramble
//
//  Created by Peter Keating on 4/21/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct RecordingsList: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
    
    var body: some View {
        ScrollView {
            ForEach(audioRecorder.recordings, id: \.createdAt) { recording in
                RecordingRow(audioURL: recording.fileURL)
                }
        }.padding(5)
            .background(Color.white)
    }
}

struct RecordingRow: View {
    
    var audioURL: URL
    
    @ObservedObject var audioPlayer = AudioPlayer()
    
    var body: some View {
            HStack {
                
                Spacer().frame(width: 10)
                
                // Button that shows play or pause depending on audio state
                
                if audioPlayer.isPlaying == false {
                    
                    Button(action: {
                        self.audioPlayer.startPlayback(audio: self.audioURL)
                    }) {
                        Image(systemName: "play.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                } else {
                    
                    Button(action: {
                        self.audioPlayer.stopPlayback()
                    }) {
                        Image(systemName: "stop.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                }
                
                // Path to file of local audio
                
                Spacer().frame(width: 10)
                
                VStack(alignment: .leading){
                    Text("@Post title").font(.body).fontWeight(.heavy)
                    Text("\(audioURL.lastPathComponent)")
                }
                
                Spacer()
                
                Text("3:33")
                
                Spacer().frame(width: 10)
            }
    }
}

struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsList(audioRecorder: AudioRecorder())
    }
}
