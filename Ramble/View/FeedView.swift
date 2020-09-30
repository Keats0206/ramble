//
//  FeedView.swift
//  Ramble
//
//  Created by Peter Keating on 6/15/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var globalPlayer: GlobalPlayer
    
    @ObservedObject var audioRecorder = AudioRecorder()
    @ObservedObject var userModel = UserService()
    
    @State var recordingModal_shown = false
    @State var searchModal_shown = false
    @State var dataSelector = 0
    @State var ramb: Ramb?
    
    @State var hideNav = false

    private var feedtoggle = ["Hot", "New"]
    
    var user: User
        
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
            ZStack{
                
                RambFeed(RambService(), dataToggle: $dataSelector)

                FloatingPlayerView(hideNav: $hideNav)
                    .edgesIgnoringSafeArea(.all)
                
            }.navigationBarHidden(hideNav)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading:
                    HStack{
                        Button(action: {
                            self.dataSelector = 0
                        }){
                            Text("FRIENDS")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(dataSelector == 0 ? Color.accent3 : Color.black)
                            
                        }
                        Button(action: {
                            self.dataSelector = 1
                        }){
                            Text("FEED")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(dataSelector == 1 ? Color.accent3 : Color.black)
                    }
                }
            , trailing: HStack{
//                Change to filter                
                    Button(action: {
                        self.recordingModal_shown.toggle()
                    }){
                        Image(systemName: "mic.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .padding(5)
                    }.background(Capsule().fill(Color.black).opacity(0.2))
                    .sheet(isPresented: $recordingModal_shown, onDismiss: {
                        print("Modal dismisses")
                    }) {
                        NavigationView{
                            RecorderView(audioRecorder: AudioRecorder())
                        }
                    }
            })
        }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(user: _user)
            .environmentObject(SessionStore())
            .environmentObject(GlobalPlayer())
    }
}
