//
//  RecordingList.swift
//  Ramble
//
//  Created by Peter Keating on 11/20/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import AVKit

//struct RecordingsList: View {
//    @ObservedObject var audioRecorder = AudioRecorder()
//
//    var body: some View {
//        List {
//            ForEach(audioRecorder.recordings, id: \.createdAt) { recording in
//                RecordingRow(recording: recording)
//            }.onDelete(perform: delete)
//            .modifier(ClearCell())
//        }.onAppear() {
//            UITableView.appearance().backgroundColor = UIColor.clear
//            UITableViewCell.appearance().backgroundColor = UIColor.clear
//        }
//    }
//
//    func delete(at offsets: IndexSet) {
//        audioRecorder.recordings.remove(atOffsets: offsets)
//    }
//}
//
//struct RecordingsList_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordingsList()
//    }
//}
//
