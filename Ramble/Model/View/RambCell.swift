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
    
    @State var didClap = false
    @State var newClaps = 0

    @State var width: CGFloat = 0
    @State private var showingActionSheet = false
    
    let ramb: Ramb
        
    var body: some View {
        VStack{
            
            HStack{
                
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
                                                .default(Text("Delete"), action: {
                                                    self.viewModel.deleteRamb(ramb: self.ramb)
                                                }),
                                                .cancel()
                                    ])
                                }
                        }.buttonStyle(BorderlessButtonStyle())
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
