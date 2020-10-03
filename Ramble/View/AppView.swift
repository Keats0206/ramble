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

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(user: _user2)
    }
}
