//
//  FloatingPlayerView.swift
//  Ramble
//
//  Created by Peter Keating on 9/23/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct FloatingPlayerView: View {
    
    @State var height : CGFloat = UIScreen.main.bounds.height - 75
    @State var floating = true
    
    @Binding var hideNav: Bool
    
    var body : some View{
        
        
        GeometryReader{geo in
            
            ZStack{
                
                Color.red
                
                VStack{
                    
                    // SMALL PLAYER
                    
                    if floating == true {
                        
                        HStack{
                            
                            Rectangle()
                                .frame(width: 60, height: 45)
                                .cornerRadius(10)
                                .background(Color.red)
                            
                            VStack(alignment : .leading){
                                
                                Text("Love Story")
                                    .fontWeight(.heavy)
                                Text("Taylor Swift")
                                
                            }
                            
                            Spacer()
                            
                            Image(systemName: "play.fill")
                                .resizable()
                                .frame(width: 32, height: 30)
                            
                            
                        }.padding(10)
                        .foregroundColor(.white)
                        
                    } else {
                        
                        VStack{
                            
                            Spacer()
                            
                            Text("Big Music Player")
                            
                            Spacer()
                            
                        }
                    }
                    
                    // your music player.....
                    
                    Spacer()
                    
                }
            }.gesture(DragGesture()
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
