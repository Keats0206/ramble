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
    
//    @State private var wave1 = false
    @State private var wave2 = false
//    @State private var wave3 = false
    
    var user: User2

    var body: some View {
        ZStack{
            
            ZStack{
                    
                    if audioRecorder.recording == false {

                        Button(action: {
                            self.audioRecorder.startRecording()
                        }) {
                            Image(systemName: "circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 75, height: 75)
                                .foregroundColor(.red)
                        }
                        
                    } else {

                        Circle()
                            .stroke(lineWidth: 5)
                            .frame(width: 90, height: 90)
                            .foregroundColor(.red)
                            .scaleEffect(wave2 ? 2 : 1)
                            .opacity(wave2 ? 0 : 1)
                            .animation(Animation.easeInOut(duration: 1).repeatForever().speed(0.5))
                            .onAppear{
                                self.wave2.toggle()
                            }

                        Button(action: {
                            self.audioRecorder.stopRecording()
                        }) {
                            Image(systemName: "square.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.red)

                        }
                    }
                }
            }
        .navigationBarHidden(false)
        .navigationBarItems(leading:
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }){
                Text("Cancel")
                    .font(.system(size: 20, weight: .heavy, design: .rounded))
                    .foregroundColor(Color.accent1)
            }, trailing:
            
                NavigationLink(destination: RecorderPostView(user: user)){
                Text("Preview")
                    .font(.system(size: 20, weight: .heavy, design: .rounded))
                    .foregroundColor(Color.accent4)
            }
        )
    }
}

struct RecorderView_Previews: PreviewProvider {
    static var previews: some View {
        RecorderView(user: _user2)
    }
}

struct RecorderPostView: View {
    @ObservedObject var audioRecorder = AudioRecorder()

    @State var caption = ""
    
    var user: User2
    
    func uploadRamb2(user: User2, caption: String, rambUrl: String, fileId: String){
        let timestamp = Int(NSDate().timeIntervalSince1970) * -1
        let isSelected = false
        let length = Double(0)
        
        let ramb = Ramb2(caption: caption, length: length, rambUrl: rambUrl, fileId: fileId, timestamp: timestamp, user: user, isSelected: isSelected)
        
        RambService2().addRamb(ramb)
    }

    var body: some View {
        VStack(alignment: .leading){
            
            TextField("What do you have to say", text: $caption)
                .font(.system(.largeTitle,design: .rounded))
                .fixedSize(horizontal: true, vertical: false)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }.navigationBarItems(trailing:
            Button(action: {
                self.uploadRamb2(
                    user: self.user,
                    caption: self.caption,
                    rambUrl: self.audioRecorder.rambUrl,
                    fileId: self.audioRecorder.rambFileID)
                }) {
                    Text("Post")
                        .font(.system(.headline,design: .rounded)).bold()
                        .foregroundColor(.red)
                }
            )
        }
    }

