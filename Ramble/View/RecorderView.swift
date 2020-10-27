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
    @ObservedObject var audioRecorder = AudioRecorder()
    
    @State private var animateRecording = false
    @State var animateUploading = false
    @Binding var currentTab: Tab
    
    @State var isActive = false
//    @State private var wave3 = false
    
    var user: User

    var body: some View {
        ZStack{
            
            previewButton
            
            ZStack{
                
                switch audioRecorder.recorderState {
                
                    case .ready:
                        
                        Button(action: {
                            self.audioRecorder.startRecording()
                        }) {
                            Image(systemName: "circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 75, height: 75)
                                .foregroundColor(.red)
                        }
                        
                    case .started:
                        Button(action: {
                            self.audioRecorder.stopRecording()
                        }) {
                            Image(systemName: "square.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.red)
                                .overlay(
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
                        
                    case .stopped:
                        
                        LoadingAnimation()
                   
                    case .uploaded:
                        Spacer()
                            .onAppear {
                                self.isActive.toggle()
                    }
                }
            }
        }.onAppear{
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
            }){
                Text("Cancel")
                    .font(.system(size: 20, weight: .heavy, design: .rounded))
                    .foregroundColor(Color.accent4)
            })
    }
}

private extension RecorderView {
    var previewButton: some View {
        ZStack{
            NavigationLink(destination: RecorderPostView(rambUrl: audioRecorder.rambUrl, currentTab: $currentTab, user: user), isActive: $isActive){
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

struct LoadingAnimation: View{
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
