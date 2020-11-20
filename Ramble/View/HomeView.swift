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
    
    var body: some View {
        ZStack{
            VStack{
                RambUserList(user: user)
            }
        }
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
            }
        )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(user: testUser)
    }
}
