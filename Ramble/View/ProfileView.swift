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
    
    var showBackBtn: Bool = false
    @Binding var openProfile: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
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
                            HStack(alignment: .bottom) {
                                Text("\(user.displayname.uppercased())")
                                    .font(.system(size: 50, weight: .heavy))
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
        }
        .navigationBarTitle("", displayMode: .large)
        .navigationBarItems(
            leading:
                ZStack {
                    if showBackBtn {
                        backButton
                    }
                }
            ,
            trailing:
                ZStack {
                    if Auth.auth().currentUser?.uid == user.id {
                        editProfileButton
                    }
                }
        ).edgesIgnoringSafeArea(.top)
    }
}

struct UserAbout: View {
    var user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("@\(user.username)")
                .font(.system(.title, design: .rounded))
                .bold()
            Text("\(user.bio)")
                .font(.system(.headline, design: .rounded))
                .opacity(0.4)
                .padding(.bottom)
            Divider()
        }.padding()
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
                .foregroundColor(Color.accent3))
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
    
    var backButton: some View {
        Button(action: {
            self.openProfile = false
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(Color.accent3)
                .frame(width:30, height: 30)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(15)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: .constant(testUser), openProfile: .constant(false))
            .environmentObject(SessionStore())
    }
}
