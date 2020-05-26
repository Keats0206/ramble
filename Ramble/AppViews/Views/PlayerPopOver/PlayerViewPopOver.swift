//
//  PlayerView.swift
//  Ramble
//
//  Created by Peter Keating on 4/21/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import AVKit

struct PlayerViewPopOver: View {
    
    @State var data : Data = .init(count: 0)
    @State var title = ""
    @State var player : AVAudioPlayer!
    @State var playing = false
    @State var width : CGFloat = 0
    @State var songs = ["Jimi","Love"]
    @State var current = 0
    @State var finish = false
    @State var del = AVdelegate()
    
    var body: some View {
        
        VStack{
            
            Handle()
            
            musicPlayerTop()
            
            Divider()
            
//            Spacer().frame(height: 10)
//            
//            Text("Ramble Detail View")
//            
//            Divider()
//            
//            Text("Ramble Detail View")
                           
            Spacer()
                            
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .background(Color.gray.opacity(0.14))
    
                }
            }

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerViewPopOver()
    }
}
