//
//  SmallPlayerView.swift
//  Ramble
//
//  Created by Peter Keating on 10/24/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import MinimizableView

struct SmallPlayerView: View {
    @EnvironmentObject var minimizableViewHandler: MinimizableViewHandler
    @EnvironmentObject var globalPlayer: GlobalPlayer

    var ramb: Ramb2
    
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 5){
                                            
            WebImage(url: URL(string: "\(ramb.user.profileImageUrl)"))
                .frame(width: 45, height: 45)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
            
            VStack(alignment: .leading){
                Text(ramb.caption)
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
        }.background(Color.white)
        .onTapGesture {
            self.minimizableViewHandler.expand()
        }
    }
}

struct SmallPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        SmallPlayerView(ramb: testRamb)
    }
}
