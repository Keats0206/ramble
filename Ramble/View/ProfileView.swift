//
//  ProfileView.swift
//  Ramble
//
//  Created by Peter Keating on 9/3/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI

//TODO: Bring a user into this view...pass that same user down into the profile header and profile feed
struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var globalPlayer: GlobalPlayer
    
    @State private var isShowing = false
    @State private var isPresented = false
    @State private var isFollowed = true
    @State private var editModalShown = false
    @State private var settingsModalShown = false
    @State private var searchModalShown = false
    @State var hideNav = false
    
    @State var userDataToggle = 0
        
    @Binding var user: User
    
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                ZStack {
                    if geometry.frame(in: .global).minY <= 0 {
                        WebImage(url: URL(string: user.profileImageUrl))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .offset(y: geometry.frame(in: .global).minY/9)
                            .clipped()
                    } else {
                        WebImage(url: URL(string: user.profileImageUrl))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height + geometry.frame(in: .global).minY)
                            .clipped()
                            .offset(y: -geometry.frame(in: .global).minY)
                    }
                    VStack(alignment: .leading){
                        Spacer()
                        HStack(alignment: .bottom){
                            Text("\(user.displayname)")
                                .font(.system(size: 50, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }.padding()
                }
            }.frame(height: 400)
            UserAbout(user: user)
            RambUserFeed(user: user)
                .frame(width: 350)
        }
        .navigationBarTitle("", displayMode: .large)
        .navigationBarItems(trailing:
            HStack {
                if Auth.auth().currentUser?.uid == user.id {
                    editProfileButton
                } else {
                    Spacer()
            }
        })
        .edgesIgnoringSafeArea(.top)
    }
}

struct UserAbout: View {
    var user: User
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("@\(user.username)")
                .font(.system(.headline, design: .rounded))
                .bold()
            Text("\(user.bio)")
                .font(.system(.body, design: .rounded))
                .opacity(0.8)
                .padding(.bottom)
            Divider()
        }.padding([.leading, .trailing])
    }
}

private extension ProfileView {
    var editProfileButton: some View {
        Button(action: {
            self.editModalShown.toggle()
        }) {
            Circle()
                .foregroundColor(Color.flatDarkCardBackground.opacity(0.2))
                .frame(width: 25, height: 25)
                .overlay(Image(systemName: "ellipsis")
                .foregroundColor(Color.secondary))
        }.sheet(isPresented: $editModalShown, onDismiss: {
            print("Modal dismisses")
        }) {
            EditProfileView(user: $user)
        }
    }
    var searchButton: some View {
        Button(action: {
            self.searchModalShown.toggle()
        }) {
            Circle()
                .foregroundColor(Color.flatDarkCardBackground.opacity(0.2))
                .frame(width: 25, height: 25)
                .overlay(Image(systemName: "magnifyingglass").foregroundColor(Color.flatDarkBackground))
        }.sheet(isPresented: $searchModalShown, onDismiss: {
            print("Modal dismisses")
        }) {
            NavigationView {
                SearchView()
            }
        }

    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: .constant(testUser))
            .environmentObject(SessionStore())
    }
}
