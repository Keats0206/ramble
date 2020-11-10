
//  ContentView.swift
//  Ramble
//
//  Created by Peter Keating on 4/22/20.
//  Copyright © 2020 Peter Keating. All rights reserved.


import SwiftUI

@available(iOS 14.0, *)
struct ContentView : View {
    @EnvironmentObject var session: SessionStore

    func getUser () {
        session.listen()
    }
    var body: some View {
        Group {
            if (session.session != nil) {
                MainView(user: session.session!)
            } else {
                AuthView()
            }
        }.onAppear(perform: getUser)
    }
}

#if DEBUG

@available(iOS 14.0, *)
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SessionStore())
    }
}
#endif

