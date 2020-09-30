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
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .onTapGesture { self.isActive.toggle() } // activate link on image tap
                        .background(NavigationLink(destination:  // link in background
                                                    ProfileView(user: ramb.user), isActive: $isActive) { EmptyView()
                        })
                        .buttonStyle(BorderlessButtonStyle())
                    
                    Spacer()
                    
                    Button(action: {
                        print("open ramb action menu")
                    }){
                        Image(systemName: "ellipsis")
                            .frame(height: 10)
                    }.foregroundColor(Color.accent4)
                    .buttonStyle(BorderlessButtonStyle())
                }
                
                //              Center of Cell VStack
                
                VStack(alignment: .leading){
                    //                  Username + timestamp
                    
                    HStack{
                        
                        Text("@" + ramb.user.username)
                            .font(.system(.body, design: .rounded))
                            .bold()
                        //                  Caption
                        
                        Text(formatDate(timestamp: ramb.timestamp))
                            .font(.system(.body, design: .rounded))
                        
                    }
                    
                    Text(ramb.caption)
                        .font(.system(size: 24,weight: .bold, design: .rounded))
                        .bold()
                        .multilineTextAlignment(TextAlignment.leading)
                    
                    Spacer()
                    
                }
                
                Spacer()
                
                VStack(alignment: .center){
                    
                    Button(action: {
                        globalPlayer.globalRamb = self.ramb
                        globalPlayer.setGlobalPlayer(ramb: self.ramb)
                        globalPlayer.globalRambPlayer?.play()
                    }){
                        Image(systemName: "play.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(globalPlayer.globalRamb?.id == self.ramb.id ? .red : .black)
                        
                    }.buttonStyle(BorderlessButtonStyle())
                    
                    Text("3:30")
                }
            }.padding()
            .foregroundColor(.black)
        }
            .frame(height: 150)
            .cornerRadius(15)
    }
}


struct RambCell_Previews: PreviewProvider {
    static var previews: some View {
        RambCell(ramb: _ramb)
            .environmentObject(SessionStore())
            .environmentObject(GlobalPlayer())
    }
}
