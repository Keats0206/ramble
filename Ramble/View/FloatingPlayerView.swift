//
//  FloatingPlayerView.swift
//  Ramble
//
//  Created by Peter Keating on 9/23/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import AVKit


struct FloatingPlayerView: View {
    @EnvironmentObject var globalPlayer: GlobalPlayer
    @State var height : CGFloat = 25
    @State var floating = true
    
    @Binding var hideNav: Bool
                
    var body : some View{        
        GeometryReader{ geo in
            ZStack{
                Color.white
                    .shadow(color: Color.blue, radius: 20, x: 100, y:0)
                VStack{
                    // SMALL PLAYER
                    if floating == true {
                        VStack{
                            HStack(spacing: 5){
                                                            
                            WebImage(url: URL(string: "\(globalPlayer.globalRambs?.first?.user.profileImageUrl ?? "")"))
                                .frame(width: 45, height: 45)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            
                            VStack(alignment : .leading){
                                Text(globalPlayer.globalRambs?.first?.caption ?? "No ramb")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                
                                Text(globalPlayer.globalRambs?.first?.user.username ?? "No ramb")
                                    .font(.system(size: 16, weight: .regular, design: .rounded))
                            }
                            
                            Spacer()
                            
                            if globalPlayer.isPlaying{
                                
                                Button(action: {
                                    self.globalPlayer.globalRambPlayer?.pause()
                                    globalPlayer.isPlaying = false
                                }){
                                    Image(systemName: "pause.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                            } else {
                                Button(action: {
                                    self.globalPlayer.play()
                                }){
                                    Image(systemName: "play.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                            }
                            
                        }
                                .padding(10)
                                .padding([.leading, .trailing])
                            
                            Divider()
                        }.onAppear{
                            self.height = geo.size.height - 60
                        }
                    } else {
                        VStack{
                            BigPlayerView(ramb: (globalPlayer.globalRambs?.first!)!, player: globalPlayer.globalRambPlayer!)
                            
                        }
                    }
                    // your music player.....
                    Spacer()
                }
            }.onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                self.height = 25
                self.floating = false
                self.hideNav = true
            })
            .gesture(
                DragGesture()
                    .onChanged({ (value) in
                        if self.height >= 600{
                            self.hideNav = false
                        }
                    })
                    .onChanged({ (value) in
                        if self.height >= 0{
                            self.height += value.translation.height / 8
                        }
                    })
                    .onEnded({ (value) in
                        if self.height > 100 && !self.floating {
                            self.height = geo.size.height - 60
                            self.floating = true
                            self.hideNav = false
                        }
                    else {
                        if self.height < geo.size.height - 150{
                            self.height = 25
                            self.floating = false
                            self.hideNav = true
                    } else {
                        self.height = geo.size.height - 60
                    }
                }
            })
        ).offset(y: self.height)
            .animation(.spring())
        }
    }
}

struct FloatingPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        FloatingPlayerView(hideNav: .constant(false))
            .environmentObject(GlobalPlayer())
    }
}
