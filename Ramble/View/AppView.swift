//
//  AppView.swift
//  Ramble
//
//  Created by Peter Keating on 4/22/20.
//  Copyright © 2020 Peter Keating. All rights reserved.

import SwiftUI

struct AppView: View {
    @EnvironmentObject var session: SessionStore
    @ObservedObject var audioRecorder: AudioRecorder
    @State var user: User
    
    func getUser(){
        let uid = session.session!.uid
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
            return
        }
    }
    
    var body: some View {
           
        TabView{
            
                
                FeedView(user: user, audioRecorder: AudioRecorder()).tabItem {
                                            
                    Image(systemName: "dot.radiowaves.left.and.right")
                                        
                }.tag(0)
                
                ProfileView(user: user).tabItem {
                    
                    Image(systemName: "person.circle")
                                        
                }.tag(1)
                
        
        }.onAppear{
            
            self.getUser()
        
        }.accentColor(.red)
        .environmentObject(SessionSettings())
    }
}
