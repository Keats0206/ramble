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
    
    @Binding var position: CardPosition
    
    @State private var animateRecording = false
    @State var openAudioUpload = false
    @State var animateUploading = false
    @State var isActive = false
    @State var txt = ""
    
    var user: User
    
    var body: some View {
        ZStack {
            
            if position == .bottom {
                
                HStack{
                    
                    TextField("Record to share your voice", text: $txt)
                        .font(.headline)
                    
                    Spacer()
                    
                    recordButton
                            
                }.padding()
            }
            
            if position == .middle {
                
                VStack(spacing: 40) {
                    
                    HStack {
                        
                        Spacer()
                    
                        Text("Share")
                    
                    }
                    
                    HStack {
                        
                        VStack(alignment: .leading){
                            
                            Text("11/12")
                                .font(.subheadline)
                                .bold()
                                .opacity(0.5)
                            
                            TextField("Record to share your voice", text: $txt)
                                .font(.headline)
                        }
                        
                        Spacer()
                        
                        Text("3:30")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                    
                    }.padding(.bottom)
                    
                    HStack {
                        
                        Button(action: {
                            position = CardPosition.bottom
                            txt = ""
                            audioRecorder.recorderState = .ready
                        }) {
                            Text("Cancel")
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 50) {
                            Button(action: {
                                print("Show share to IG menu")
                            }) {
                                Image(systemName: "backward.end.fill")
                            }
                                
                            recordButton
                                
                            Button(action: {
                                print("Show share to IG menu")
                            }) {
                                Image(systemName: "goforward.15")
                            }
                        }
                        .foregroundColor(Color.primary)
                        
                        Spacer()
                        
                        Button(action: {
                            print("Done")
                        }){
                            Text("Done")
                        }
                    }
                
                }
                .padding()
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
        VStack {
            switch audioRecorder.recorderState {
            case .ready:
                Button(action: {
                    audioRecorder.startRecording()
                    timerManager.start()
                }) {
                    Image(systemName: "mic.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.red)
                }
            case .started:
//                    Text(String(format: "%.1f", timerManager.secondsElapsed))
//                        .font(.system(size: 16, weight: .bold, design: .rounded))
                Button(action: {
                    audioRecorder.stopRecording()
                    timerManager.stop()
                }) {
                    Image(systemName: "pause.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.red)
//                        .background(
//                            ZStack {
//                                Circle()
//                                    .stroke(Color.red, lineWidth: 100)
//                                    .scaleEffect(animateRecording ? 1 : 0)
//                                Circle()
//                                    .stroke(Color.red, lineWidth: 100)
//                                    .scaleEffect(animateRecording ? 1.5 : 0)
//                                Circle()
//                                    .stroke(Color.red, lineWidth: 100)
//                                    .scaleEffect(animateRecording ? 2 : 0)
//                            }
//                            .opacity(animateRecording ? 0.0 : 0.2)
//                            .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: false))
//                        )
                        .onAppear {
                            self.animateRecording = true
                        }
                }
            case .stopped:
                LoadingAnimation() //leading animation
            case .uploaded:
                Spacer()// Sends user to the next view
                    .onAppear {
                        isActive.toggle()
                        position = CardPosition.bottom
            }
        }
        }
    }
}
