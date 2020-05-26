//
//  RecorderView.swift
//  Ramble
//

//  Created by Peter Keating on 4/21/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

//Currently unused - migrated over into ProfileView

import SwiftUI

struct RecorderView: View {

    @ObservedObject var audioRecorder: AudioRecorder
    
    var topSpacer_height:CGFloat = 320
    
    var body: some View {
    
        VStack(alignment: .leading) {
                HStack{
                    Spacer()
                        .frame(height: topSpacer_height)
                }
            RecordingsList(audioRecorder: audioRecorder)
        }
    }
}

struct RecorderView_Previews: PreviewProvider {
    static var previews: some View {
        RecorderView(audioRecorder: AudioRecorder())
    }
}
