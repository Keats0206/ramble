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
    
    @State var hidNav = false
    @State var testModalShown = true
    
    
    func getUser(){
        let uid = session.session!.uid
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
            return
        }
    }
    
    var body: some View {
        ZStack{
            TabView{
                NavigationView{
                    FeedView(user: user, audioRecorder: AudioRecorder())
                }.tabItem {
                    Image(systemName: "person.circle")
                }.tag(0)
                
                NavigationView{
                    ProfileView(user: user)
                }.tabItem {
                    Image(systemName: "person.circle")
                }.tag(1)
            }
//            HalfModalView(isShown: $testModalShown, modalHeight: UIScreen.main.bounds.height){
//                Text("TestView")
//            }
        }.onAppear{
            self.getUser()
        }.environmentObject(SessionSettings())
        .accentColor(.red)
    }
}


//struct AppView_Previews: PreviewProvider {
//    static var previews: some View {
//        AppView()
//    }
//}
