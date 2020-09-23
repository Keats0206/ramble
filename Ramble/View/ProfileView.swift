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
                    
                    VStack{
                        
                        HStack{
                            
                            Spacer()
                            
                            Button(action: {
                                
                                withAnimation{
                                    
                                    self.isPresented.toggle()
                                    
                                }
                                
                            }, label: {
                                
                                Image(systemName: "gear")
                                    .accentColor(.red)
                                
                            })
                            
                        }.padding()
                        
                        Spacer()
                        
                    }
                        

                    VStack(alignment: .leading, spacing: 20){
                        
                        HStack{
                            
                            AnimatedImage(url: user.profileImageUrl)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 10){
                                
                                HStack{
                                    
                                        VStack(alignment: .leading){
                                            Text("@\(user.username)")
                                                .font(.system(size: 25))
                                                .fontWeight(.heavy)
                                            
                                            Text("@\(user.fullname)")
                                                .font(.system(size: 15))
                                            }
                                        
                                        
                                    
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
                            }
                                
                                HStack(spacing: 20){
                                    
                                    VStack{
                                        
                                        Text("230")
                                            .bold()
                                        
                                        Text("Followers")
                                    }
                                    
                                    VStack{
                                        
                                        Text("230")
                                            .bold()
                                        
                                        Text("Following")
                                    }
                                    
                                    VStack{
                                        
                                        Text("230")
                                            .bold()
                                        
                                        Text("Likes")
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading){
                            
                            Text("\(user.bio!)")
                                .font(.system(size: 16))
                        }
                        
                        HStack{
                            
                            Text("Rambles")
                                .font(.headline)
                            
                            Spacer()
                        }
                        
                        Divider()
                        
                        RambUserFeed(RambService(), user: self.user)
                        
                    }.padding()
                    
                }.navigationBarHidden(true)
                .navigationBarTitle(user.username)
            
            }
            
            ZStack{
                
                SettingsView(isPresented: $isPresented)
                
            }.edgesIgnoringSafeArea(.all)
            .offset(x: 0, y: self.isPresented ? 0 : UIApplication.shared.currentWindow?.frame.height ?? 0)
            
            FloatingPlayerView()
        }
    }
}
