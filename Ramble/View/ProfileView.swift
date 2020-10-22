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
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var globalPlayer: GlobalPlayer
    
    @State private var isShowing = false
    @State private var isPresented = false
    @State private var isFollowed = true
    @State private var editModal_shown = false
    @State private var settingsModal_shown = false
    @State private var searchModal_shown = false
    @State var hideNav = false
    
    @State var userDataToggle = 0
    
    @State var offset: CGSize
    
    @Binding var user: User
                
    var body: some View {
        
            ZStack{
                                    
                ScrollView{
                    
                    VStack(alignment: .leading, spacing: 10){
                        
                        WebImage(url: URL(string: user.profileImageUrl))
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .padding(.top, 50)
                        
                        Text(user.displayname)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                        
                        Text("@\(user.username)")
                            .font(.system(size: 22, weight: .heavy, design: .rounded))
                        
                        Text(user.bio)
                            .font(.system(size: 22, weight: .regular, design: .rounded))
                        
                        Spacer()
                        
                        HStack{
                            
                            Text("Rambles")
                                .font(.headline)
                            
                            Spacer()
                            
                        }
                        
                        Divider()
                                        
                    }.padding()
                        
                    RambUserFeed(user: user)
                    
                    Spacer()
                                    
                }.offset(offset)
                    .padding(0)
                                                        
                if globalPlayer.globalRamb != nil{
                    FloatingPlayerView(hideNav: $hideNav)
                        .edgesIgnoringSafeArea(.all)
                }
                
            }.navigationBarHidden(hideNav)
            .navigationBarItems(trailing:
                                    
                HStack{
                                    
                    Button(action: {
                        self.searchModal_shown.toggle()
                    }){
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .padding(5)
                    }.sheet(isPresented: $searchModal_shown, onDismiss: {
                        print("Modal dismisses")
                    }) {
                        
                        NavigationView{
                            
                            SearchView()
                        }
                    
                    }
                    
                    if Auth.auth().currentUser?.uid == user.id {
                        
                        Button(action: {
                            self.editModal_shown.toggle()
                        }){
                            Image(systemName: "ellipsis")
                                .padding(5)
                            
                        }.background(Capsule().fill(Color.black).opacity(0.2))
                        .sheet(isPresented: $editModal_shown, onDismiss: {
                            print("Modal dismisses")
                        }) {
                            EditProfileView(user: $user)
                        }
                        
                    } else {
                        
                        Spacer()
                }
        })
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(offset: CGSize(width: 0, height: 0), user: .constant(_user2))
            .environmentObject(SessionStore())
    }
}
