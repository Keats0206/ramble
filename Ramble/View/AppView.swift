//
//  AppView.swift
//  Ramble
//
//  Created by Peter Keating on 4/22/20.
//  Copyright © 2020 Peter Keating. All rights reserved.

import SwiftUI
import Foundation
import MinimizableView

struct MainView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var globalPlayer: GlobalPlayer
    @ObservedObject var audioRecorder = AudioRecorder()
    @ObservedObject var viewModel = RambService2()
    
    @State var user: User
    @State var hidNav = false
    
    @State private var currentView: Tab = .tab1
    @State private var showModal: Bool = false
    
    var minimizableViewHandler: MinimizableViewHandler = MinimizableViewHandler()
    
    func getUser(){
        let uid = session.session!.id!
        UserService2.shared.fetchUser(uid: uid) { user in
            self.user = user
            return
        }
    }
    var body: some View {
        GeometryReader { proxy in
            NavigationView {
                VStack(spacing: 0) {
                    if self.currentView == .tab1 {
                        FeedView(user: user)
                    } else {
                        ProfileView(offset: CGSize(width: 0, height: -50), user: $user)
                    }
                    TabBar(currentView: self.$currentView, showModal: self.$showModal)
                }
            }
//            .minimizableView(
//                content: {
//                    BigPlayerView(ramb: testRamb, player: testPlayer)
//                }, compactView: {
//                    SmallPlayerView(ramb: testRamb)
//                }, geometry: proxy)
            .onAppear {
                self.getUser()
                self.minimizableViewHandler.settings.backgroundColor = Color.white
                self.minimizableViewHandler.settings.shadowColor = Color.clear
                self.minimizableViewHandler.settings.bottomMargin = 60
                self.minimizableViewHandler.settings.minimizedHeight = 60
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if globalPlayer.didSet{
                        self.minimizableViewHandler.present()
                        self.minimizableViewHandler.minimize()
                        print("DEBUG: presenting miniview handler")
                    } else {
                        print("DEBUG: No song ready")
                    }
                }
            }
            .sheet(isPresented: self.$showModal) {
                NavigationView {
                    RecorderView(currentTab: $currentView, user: user)
                }.tabItem {
                    HStack {
                        Image(systemName: "person.circle")
                        Text("Profile")                    }
                }
            }
            .environmentObject(self.minimizableViewHandler)
        }
    }
}

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
                    ProfileView(offset: CGSize(width: 0, height: -50), user: $user)
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
