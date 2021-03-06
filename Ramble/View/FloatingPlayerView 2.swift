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
    
    @State var height : CGFloat = UIScreen.main.bounds.height - 75
    @State var floating = true
    
    @Binding var hideNav: Bool
                
    var body : some View{
        GeometryReader{geo in
            
            ZStack{
                
                Color.white
                    .opacity(0.97)
                    .shadow(radius: 5)
                
                VStack{
                    // SMALL PLAYER
                    if floating == true {
                        
                        HStack{
                            
                            WebImage(url: globalPlayer.globalRamb?.user.profileImageUrl)
                                .frame(width: 45, height: 45)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            
                            VStack(alignment : .leading){
                                Text(globalPlayer.globalRamb?.caption ?? "No ramb")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                
                                Text(globalPlayer.globalRamb?.user.username ?? "No ramb")
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
                                        .frame(width: 32, height: 30)
                                }
                            } else {
                                Button(action: {
                                    self.globalPlayer.globalRambPlayer?.play()
                                    globalPlayer.isPlaying = true
                                }){
                                    Image(systemName: "play.fill")
                                        .resizable()
                                        .frame(width: 32, height: 30)
                                }
                            }
                            
                        }.padding(10)
                        .padding([.leading, .trailing])
                        .foregroundColor(.black)

                        
                    } else {
                        
                        VStack{

                        Spacer()
                        
                        Spacer()
                            
                    }
                }
                    
                    // your music player.....
                    
                    Spacer()
                    
                }
                
            }
            .gesture(DragGesture()
                    .onChanged({ (value) in
                        if self.height >= 600{
                            self.hideNav = false
                        }
                    })
                    .onChanged({ (value) in
                        if self.height >= 0{
                            self.height += value.translation.height / 8
                        }
                    }).onEnded({ (value) in
                            if self.height > 100 && !self.floating {
                                self.height = geo.size.height - 75
                                self.floating = true
                                self.hideNav = false
                            } else{
                                if self.height < geo.size.height - 500{
                                    self.height = 25
                                    self.floating = false
                                    self.hideNav = true
                                } else{
                                    self.height = geo.size.height - 75
                                }
                            }
                        })
                      
            ).offset(y: self.height - 75)
            .animation(.spring())
        }
    }
}
