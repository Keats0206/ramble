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
    
    @ObservedObject var timerManager = TimerManager()
    @ObservedObject var audioRecorder = AudioRecorder()
    
    @State private var animateRecording = false
    @State var animateUploading = false
    @Binding var currentTab: Tab
    @State var length = 0.0
    
    @State var isActive = false
//    @State private var wave3 = false
    
    var user: User

    var body: some View {
        ZStack{
            previewButton
            ZStack {
                switch audioRecorder.recorderState {
                case .ready:
                        VStack{
                            Spacer()
                            Text(String(format: "%.1f", timerManager.secondsElapsed))
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .padding(.top, 300)
                            Button(action: {
                                self.audioRecorder.startRecording()
                                self.timerManager.start()
                            }) {
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.red)
                            }
                        }.padding()
                case .started:
                        VStack {
                            Spacer()
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
                    LoadingAnimation()//leading animation
                case .uploaded:
                    Spacer()// Sends user to the next view
                        .onAppear {
                            self.isActive.toggle()
                }
                }
            }
        }.onAppear {
            animateUploading = false
            if currentTab == .profile {
                currentTab = .tab2
                presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationBarHidden(false)
        .navigationBarItems(leading:
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel")
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(Color.accent3)
            })
    }
}

private extension RecorderView {
    var previewButton: some View {
        ZStack{
            NavigationLink(destination: RecorderPostView(rambUrl: audioRecorder.rambUrl, length: length, currentTab: $currentTab, user: user), isActive: $isActive){
                Spacer()
            }
        }
    }
}

struct RecorderView_Previews: PreviewProvider {    
    static var previews: some View {
        RecorderView(currentTab: .constant(Tab.tab1), user: testUser)
    }
}

struct LoadingAnimation: View {
    @State var animateUploading = false

    var body: some View {
        HStack {
            Circle()
                .fill(Color.accent1)
                .frame(width: 20, height: 20)
                .scaleEffect(animateUploading ? 1.0 : 0.5)
                .animation(Animation.easeInOut(duration: 0.5).repeatForever())
            Circle()
                .fill(Color.accent3)
                .frame(width: 20, height: 20)
                .scaleEffect(animateUploading ? 1.0 : 0.5)
                .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.3))
            Circle()
                .fill(Color.accent2)
                .frame(width: 20, height: 20)
                .scaleEffect(animateUploading ? 1.0 : 0.5)
                .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.6))
                }
        .onAppear {
            self.animateUploading = true
        }
    }
}
