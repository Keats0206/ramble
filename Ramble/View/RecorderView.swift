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
//    @State private var wave3 = false
    
    var user: User

    var body: some View {
        ZStack{
                    
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
                        previewButton
                            .onAppear {
                    }
                }
            }
        }.onAppear{
            animateUploading = false
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
            NavigationLink(destination: RecorderPostView(rambUrl: audioRecorder.rambUrl, user: user)){
                if audioRecorder.recorderState != .uploaded {
                    Spacer()
                } else {
                    Text("Preview")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .foregroundColor(Color.accent1)
                }
            }
        }
    }
}

struct RecorderView_Previews: PreviewProvider {    
    static var previews: some View {
        RecorderView(user: _user2)
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

struct RecorderPostView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var audioRecorder = AudioRecorder()

    @State var caption = ""
    @State var rambUrl: String
    
    var user: User
    
    func uploadRamb2(user: User, caption: String, rambUrl: String, fileId: String){
        let timestamp = Int(NSDate().timeIntervalSince1970) * -1
        let isSelected = false
        let length = Double(0)
        let uid = user.id!
        
        let ramb = Ramb2(caption: caption, length: length, rambUrl: rambUrl, fileId: fileId, timestamp: timestamp, plays: 0, user: user, uid: uid, isSelected: isSelected)
        
        RambService2().addRamb(ramb)
    }

    var body: some View {
        
        VStack(alignment: .leading){
            
            TextField("What do you have to say", text: $caption)
                .font(.system(.largeTitle,design: .rounded))
                .fixedSize(horizontal: true, vertical: false)
                .multilineTextAlignment(.leading)
            
            Spacer()
        
        }.padding()
        .navigationBarItems(trailing:
            Button(action: {
//                print(self.rambUrl)
                self.uploadRamb2(
                    user: user,
                    caption: caption,
                    rambUrl: rambUrl,
                    fileId: ""
                )
                presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Post")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .foregroundColor(.accent4)
                }
            )
        }
    }
