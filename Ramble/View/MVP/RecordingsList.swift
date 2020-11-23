//
//  RecordingList.swift
//  Ramble
//
//  Created by Peter Keating on 11/20/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import AVKit

struct RecordingsList: View {
    @ObservedObject var audioRecorder = AudioRecorder()
    
    var body: some View {
        List {
            ForEach(audioRecorder.recordings, id: \.createdAt) { recording in
                RecordingRow(recording: recording)
            }.onDelete(perform: delete)
        }
    }
    
    func delete(at offsets: IndexSet) {
        audioRecorder.recordings.remove(atOffsets: offsets)
    }
}

struct RecordingRow: View {
    @State var openCell: Bool = false
    @State var date: Date = Date()
    @State var showShareMenu: Bool = false
    @State var caption = ""

    var recording: Recording
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading){
                        Text("11/12")
                            .font(.subheadline)
                            .bold()
                            .opacity(0.5)
                        TextField("Untitled Ramb", text: $caption)
                            .font(.headline)
                    }
                    Spacer()
                    Text("3:30")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                }.padding(.bottom)
                if openCell {
                    recordingRowBottom
                        .padding(.top)
                }
            }
        }
        .frame(height: openCell ? 150 : 50)
        .onTapGesture {
            openCell.toggle()
        }
        .animation(.easeIn(duration: 0.3))
    }
}

private extension RecordingRow {
    var actionSheet: ActionSheet {
            ActionSheet(title: Text("Share Menu"),
                        buttons: [
                            .default(Text("IG Stories")) { self.shareToIG() },
                            .destructive(Text("Cancel"))
            ])
        }
    
    var recordingRowBottom: some View {
        HStack {
            Button(action: {
                self.showShareMenu.toggle()
            }) {
                Image(systemName: "square.and.arrow.up")
            }.actionSheet(isPresented: $showShareMenu, content: {
                            self.actionSheet })
            
            Spacer()
            
            HStack(spacing: 20) {
                Button(action: {
                    print("Show share to IG menu")
                }) {
                    Image(systemName: "backward.end.fill")
                }
                Button(action: {
                    print("Show share to IG menu")
                }) {
                    Image(systemName: "play.fill")
                }
                Button(action: {
                    print("Show share to IG menu")
                }) {
                    Image(systemName: "goforward.15")
                }
            }
            .foregroundColor(Color.primary)
            
        }.font(.title)
        .buttonStyle(BorderlessButtonStyle())
    }
    
    func shareToIG(){
        ShareService.shared.createVideoWithAudio(fileName: "FileName",
                                                 image: UIImage(imageLiteralResourceName: "experienced"),
                                                 audio: recording.fileUrl)
    }
}

struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsList(audioRecorder: AudioRecorder())
    }
}
