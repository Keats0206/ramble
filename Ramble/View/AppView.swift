//
//  AppView.swift
//  Ramble
//
//  Created by Peter Keating on 4/22/20.
//  Copyright © 2020 Peter Keating. All rights reserved.

import SwiftUI

struct AppView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var globalPlayer: GlobalPlayer
    @ObservedObject var audioRecorder = AudioRecorder()
    @ObservedObject var viewModel = RambService()
    
    @State var user: User
    
    @State var hidNav = false
    @State var testModalShown = true
    
    let coloredNavAppearance = UINavigationBarAppearance()
    
    func getUser(){
        let uid = session.session!.uid
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
            return
        }
    }

    var body: some View {
        ZStack{
            
            Color.white.edgesIgnoringSafeArea(.all)
            
            TabView{
                
                NavigationView{
                        FeedView(user: user)
                }.tabItem {
                        Image(systemName: "dot.radiowaves.left.and.right")
                }.tag(0)
                    
                NavigationView{
                    ProfileView(user: user)
                }.tabItem {
                    Image(systemName: "person.circle")
                }.tag(1)
            }
        }.onAppear{
            self.getUser()
        }.accentColor(.black)
    }
}
