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

    func getUser(){
        let uid = session.session!.id!
        UserService2.shared.fetchUser(uid: uid) { user in
            self.user = user
            return
        }
    }
    
    @State var selectedProfile: User = testUser
    @State var openProfile: Bool = false

    var body: some View {
        ZStack {
            if openProfile {
                NavigationView {
                    ProfileView(user: $selectedProfile, showBackBtn: true, openProfile: $openProfile)
                }
            } else {
                TabView(selection: actionSelection) {
                    NowPlayingBar(ramb: globalPlayer.globalRambs?.first, selectedProfile: $selectedProfile, openProfile: $openProfile, content: FeedView(user: user))
                    .tabItem {
                        HStack {
                            Image(systemName: "music.house")
                            Text("Feed")
                        }
                    }.tag(0)
                   
                    NowPlayingBar(ramb: globalPlayer.globalRambs?.first, selectedProfile: $selectedProfile, openProfile: $openProfile, content: NavigationView {
                            ProfileView(user: $user, openProfile: .constant(false))
                        })
                    .tabItem {
                        HStack {
                            Image(systemName: "person.circle")
                            Text("Profile")
                        }
                    }.tag(1)
                }
                .onAppear {
                    self.getUser()
                }
            }
        }.accentColor(Color.accent3)
    }
}

//struct MainView: View {
//    @EnvironmentObject var session: SessionStore
//    @EnvironmentObject var globalPlayer: GlobalPlayer
//    @ObservedObject var audioRecorder = AudioRecorder()
//    @ObservedObject var viewModel = RambService2()
//
//    @State var user: User
//    @State var hidNav = false
//
//    @State private var currentView: Tab = .tab1
//    @State private var showModal: Bool = false
//
//    func getUser() {
//        let uid = session.session!.id!
//        UserService2.shared.fetchUser(uid: uid) { user in
//            self.user = user
//            return
//        }
//    }
//
//    var body: some View {
//        ZStack {
//            NavigationView {
//                VStack(spacing: 0) {
//                    if self.currentView == .tab1 {
//                        NowPlayingBar(content: FeedView(user: user))
//                    } else {
//                        NowPlayingBar(content:  ProfileView(user: $user))
//                    }
//                    TabBar(currentView: self.$currentView, showModal: self.$showModal)
//                }
//                .onAppear {
//                    self.getUser()
//                }
//                .sheet(isPresented: self.$showModal) {
//                    NavigationView {
//                        RecorderView(currentTab: $currentView, user: user)
//                    }.tabItem {
//                        HStack {
//                            Image(systemName: "person.circle")
//                            Text("Profile")                    }
//                    }
//                }
//            }
//        }
//    }
//}

struct TabBar: View {
    @Binding var currentView: Tab
    @Binding var showModal: Bool

    var body: some View {
        HStack {
            TabBarItem(currentView: self.$currentView, imageName: "list.bullet", title: "FEED", paddingEdges: .leading, tab: .tab1)
            Spacer()
            ShowModalTabBarItem(radius: 55) { self.showModal.toggle() }
            Spacer()
            TabBarItem(currentView: self.$currentView, imageName: "person.circle", title: "PROFILE", paddingEdges: .trailing, tab: .tab2)
        }.frame(minHeight: 70)
    }
}

struct CurrentScreen: View {
    @Binding var currentView: Tab
    @State var user: User

    var body: some View {
        VStack {
            if self.currentView == .tab1 {
                NavigationView {
                    FeedView(user: user)
                }
            } else {
                NavigationView {
                    ProfileView(user: $user, openProfile: .constant(false))
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

struct TabBarItem: View {
    @Binding var currentView: Tab
    let imageName: String
    let title: String
    let paddingEdges: Edge.Set
    let tab: Tab

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(5)
                .frame(width: 35, height: 35, alignment: .center)
                .cornerRadius(6)
            
            Text(title)
                .font(.system(size: 14, weight: .heavy, design: .rounded))
        }
        .foregroundColor(self.currentView == tab ? .accent4 : .flatDarkCardBackground)
        .frame(width: 140, height: 50)
        .onTapGesture { self.currentView = self.tab }
        .animation(.easeInOut)
        .padding(paddingEdges, 15)
    }
}

public struct ShowModalTabBarItem: View {
    let radius: CGFloat
    let action: () -> Void

    public init(radius: CGFloat, action: @escaping () -> Void) {
        self.radius = radius
        self.action = action
    }

    public var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "plus.rectangle")
                .resizable()
                .padding(5)
                .aspectRatio(contentMode: .fit)
                .frame(width: radius, height: radius, alignment: .center)
                .foregroundColor(Color.primary)
                .cornerRadius(radius/2)
        }
        .frame(width: radius, height: radius)
        .onTapGesture(perform: action)
    }
}

