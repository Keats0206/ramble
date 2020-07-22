//
//  RambCell.swift
//  Ramble
//
//  Created by Peter Keating on 6/8/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct RambCell : View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var selectedRamb: SelectedRamb
    @ObservedObject var audioPlayer = AudioPlayer()
    @ObservedObject var viewModel = RambService()
    
    @State var newClaps = 0
    
    @State var didClap = false
    @State var time: Float = 0
    @State private var showingActionSheet = false
    
    let ramb: Ramb
    
    var body: some View {
        VStack{
            
            HStack{
                
                //              Left of Cell Pic + Elipsis
                
                VStack{
                    
                    AnimatedImage(url: ramb.user.profileImageUrl)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 60, height: 60, alignment: .center).onTapGesture {
                            
                            if self.session.session!.uid != self.ramb.user.uid {
                                
                                self.selectedRamb.user = self.ramb.user
                                
                                self.selectedRamb.userProfileShown.toggle()
                                
                                print("set selected user to user with id of: \(self.ramb.user.uid) and the view isShown is set to: \(self.selectedRamb.userProfileShown)")
                                
                            } else {
                                
                                print("no need to open my own profile")
                                
                            }
                    }
                    
                    if ramb.user.uid != session.session?.uid {
                        
                        Spacer().frame(height: 10)
                        
                    } else {
                        
                        Button(action: {
                            self.showingActionSheet.toggle()
                        }){
                            
                            Image(systemName: "ellipsis")
                                .frame(height: 10)
                                .accentColor(.red)
                                .actionSheet(isPresented: $showingActionSheet) {
                                    ActionSheet(title: Text("Are you sure you want to delete this ramble?"),
                                                buttons:[
                                                    .default(
                                                        Text("Delete").foregroundColor(.red), action: {
                                                            self.viewModel.deleteRamb(ramb: self.ramb)
                                                    }),
                                                    .cancel()
                                    ])
                            }
                        }.buttonStyle(BorderlessButtonStyle())
                    }
                }
                
                Spacer().frame(width: 10)
                
                //              Center of Cell VStack
                
                VStack(alignment: .leading){
                    
                    //                  Username + timestamp
                    
                    HStack {
                        
                        Text("@" + ramb.user.username).font(.body).fontWeight(.heavy)
                        
                        Text(formatDate(timestamp: ramb.timestamp) + " ago")
                        
                    }
                    
                    //                  Caption
                    
                    Text(ramb.caption).font(.subheadline).fontWeight(.regular).multilineTextAlignment(TextAlignment.leading)
                    
                    Spacer()
                    
                    //                  Duration Bar
                    
                    VStack{
                        
                        ZStack(alignment: .leading) {
                            
                            Capsule().fill(Color.black.opacity(0.08)).frame(height: 8)
                                
                        }
                    }
                    
                }.padding(5)
                
                Spacer().frame(width: 10)
                
                VStack{
                    
                    HStack{
                        //              Clap and clap count
                        
                        HStack {
                            
                            Button(action: {
                                self.didClap.toggle()
                                self.viewModel.handleClap(ramb: self.ramb, didClap: self.didClap)
                                self.newClaps = self.didClap ? 1 : 0
                            }){
                                Image(systemName: self.didClap ? "hand.thumbsup.fill" : "hand.thumbsup")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }.buttonStyle(BorderlessButtonStyle())
                            
                            Text(String((self.ramb.claps * -1) + newClaps))
                        }
                        
                        //              Play button
                        
                        VStack(alignment: .leading){
                            
                            if audioPlayer.isPlaying == false {
                                
                                Button(action: {
                                    
                                    self.audioPlayer.startPlayback(audio: URL(string: "\(self.ramb.rambUrl)")!)
                                    
                                    //      Updating the capsule to show playback
                                
                                }) {
                                    
                                    Image(systemName: "play.fill")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                }.buttonStyle(BorderlessButtonStyle())
                                
                            } else {
                                
                                Button(action: {
                                    
                                    self.audioPlayer.stopPlayback()
                                    
                                }) {
                                    
                                    Image(systemName: "stop.fill")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                    
                                }.buttonStyle(BorderlessButtonStyle())
                            }
                        }
                        
                    }
                    
                    //              Play button
                    
                    Text("0:00/0:00").font(.body)
                    
                }
                
            }.accentColor(.red).onAppear{
                self.viewModel.checkIfUserLikedRamb(self.ramb){ ramb in
                    if ramb {
                        self.didClap = true
                    } else {
                        self.didClap = false
                    }
                }
            }
        }
    }
}
