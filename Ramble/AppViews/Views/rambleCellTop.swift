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

struct rambleCellTop : View {
    
    var id = ""
    var userimage = ""
    var msg = ""
    var length = ""
    var date = ""
    var like = ""
    var comments = ""
    var echos = ""
    var streamurl = ""
    var tagId = ""
    
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
                    Text(msg).font(.subheadline).fontWeight(.regular).multilineTextAlignment(TextAlignment.leading)
                    Spacer()
                    
                    }
                
                    Spacer()
                
                    VStack{
                        
                        Spacer()
        
                        Button(action:  {
                            
                        }) {
                            
                            Image("Heart").resizable().frame(width: 20, height: 20)
                        
                        }.foregroundColor(.red)
                        
                        Spacer()
                    
                    }
                
                    Spacer().frame(width: 10)
                    
                    VStack(alignment: .leading){
                        Button(action:  {
                            }) {
                                Image("Play-button")
                                    .foregroundColor(.red)
                                    .padding(.trailing, 20)
                        }
                        
                        Text(length)
                    }
            
                 Spacer().frame(width: 10)
            }
        }
    }
}


struct rambleCellTop_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
