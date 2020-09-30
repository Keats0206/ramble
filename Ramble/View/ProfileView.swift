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
    @ObservedObject var viewModel = RambService()
    
    @State private var isShowing = false
    
    @State private var isPresented = false
    @State private var editModal_shown = false
    @State private var isFollowed = true
    
    @State var hideNav = false
    
    var user: User
    
    init(_ model: RambService, user: User){
            self.viewModel = model
            self.user = user
            model.fetchUserRambs(forUser: user) { ramb in
            return
        }
    }
            
    var body: some View {
        
            ZStack{
                
                ScrollView{
                    
                    VStack(alignment: .leading){
                        
                        WebImage(url: user.profileImageUrl)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        
                        Text("\(user.fullname)")
                            .font(.system(size: 35))
                            .fontWeight(.heavy)
                        
                        Text("@\(user.username)")
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                        
                        Text("\(user.bio)")
                            .font(.system(size: 16))
                        
                        Spacer()
                        
                    }
                        
                    HStack{
                        
                        Text("Rambles")
                            .font(.headline)
                        
                        Spacer()
                        
                    }.padding()
                    
                    Spacer()
                    
                    VStack{
                                            
                        ForEach(viewModel.userRambs){ramb in
                            RambUserCell(ramb: ramb)
                        
                        }
                    
                    }

                                    
                }
                    .padding()
                
                FloatingPlayerView(hideNav: $hideNav)
                    .edgesIgnoringSafeArea(.all)
//
//                ZStack{
//                    SettingsView(isPresented: $isPresented)
//                }.edgesIgnoringSafeArea(.all)
//                .offset(x: 0, y: self.isPresented ? 0 : UIApplication.shared.currentWindow?.frame.height ?? 0)
//                ZStack{
//                    EditProfileView(editProfileShown: $editModal_shown, user: user)
//                }.edgesIgnoringSafeArea(.all)
//                .offset(x: 0, y: self.editProfileShown ? 0 : UIApplication.shared.currentWindow?.frame.height ?? 0)
                
            }.navigationBarHidden(hideNav)
            .navigationBarTitle("\(user.username)")
            .navigationBarItems(trailing:
                HStack{
                    if user.isCurrentUser == false {
                        Button(action: {
                            self.editModal_shown.toggle()
                        }){
                            Image(systemName: "ellipsis")
                                .padding(5)
                        }.background(Capsule().fill(Color.black).opacity(0.2))
                        .sheet(isPresented: $editModal_shown, onDismiss: {
                            print("Modal dismisses")
                        }) {
                            EditProfileView(user: user)
                        }
                    } else {
                        
                        Button(action: {
                            if self.isFollowed {
                                UserService.shared.unfollowUser(uid: self.user.uid)
                                self.isFollowed.toggle()
                            } else {
                                UserService.shared.followUser(uid: self.user.uid)
                                self.isFollowed.toggle()
                            }
                        }){
                            Text(self.isFollowed ? "Unfollow":"Follow")
                                .padding(5)
                                .padding([.trailing,.leading])
                        }.background(Capsule().fill(Color.black).opacity(0.2))
                }
        })
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(RambService(), user: _user)
    }
}
