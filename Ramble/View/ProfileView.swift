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
    
    @State private var isPresented = false
    @State var isFollowed = true
    
    var user: User
            
    var body: some View {
        
        ZStack{
            
            NavigationView{
                
                ZStack{
            
                    VStack(alignment: .leading){
                        
                        VStack(alignment: .leading, spacing: 5){
                            
                                WebImage(url: user.profileImageUrl)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            
                                Text("\(user.fullname)")
                                    .font(.system(size: 35))
                                    .fontWeight(.heavy)
                                
                                Text("@\(user.username)")
                                    .font(.system(size: 25))
                                    .fontWeight(.bold)
                            
                                Text("\(user.bio!)")
                                    .font(.system(size: 16))
                                                        
                                HStack{
                                    
                                    Text("Rambles")
                                        .font(.headline)
                                    
                                    Spacer()
                                }
                                                        
                        }.padding([.leading,.trailing])
                        
                            RambUserFeed(RambService(), user: self.user)
                            
                        }
                                                                    
                }.navigationBarItems(trailing:
                                        
                    HStack{
                        
                        if user.isCurrentUser {
                            
                            Spacer()
                            
                        } else {
                    
                        Button(action: {
                            
                            if self.isFollowed {
                                
                                UserService.shared.unfollowUser(uid: self.user.uid)
                                
                                self.isFollowed.toggle()
                                
                            } else {
                                
                                UserService.shared.followUser(uid: self.user.uid)
                                
                                self.isFollowed.toggle()
                            }
                            
                            
                        }, label: {
                                
                        if isFollowed {
                            
                            Text("Unfollow")
                            
                        } else {
                            
                            Text("Follow")
                            
                        }
                    })
                            
                    }
                        
                        Button(action: {
                                withAnimation{
                                    self.isPresented.toggle()
                                }
                        }, label: {
                            Image(systemName: "gear")
                                .accentColor(.red)
                        })
                    }
                )
            }
            
            ZStack{

                SettingsView(isPresented: $isPresented)

            }.edgesIgnoringSafeArea(.all)
            .offset(x: 0, y: self.isPresented ? 0 : UIApplication.shared.currentWindow?.frame.height ?? 0)
            
            FloatingPlayerView()
        }
    }
}
