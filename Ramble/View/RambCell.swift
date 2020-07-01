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
    @ObservedObject var viewModel = RambService()
            
    @State var didClap = false
    @State var width : CGFloat = 0
    @State var newClaps = 0
        
//  Binding variable to open the other user profile view
    let ramb: Ramb

    var body: some View {
        VStack{
            HStack{
                VStack{
                    AnimatedImage(url: ramb.user.profileImageUrl)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 60, height: 60, alignment: .center).onTapGesture {
                            
                            print("open profile specific view for \(self.ramb.user.uid)")
                    }
                }
                
                Spacer().frame(width: 10)
                
                VStack(alignment: .leading){
                    HStack {
                        Text("@" + ramb.user.username).font(.body).fontWeight(.heavy)
                        
                        Text(formatDate(timestamp: ramb.timestamp) + " ago")
                    }
                    Text(ramb.caption).font(.subheadline).fontWeight(.regular).multilineTextAlignment(TextAlignment.leading)
                    
                    Spacer()
                    
//                  Time bar for each ramble...this is not working at all
                    
                    ZStack(alignment: .leading) {
                    
                        Capsule().fill(Color.black.opacity(0.08)).frame(height: 8)
                        
                        Capsule().fill(Color.red).frame(width: self.width, height: 8)
                        .gesture(DragGesture()
                            .onChanged({ (value) in
                                let x = value.location.x
                                
                                let screen = UIScreen.main.bounds.width - 30
                                
                                let value = self.audioPlayer.rambCurrentTime / self.audioPlayer.rambDuration
                                
                                self.width = screen * CGFloat(value)
                                
                                self.width = x
                                
                            }).onEnded({ (value) in
                                
                                let x = value.location.x
                                
                                let screen = UIScreen.main.bounds.width - 30
                                
                                let percent = x / screen
                                
                                self.audioPlayer.rambCurrentTime = Int(Double(percent)) * self.audioPlayer.rambDuration
                            }))
                    }
                }.padding(5)
                
                Spacer().frame(width: 10)

                
                HStack{
                    
                    Button(action: {
                        self.viewModel.handleClap(ramb: self.ramb)
                        self.didClap.toggle()
                        self.newClaps = self.didClap ? 1 : 0
                    }){
                        Image(systemName: self.didClap ? "hand.thumbsup.fill" : "hand.thumbsup")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }.buttonStyle(BorderlessButtonStyle())
                    
                    Text(String(self.ramb.claps * -1 + newClaps))
                }
                                
                VStack(alignment: .leading){
                                        
                    if audioPlayer.isPlaying == false {
                        Button(action: {
                            self.audioPlayer.startPlayback(audio: URL(string: "\(self.ramb.rambUrl)")!)
                            
//      Should have access to the CurrentTime and Duration through these variables
                            
                            print(self.audioPlayer.$rambCurrentTime)
                            print(self.audioPlayer.$rambDuration)
                            
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
                }
            }.accentColor(.red)
        }
    }
}
