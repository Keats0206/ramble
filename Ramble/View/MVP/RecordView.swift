//
//  RecordView.swift
//  Ramble
//
//  Created by Peter Keating on 11/19/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct RecordView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var timerManager = TimerManager()
    @ObservedObject var audioRecorder = AudioRecorder()
        
    @State private var animateRecording = false
    @State var openAudioUpload = false
    @State var animateUploading = false
    @State var txt = ""
    
    @Binding var viewControl: ViewControl
    
    var user: User
    
    var buttonSize: CGFloat{
        130
    }
    
    var body: some View {
        ZStack{
            if viewControl == .create {
                VStack{
                        recordButton
                    }
            }
            if viewControl == .recordings {
                VStack {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading){
                            TextField("Record to share your voice", text: $txt)
                                .font(.system(size: 23, weight: .bold))
                            Text("11/12")
                                .font(.system(size: 18, weight: .bold))
                                .bold()
                                .opacity(0.5)
                        }.frame(width: UIScreen.main.bounds.width - 50)
                    }.padding(.vertical)
//                    Text(String(format: "%.1f", timerManager.secondsElapsed))
//                        .font(.system(size: 40, weight: .bold, design: .rounded))
                    HStack {
                        Spacer()
                        Button(action: {
                            print("Show share to IG menu")
                        }) {
                            Image(systemName: "backward.end.fill")
                                .font(.system(size: 30))
                        }.buttonStyle(PlayerButtonStyle())
                        Spacer()
                        Button(action: {
                            print("Show share to IG menu")
                        }) {
                            Image(systemName: "play.fill")
                                .font(.system(size: 50))
                        }.buttonStyle(PlayerButtonStyle())
                        Spacer()
                        Button(action: {
                            print("Show share to IG menu")
                        }) {
                            Image(systemName: "goforward.15")
                                .font(.system(size: 30))
                        }.buttonStyle(PlayerButtonStyle())
                        Spacer()
                    }
                }
                .foregroundColor(.primary)
            }
        }
        .animation(.interactiveSpring())
        .onAppear {
            animateUploading = false
        }
    }
}

private extension RecordView {
    var recordButton: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4)
                .foregroundColor(Color.accent3)
                .frame(width: buttonSize + 10, height: buttonSize + 10)
            
            switch audioRecorder.recorderState {
            case .ready:
                Button(action: {
                    audioRecorder.startRecording()
                    timerManager.start()
                }) {
                    Image(systemName: "mic.circle")
                        .resizable()
                        .frame(width: buttonSize, height: buttonSize)
                }.buttonStyle(PlayerButtonStyle())
            case .started:
//                    Text(String(format: "%.1f", timerManager.secondsElapsed))
//                        .font(.system(size: 16, weight: .bold, design: .rounded))
                Button(action: {
                    audioRecorder.stopRecording()
                    timerManager.stop()
                }) {
                    Image(systemName: "stop.circle.fill")
                        .frame(width: buttonSize, height: buttonSize)
                }
            case .stopped:
                Button(action: {
                    print("play recording")
                }) {
                    Image(systemName: "play.circle")
                }
            }
        }
    }
}

struct RecordingsView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView(viewControl: .constant(.create), user: testUser)
    }
}


struct PlayerButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding()
            .scaleEffect(configuration.isPressed ? 1.3 : 1.0)
    }
}
