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
    @Binding var length: Double
    @Binding var rambUrl: String
    
    @State private var animateRecording = false
    @State var openAudioUpload = false
    
    @State var animateUploading = false
    
    @State var isActive = false
        
    var user: User

    var body: some View {
        ZStack {
            switch audioRecorder.recorderState {
                case .ready:
                    VStack(alignment: .center){
                            Text(String(format: "%.1f", timerManager.secondsElapsed))
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                            Button(action: {
                                self.audioRecorder.startRecording()
                                self.timerManager.start()
                            }) {
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.red)
                                }.padding(.horizontal, 50)
                            Spacer()
                        }.padding()
                    
                case .started:
                    VStack(alignment: .center){
                            Text(String(format: "%.1f", timerManager.secondsElapsed))
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                            Button(action: {
                                self.audioRecorder.stopRecording()
                                self.length = self.timerManager.secondsElapsed
                                self.timerManager.stop()
                            }) {
                                Image(systemName: "pause.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.red)
                                    .background(
                                        ZStack {
                                            Circle()
                                                .stroke(Color.red, lineWidth: 100)
                                                            .scaleEffect(animateRecording ? 1 : 0)
                                                        Circle()
                                                            .stroke(Color.red, lineWidth: 100)
                                                            .scaleEffect(animateRecording ? 1.5 : 0)
                                                        Circle()
                                                            .stroke(Color.red, lineWidth: 100)
                                                            .scaleEffect(animateRecording ? 2 : 0)
                                                    }
                                                    .opacity(animateRecording ? 0.0 : 0.2)
                                                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: false))
                                            )
                            .onAppear {
                                self.animateRecording = true
                                }
                            }
                        }.padding()
                    
                case .stopped:
                    LoadingAnimation() //leading animation
                case .uploaded:
                    Spacer()// Sends user to the next view
                        .onAppear {
                            isActive.toggle()
                            position = CardPosition.middle
                            rambUrl = audioRecorder.rambUrl
//                          Update global player with player
//                          Set card to medium view with player
//                          Call ramb service to create ramb
                            
                    }
                }
        }
        .onAppear {
            animateUploading = false
        }
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecorderView(currentTab: .constant(Tab.tab1), user: testUser)
    }
}
