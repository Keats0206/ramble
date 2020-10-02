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
    
    var user: User2
        
    init(user: User2) {
        self.user = user
    }
    
    var body: some View {
            ZStack{
                
                RambFeed(dataToggle: $dataSelector)

                FloatingPlayerView(hideNav: $hideNav)
                    .edgesIgnoringSafeArea(.all)
                
            }.navigationBarHidden(hideNav)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading:
                HStack{
                    Button(action: {
                        self.dataSelector = 0
                    }){
                        Text("FEED")
                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                            .foregroundColor(dataSelector == 0 ? Color.accent3 : Color.black)
                    }
                    Button(action: {
                        self.dataSelector = 1
                    }){
                        Text("FRIENDS")
                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                            .foregroundColor(dataSelector == 1 ? Color.accent3 : Color.black)
                    }
                }
            , trailing:
            HStack{
    //      Change to filter
                Button(action: {
                    print("Show filter modal")
                }){
                    Image(systemName: "line.horizontal.3.decrease.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
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
