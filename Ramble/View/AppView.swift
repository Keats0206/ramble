//
//  AppView.swift
//  Ramble
//
//  Created by Peter Keating on 4/22/20.
//  Copyright © 2020 Peter Keating. All rights reserved.

import SwiftUI

struct AppView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @State var recordingModal_shown = false
    
    var body: some View {
        TabView{
            FeedView(audioRecorder: AudioRecorder()).tabItem {
                Image(systemName: "dot.radiowaves.left.and.right")
                Text("Feed")
                .tag(1)
            }
           
            ActivityView().tabItem {
                Image(systemName: "bell.circle")
                Text("Activity")
                .tag(2)
            }
        }
    }
}

