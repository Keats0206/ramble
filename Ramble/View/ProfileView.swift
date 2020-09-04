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
                        

                            VStack(alignment: .leading){
                                
                                HStack{
                                    
                                    AnimatedImage(url: user.profileImageUrl)
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                    
                                    VStack{
                                        
                                        Text("@ \(user.username)").font(.system(size: 25)).fontWeight(.heavy)
                                        
                                        Text("\(user.bio!)").font(.system(size: 16))
                                        
                                    }
                                    
                                }.padding()
                                
                                HStack{
                                    
                                    Spacer()
                                    
                                    Text("Rambles")
                                        .font(.headline)
                                    
                                    Spacer()
                                                                    
                                }.padding()
                                
                                Divider()
                                
                                RambUserFeed(RambService(), user: self.user)
                                
                            }
                    
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
            .offset(x: 0, y: self.isPresented ? 0 : UIApplication.shared.keyWindow?.frame.height ?? 0)
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
