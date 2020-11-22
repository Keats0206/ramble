//
//  PlayerView.swift
//  Ramble
//
//  Created by Peter Keating on 11/19/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

//import SwiftUI
//import SDWebImageSwiftUI
//import AVKit
//
//struct RecordPostView: View {
//    @ObservedObject var audioRecorder = AudioRecorder()
//
//    @Binding var position: CardPosition
//    @State var caption = ""
//    @State var showAlert: Bool = false
//
//    var buttonDisabled: Bool {
//        caption != "" ? false : true
//    }
//
//    var imageScale = UIScreen.main.bounds.width * 0.7
//
//    var user: User
//    var recording: Recording
//
//    var postDate = Date()
//
//    var body: some View {
//        VStack(alignment: .center) {
//
//            TextField("Untitled Ramb", text: $caption)
//                .multilineTextAlignment(.center)
//                .font(.system(.body, design: .rounded))
//
//            AudioControlView(player: AVPlayer(url: recording.fileURL))
//
//            Button(action: {
//                position = CardPosition.top
//            }) {
//                Text("POST")
//                    .font(.system(.headline, design: .rounded))
//                    .bold()
//                    .padding()
//                    .padding(.horizontal, 30)
//            }.disabled(buttonDisabled)
//                .foregroundColor(.white)
//                .background(buttonDisabled ? .gray : Color.accent3)
//                .cornerRadius(40)
//
//            Spacer()
//
//        }.padding()
//    }
//}
