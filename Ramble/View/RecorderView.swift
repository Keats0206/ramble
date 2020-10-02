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
                        
                    case .stopped:
                        Text("Uploading")
                   
                    case .uploaded:
                        Text("Done")
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
                previewButton
        )
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
                        .foregroundColor(Color.accent4)
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

struct RecorderPostView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var audioRecorder = AudioRecorder()

    @State var caption = ""
    @State var rambUrl: String
    
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
                        .font(.system(.headline,design: .rounded)).bold()
                        .foregroundColor(.red)
                }
            )
        }
    }
