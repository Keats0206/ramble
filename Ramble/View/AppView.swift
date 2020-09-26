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
                        Image(systemName: "person.circle")
                }.tag(0)
                    
                NavigationView{
                    ProfileView(user: user)
                }.tabItem {
                    Image(systemName: "person.circle")
                }.tag(1)
            }
            
//            ZStack{
//                SearchView(isPresented: $searchModal_shown, hideNav: $hideNav)
//            }.edgesIgnoringSafeArea(.all)
//            .offset(x: 0, y: self.searchModal_shown ? 10 : UIApplication.shared.currentWindow?.frame.height ?? 0)
//
//            HalfModalView(isShown: $testModalShown, modalHeight: UIScreen.main.bounds.height){
//                Text("TestView")
//            }
        }.onAppear{
            self.getUser()
        }.accentColor(.red)
    }
}


extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()

        let appearance = UINavigationBarAppearance()
        
        // this overrides everything you have set up earlier.
        appearance.configureWithTransparentBackground()
        
//        // this only applies to big titles
//        appearance.largeTitleTextAttributes = [
//            .font : UIFont.systemFont(ofSize: 20),
//            NSAttributedString.Key.foregroundColor : UIColor.white
//        ]
//        // this only applies to small titles
//        appearance.titleTextAttributes = [
//            .font : UIFont.systemFont(ofSize: 20),
//            NSAttributedString.Key.foregroundColor : UIColor.white
//        ]
//
        //In the following two lines you make sure that you apply the style for good
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        
        // This property is not present on the UINavigationBarAppearance
        // object for some reason and you have to leave it til the end
        UINavigationBar.appearance().backgroundColor = .white
    }
}
