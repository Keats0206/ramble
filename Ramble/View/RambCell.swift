//
//  RambCell.swift
//  Ramble
//
//  Created by Peter Keating on 6/8/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct rambCell : View {
    @ObservedObject var audioPlayer = AudioPlayer()
    @State var didClap = false
    
    let ramb: Ramb
    var body: some View {
        
        VStack{
            
            HStack{
                
                VStack{
                    AnimatedImage(url: URL(string: "\(ramb.userimage)"))
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 60, height: 60, alignment: .center)
                }
                
                Spacer().frame(width: 10)
                
                VStack(alignment: .leading){
                    HStack {
                        Text(ramb.name).font(.body).fontWeight(.heavy)
                        
                        Text(formatDate(timestamp: ramb.timestamp) + " ago")
                    }
                    Text(ramb.caption).font(.subheadline).fontWeight(.regular).multilineTextAlignment(TextAlignment.leading)
                    Spacer()
                }
                
                Spacer()
                
                HStack{
                    
                    Button(action: {
                        RambService.shared.handleClap(didClap: self.didClap, claps: self.ramb.claps, id: self.ramb.id)
                        self.didClap.toggle()
                    }){
                        Image(systemName: self.didClap ? "hand.thumbsup.fill" : "hand.thumbsup")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }.buttonStyle(BorderlessButtonStyle())
                    
                    Text(ramb.claps)
                }
                
                Spacer().frame(width: 10)
                
                VStack(alignment: .leading){
                    
                    if audioPlayer.isPlaying == false {
                        Button(action: {
                            self.audioPlayer.startPlayback(audio: URL(string: "\(self.ramb.rambUrl)")!)
                        }) {
                            Image(systemName: "play.fill")
                                .resizable()
                                .frame(width: 35, height: 35)
                        }.buttonStyle(BorderlessButtonStyle())
                    } else {
                        
                        Button(action: {
                            self.audioPlayer.stopPlayback()
                        }) {
                            Image(systemName: "stop.fill")
                                .resizable()
                                .frame(width: 35, height: 35)
                        }.buttonStyle(BorderlessButtonStyle())
                    }
                    
                    Spacer().frame(width: 10)
                    
                }
            }.accentColor(.red)
        }
    }
}
