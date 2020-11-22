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
    
    var body: some View {
        NavigationView{
            RecordView(position: $position, user: user)
                .navigationBarTitle("Ramble", displayMode: .large)
                .navigationBarItems(leading:
                    Button(action: {
                        self.showProfile.toggle()
                    }) {
                        Circle()
                            .foregroundColor(Color.flatDarkCardBackground.opacity(0.2))
                            .frame(width: 25, height: 25)
                            .overlay(Image(systemName: "person.circle.fill")
                            .foregroundColor(Color.accent3))
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

struct BottomSheet: View {
    @State var txt = ""

    var body: some View {
        VStack {
            HStack {
                Text("Recordings")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }.padding(.horizontal)
            RecordingsList()
        }
        .cornerRadius(15)
    }
}
