//
//  rambleCellTop.swift
//  Ramble
//
//  Created by Peter Keating on 4/21/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct rambCell : View {
    
    @ObservedObject var audioPlayer = AudioPlayer()
    @State var applauseActive = false
    
    var id = ""
    var name = ""
    var userimage = ""
    var title = ""
    var length = ""
    var date = ""
    var time = ""
    var applause = ""
    var stream = ""
    var tagId = ""
    var docId = ""
        
    var body: some View {
        
        VStack{
            
            HStack {
                
                Spacer().frame(width: 10)
                
                VStack {
                    
                AnimatedImage(url: URL(string: userimage)!)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 60, height: 60, alignment: .center)
                    
                Text(date)
                    
                }
                
                Spacer().frame(width: 10)
                
                VStack(alignment: .leading){
                        
                    Text(id).font(.body).fontWeight(.heavy)
                    
                    Text(title).font(.subheadline).fontWeight(.regular).multilineTextAlignment(TextAlignment.leading)
                    
                    Spacer()
                    
                    }
                
                    Spacer()
                
                    VStack{
                        
                        if applauseActive {
        
                            Button(action:  {
                                
                                crowdApplause(applauseActive: self.applauseActive, applause: self.applause, id: self.docId)
                                
                                self.applauseActive.toggle()
                                
                            }) {
                                
                                Image("Heart").resizable().frame(width: 20, height: 20)
                            
                            }.foregroundColor(.red)
                            .buttonStyle(BorderlessButtonStyle())
                            
                            } else {

                                Button(action:  {
                                    
                                    crowdApplause(applauseActive: self.applauseActive, applause: self.applause, id: self.docId)
                                    self.applauseActive.toggle()
                
                                }) {
                
                                    Image("Heart").resizable().frame(width: 20, height: 20)
                                
                                }.foregroundColor(.black)
                                .buttonStyle(BorderlessButtonStyle())
                            }
                        
                        Text(applause)
        
                }
                
                    Spacer().frame(width: 10)
                    
                    VStack(alignment: .leading){
                        
                        if audioPlayer.isPlaying == false {
                            
                            Button(action: {
                                self.audioPlayer.startPlayback(audio: URL(string: self.stream)!)
                            }) {
                                Image(systemName: "play.circle")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }.buttonStyle(BorderlessButtonStyle())
                        } else {
                            
                            Button(action: {
                                self.audioPlayer.stopPlayback()
                            }) {
                                Image(systemName: "stop.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }.buttonStyle(BorderlessButtonStyle())
                        }

                        Text(length)
                    }
            
                 Spacer().frame(width: 10)
            }
        }
    }
}


struct rambCell_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
