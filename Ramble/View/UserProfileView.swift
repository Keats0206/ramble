//
//  UserProfileView.swift
//  Ramble
//
//  Created by Peter Keating on 7/1/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI

//TODO: Bring a user into this view...pass that same user down into the profile header and profile feed

struct UserProfileView: View {
    @EnvironmentObject var session: SessionStore
    
    @Binding var isShown: Bool
    @State var isPresented = false
    
    var user: User

    var body: some View {
            ZStack(){
                VStack{
                    HStack{
                        Button(action: {
                            self.isShown.toggle()
                        }){
                            Image(systemName: "arrow.uturn.down.circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .accentColor(.red)
                        }.buttonStyle(BorderlessButtonStyle())
                        
                        Spacer()
                        
                        Spacer()
                        
                        Spacer()
                        
                        Button(action: {
                            self.isPresented.toggle()
                        }){
                            Image(systemName: "gear")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .accentColor(.red)
                        }.buttonStyle(BorderlessButtonStyle()).sheet(isPresented: $isPresented, content: {
                            SettingsView()
                        })
                        
                    }.frame(height: 20).offset(y: 10)
                    
//                  Profile Header
                    
                    VStack{
                        VStack{
                            AnimatedImage(url: user.profileImageUrl)
                                .resizable()
                                .frame(width: 150, height: 150)
                                .cornerRadius(150 / 2)
                            
                            Text("\(user.username)").font(.system(size: 25)).fontWeight(.heavy)
                            
                            Spacer().frame(height: 10)
                            
//                            Text("Listeners/Following").font(.system(size: 18))
                            
                            Spacer().frame(height: 10)
                            
                            Text("\(user.bio!)").font(.system(size: 16))
                            
                            Divider()
                        }
                        .frame(width: 200)
                        .padding(.vertical, 15)
                    }
                                        
                    RambUserFeed(RambService(), user: self.user)
            }
        }
    }
}
