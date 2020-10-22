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
    @ObservedObject var userModel = UserService2()
    
    @State var recordingModal_shown = false
    @State var searchModal_shown = false
    @State var dataToggle = 0
    @State var ramb: Ramb2?
    
    @State var hideNav = false

    private var feedtoggle = ["Hot", "New"]
    
    var user: User
        
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
        ZStack{
            RambFeed(dataToggle: $dataToggle)
            if globalPlayer.globalRamb != nil {
                FloatingPlayerView(hideNav: $hideNav)
                    .edgesIgnoringSafeArea(.all)
                    .clipped()
                    .shadow(color: .gray, radius: 2, x: 0.0, y: -3)
            }
        }.navigationBarHidden(hideNav)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(
            leading:
                HStack{
                    Text("RAMBLE")
                        .font(.system(size: 30, weight: .heavy, design: .rounded))
                        .foregroundColor(Color.accent3)
                }, trailing:
            HStack{
                Button(action: {
                    self.dataToggle = 0
                }) { 
                    Image(systemName: dataToggle == 0 ? "clock.fill" : "clock")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(dataToggle == 0 ? Color.accent4 : Color.flatDarkCardBackground)
                        .padding(5)
                }
            
                Button(action: {
                    self.dataToggle = 1
                }) {
                    Image(systemName: dataToggle == 1 ? "flame.fill" : "flame")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(dataToggle == 1 ? Color.accent4 : Color.flatDarkCardBackground)
                        .padding(5)
                }
            }
        )
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(user: _user2)
            .environmentObject(SessionStore())
            .environmentObject(GlobalPlayer())
    }
}
