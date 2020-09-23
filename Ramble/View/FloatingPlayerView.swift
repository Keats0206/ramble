//
//  FloatingPlayerView.swift
//  Ramble
//
//  Created by Peter Keating on 9/23/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct FloatingPlayerView: View {
    
    @State var opacity : Double = 1
    @State var height : CGFloat = 0
    @State var floating = false
    
    
    var body : some View{
        
        
        GeometryReader{geo in
            
            
            ZStack{
                
                Color.orange
                
                VStack{
                    
                    HStack{
                        
                        Rectangle()
                            .frame(width: 60, height: 45)
                            .cornerRadius(10)
                            .background(Color.red)
                        
                        VStack(alignment : .leading){
                            
                            Text("Love Story").fontWeight(.heavy)
                            Text("Taylor Swift")
                        }
                        
                        Spacer()
                        
                        Image(systemName: (self.height == geo.size.height - 75) ? "play.fill" :  "square.and.arrow.down.fill").resizable().frame(width: 32, height: 30)
                        
                        
                    }.padding(10)
                    .foregroundColor(.white)
                    
                    // your music player.....
                    
                    Spacer()
                    
                }
            }.gesture(DragGesture()
            
                .onChanged({ (value) in
                    
                    
                    if self.height >= 0{
                        
                        self.height += value.translation.height / 8
                        self.opacity = 0.5
                    }
                    
                })
                .onEnded({ (value) in
                    
                    if self.height > 100 && !self.floating{
                        
                        self.height = geo.size.height - 75
                        self.opacity = 1
                        self.floating = true
                        
                    }
                    else{
                        
                        if self.height < geo.size.height - 150{
                            
                            self.height = 0
                            self.opacity = 1
                            self.floating = false
                        }
                        else{
                            
                            self.height = geo.size.height - 75
                            self.opacity = 1
                        }
                    }
                })
                
            ).opacity(self.opacity)
            .offset(y: self.height)
            .animation(.spring())
        }
    }
}

struct FloatingPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        FloatingPlayerView()
    }
}
