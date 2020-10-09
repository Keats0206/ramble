//
//  AppView.swift
//  Ramble
//
//  Created by Peter Keating on 4/22/20.
//  Copyright © 2020 Peter Keating. All rights reserved.

import SwiftUI
import Foundation

struct AppView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var globalPlayer: GlobalPlayer
    @ObservedObject var audioRecorder = AudioRecorder()
    @ObservedObject var viewModel = RambService2()
    
    @State var user: User
    @State var hidNav = false
    @State var recordingModal_shown = false
    @State private var selection = 0
    
    private var actionSelection: Binding<Int> {
        Binding<Int>(get: {
            self.selection
        }) { (newValue: Int) in
            if newValue == 1 {
                self.recordingModal_shown = true
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
    
    var body: some View {
        ZStack{
            TabView(selection: actionSelection){
                NavigationView{
                    FeedView(user: user)
                }.tabItem {
                    HStack{
                        Image(systemName: "dot.radiowaves.left.and.right")
                        Text("Feed")
                    }
                }.tag(0)
                
                Text("Second Screen")
                    .tabItem {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 50)
                }.tag(1)
                
                NavigationView{
                    ProfileView(offset: CGSize(width: 0, height: -50), user: user)
                }.tabItem {
                    HStack {
                        Image(systemName: "person.circle")
                        Text("Profile")
                    }
                }.tag(2)
                
            }.sheet(isPresented: $recordingModal_shown, onDismiss: {
                print("Modal dismisses")
            }) {
                NavigationView{
                    RecorderView(user: user)
                }
            }
                .onAppear{
                self.getUser()
            }.accentColor(.black)
            
            }
    }
}

//struct AppView_Previews: PreviewProvider {
//    static var previews: some View {
//        AppView(user: _user2)
//    }
//}

struct MainView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var globalPlayer: GlobalPlayer
    @ObservedObject var audioRecorder = AudioRecorder()
    @ObservedObject var viewModel = RambService2()
    
    @State var user: User
    @State var hidNav = false
    
    @State private var currentView: Tab = .Tab1
    @State private var showModal: Bool = false
    
    func getUser(){
        let uid = session.session!.id!
        UserService2.shared.fetchUser(uid: uid) { user in
            self.user = user
            return
        }
    }
    
    var body: some View {
            VStack {
                CurrentScreen(currentView: self.$currentView, user: user)
                TabBar(currentView: self.$currentView, showModal: self.$showModal)
            }.background(Color(.white))
            .onAppear{
                self.getUser()
            }
            .sheet(isPresented: self.$showModal) {
                NavigationView{
                    RecorderView(user: user)
                }
        }
    }
}

struct TabBar: View {
    @Binding var currentView: Tab
    @Binding var showModal: Bool

    var body: some View {
        HStack {
            TabBarItem(currentView: self.$currentView, imageName: "list.bullet", title: "feed", paddingEdges: .leading, tab: .Tab1)
            Spacer()
            ShowModalTabBarItem(radius: 55) { self.showModal.toggle() }
            Spacer()
            TabBarItem(currentView: self.$currentView, imageName: "person.circle", title: "profile", paddingEdges: .trailing, tab: .Tab2)
        }
        .frame(minHeight: 70)
    }
}


struct CurrentScreen: View {
    @Binding var currentView: Tab
    var user: User

    var body: some View {
        VStack {
            if self.currentView == .Tab1 {
                NavigationView{
                    FeedView(user: user)
                }
            } else {
                NavigationView{
                    ProfileView(offset: CGSize(width: 0, height: -50), user: user)
                }
            }
        }
    }
}

enum Tab {
    case Tab1
    case Tab2
}

struct TabBarItem: View {
    @Binding var currentView: Tab
    let imageName: String
    let title: String
    let paddingEdges: Edge.Set
    let tab: Tab

    var body: some View {
        HStack(spacing:5) {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(5)
                .frame(width: 35, height: 35, alignment: .center)
                .cornerRadius(6)
            
            Text(title)
                .font(.system(size: 20, weight: .heavy, design: .rounded))
        }
        .foregroundColor(self.currentView == tab ? .flatDarkBackground : .gray)
        .frame(width: 120, height: 50)
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
        VStack(spacing:0) {
            Image(systemName: "plus.rectangle")
                .resizable()
                .padding(5)
                .aspectRatio(contentMode: .fit)
                .frame(width: radius, height: radius, alignment: .center)
                .foregroundColor(Color.flatDarkBackground)
                .background(Color(.white))
                .cornerRadius(radius/2)

        }
        .frame(width: radius, height: radius)
        .onTapGesture(perform: action)
    }
}
