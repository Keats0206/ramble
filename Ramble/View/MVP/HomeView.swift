//
//  HomeView.swift
//  Ramble
//
//  Created by Peter Keating on 11/19/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @State var user: User
    @State var showProfile: Bool = false
    @Binding var position: CardPosition
    @State var showList: Bool = false
    
    var body: some View {
        NavigationView{
            RecordingsList()
                .navigationBarTitle("Ramble", displayMode: .large)
                .navigationBarItems(leading:
                    Button(action: {
                        self.showProfile.toggle()
                    }) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.accent3)
                    }.sheet(isPresented: $showProfile, onDismiss: {
                        print("Modal dismisses")
                    }) {
                        EditProfileView(user: $user)
                    }, trailing:
                    
                    Button(action: {
                        self.position = CardPosition.top
                    }) {
                        Image(systemName: "music.note.list")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.accent3)
                }
            )
        }
    }
}
