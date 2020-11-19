//
//  AppView.swift
//  Ramble
//
//  Created by Peter Keating on 4/22/20.
//  Copyright © 2020 Peter Keating. All rights reserved.

import SwiftUI
import Foundation
import MinimizableView

struct AppView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var globalPlayer: GlobalPlayer
    @ObservedObject var audioRecorder = AudioRecorder()
    @ObservedObject var viewModel = RambService2()

    @State var user: User    
    @State var hidNav = false
    @State var recordingModalShown = false
    @State private var selection = 0
    
    @State private var position = CardPosition.bottom
    @State private var background = BackgroundStyle.blur
    
    @State var actionState: Int? = 0
    @State var selectedUser: User = testUser

    private var actionSelection: Binding<Int> {
        Binding<Int>(get: {
            self.selection
        }) { (newValue: Int) in
            if newValue == 1 {
                self.recordingModalShown = true
            } else {
                self.selection = newValue
            }
        }
    }

    func getUser() {
        let uid = session.session!.id!
        UserService2.shared.fetchUser(uid: uid) { user in
            self.user = user
            return
        }
    }
    
    var body: some View {
        ZStack {
            
            FeedView(user: user, actionState: $actionState, selectedUser: $selectedUser)
                .environmentObject(globalPlayer)
            
                SlideOverCard($position, backgroundStyle: $background) {
                    ZStack(alignment: .top){
                        NowPlayingCard(position: $position, actionState: $actionState, selectedUser: $selectedUser, ramb: globalPlayer.globalRambs?.first)
    //                    switch position {
    //
    //                    case CardPosition.bottom:
    //                        Text("Bottom")
    //                            .font(.title)
    //
    //                    case CardPosition.middle:
    //                        Text("Middle")
    //                            .font(.title)
    //                            .onTapGesture {
    //                                self.actionState = 1
    //                            }
    //                    case CardPosition.top:
    //                        Text("Top")
    //                            .font(.title)
    //                    }
                }
            }
            
                
//            TabView(selection: actionSelection) {
//                NowPlayingBar(ramb: globalPlayer.globalRambs?.first, content: FeedView(user: user).environmentObject(globalPlayer))
//                    .tabItem {
//                        HStack {
//                            Image(systemName: "music.house")
//                            Text("Feed")
//                        }
//                    }.tag(0)
//
//                    NowPlayingBar(ramb: globalPlayer.globalRambs?.first, content: NavigationView {
//                            ProfileView(user: $user)
//                        })
//                    .tabItem {
//                        HStack {
//                            Image(systemName: "person.circle")
//                            Text("Profile")
//                        }
//                    }.tag(1)
//                }
        }.accentColor(Color.accent3)
        .onAppear {
            self.getUser()
        }
    }
}

struct CurrentScreen: View {
    @Binding var currentView: Tab
    @Binding var actionState: Int?
    @Binding var selectedUser: User
    @State var user: User

    var body: some View {
        VStack {
            if self.currentView == .tab1 {
                NavigationView {
                    FeedView(user: user, actionState: $actionState, selectedUser: $selectedUser)
                }
            } else {    
                NavigationView {
                    ProfileView(user: user)
                }
            }
        }
    }
}

enum Tab {
    case tab1
    case tab2
    case profile
}
