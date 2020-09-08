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
    
    @State var isPresented = false
    @State var isFollowing = false
    
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
                                            
                                            Text("@\(user.username)")
                                                .font(.system(size: 25))
                                                .fontWeight(.heavy)
                                            
                                            Button(action: {
                                                
                                                self.isFollowing.toggle()
                                                UserService.shared.followUser(uid: "uWXF2S5NGhZj9ib6mxDiYo1dGVs1")
                                                
                                            }, label: {
                                                
                                                if isFollowing{
                                                
                                                    Text("Follow")
                                                    
                                                } else {
                                                    
                                                    Text("Unfollow")
                                                    
                                                }
                                                
                                            })
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
                                    
                                    Text("\(user.bio!)").font(.system(size: 16))
                                
                                }
                                
                                HStack{
                                                                        
                                    Text("Rambles")
                                        .font(.headline)
                                    
                                    Spacer()
                                                                    
                                }
                                
                                Divider()
                                
                                RambUserFeed(RambService(), user: self.user)
                                
                            }.padding()
                            
                        }
                        .navigationBarHidden(true)
                        .navigationBarItems(leading:
                        
                    Button(action: {
                        
                        withAnimation{
                            
                            self.isPresented.toggle()
                        }
                    }, label: {
                        
                        Image(systemName: "gear")
                            .accentColor(.red)
                        
                    })
                )
            }
            
            ZStack{
                
                SettingsView(isPresented: $isPresented)
                
            }
            .edgesIgnoringSafeArea(.all)
            .offset(x: 0, y: self.isPresented ? 0 : UIApplication.shared.currentWindow?.frame.height ?? 0)
        }
    }
}

//.sheet(isPresented: $isPresented, content: {
//
//    Button(action: {self.isPresented.toggle()
//
//    }){
//        Text("Here is my work")
//    }
//})
