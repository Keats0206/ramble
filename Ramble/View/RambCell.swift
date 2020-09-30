//
//  RambCell.swift
//  Ramble
//
//  Created by Peter Keating on 6/8/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import AVKit

struct RambCell : View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var globalPlayer: GlobalPlayer
    @ObservedObject var viewModel = RambService()
    
    @State private var showingActionSheet = false
    @State private var isActive = false
    
    var ramb: Ramb
        
    var body: some View {
        ZStack{
                        
            HStack(alignment: .center){
                            
                    VStack(alignment: .center, spacing: 10){
                        
                        WebImage(url: ramb.user.profileImageUrl)
                            .frame(width: 75, height: 75)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            .onTapGesture { self.isActive.toggle() } // activate link on image tap
                            .background(NavigationLink(destination:  // link in background
                                                        ProfileView(RambService(), user: ramb.user), isActive: $isActive) { EmptyView()
                            })
                        
                        Spacer()
                        
                    }
                    
                    //              Center of Cell VStack
                    
                    VStack(alignment: .leading){
                        
                        //                  Username + timestamp
                        
                        HStack {
                            
                            Text("@" + ramb.user.username)
                                .font(.body)
                                .fontWeight(.heavy)
                                                    
                            Text(formatDate(timestamp: ramb.timestamp) + " ago")
                                .font(.body)
                                
                        }
                
                        //                  Caption
                        
                        Text(ramb.caption)
                            .font(.subheadline)
                            .fontWeight(.heavy)
                            .multilineTextAlignment(TextAlignment.leading)
                        
                        Spacer()
        
                    }

                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 10){
                        
                        Button(action: {
                            globalPlayer.globalRamb = self.ramb
                            globalPlayer.setGlobalPlayer(ramb: self.ramb)
                            globalPlayer.globalRambPlayer?.play()
                            globalPlayer.isPlaying.toggle()
                        }){
                            Image(systemName: globalPlayer.isPlaying ? "pause.circle" : "play.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }.buttonStyle(BorderlessButtonStyle())
                            
                        Text("3:30")
                        
                        Spacer()
                        
                    }
            }.foregroundColor(.black)
            .padding(20)
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .frame(height: 100)
        .padding()
    }
}


struct RambCell_Previews: PreviewProvider {
    static var previews: some View {
        RambCell(ramb: _ramb)
            .environmentObject(SessionStore())
            .environmentObject(GlobalPlayer())
    }
}
