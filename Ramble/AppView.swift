//
//  AppView.swift
//  Ramble
//
//  Created by Peter Keating on 4/22/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct AppView: View {
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.gray
//        UITabBar.appearance().isTranslucent = false

    }
    
    var body: some View {
    
        ZStack {

            TabView {

                ProfileView(audioRecorder: AudioRecorder()).tabItem {

                    Image(systemName: "person").resizable()

                }.tag(0)

                HomeView().tabItem {

                    Image(systemName: "dot.radiowaves.left.and.right")

                }.tag(1)

//                CreateView().tabItem {
//
//                    Image(systemName: "ear")
//
//                }.tag(3)
            
            }.accentColor(.red)
        }
    }
}

struct AppView_Previews : PreviewProvider {
    static var previews: some View {
        AppView().environmentObject(SessionStore())
    }
}
