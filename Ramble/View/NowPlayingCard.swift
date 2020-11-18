//
//  NowPlayingCard.swift
//  Ramble
//
//  Created by Peter Keating on 11/18/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct NowPlayingCard: View {
    @EnvironmentObject var globalPlayer: GlobalPlayer
    @Binding var position: CardPosition
    
    @State private var isExpanded = false
    @State var volume = 50.0
    
    @State var height : CGFloat = 0
    @State var floating = true
    
    @State var width : CGFloat = 20
    
    var ramb: Ramb2?
    
    let screenBounds = UIScreen.main.bounds
    
    var imageFrame: CGFloat {
        isExpanded ? screenBounds.width * 0.7 : 48
    }

    var cornerRadius: CGFloat {
        isExpanded ? 20 : 0
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if ramb != nil {
                VStack{

                    HStack {
                        
                        if #available(iOS 14.0, *) {
                            
                            WebImage(url: URL(string: "\(ramb!.user.profileImageUrl)"))
                                .resizable()
                                .scaleEffect()
                                .frame(width: imageFrame, height: imageFrame)
    //                                            .matchedGeometryEffect(id: "AlbumImage", in: expandAnimation)
                                .clipShape(Rectangle())
                                .cornerRadius(8)
                            
                        } else {
                            // Fallback on earlier versions
                            WebImage(url: URL(string: "\(ramb!.user.profileImageUrl)"))
                                .resizable()
                                .scaleEffect()
                                .frame(width: imageFrame, height: imageFrame)
                                .clipShape(Rectangle())
                                .cornerRadius(8)
                                .shadow(radius: 10)
                        }
                        
                        VStack(alignment: .leading) {
                            
                            Text("@\(ramb!.user.username)")
                                .font(.system(.caption, design: .rounded))
                    
                            Text("\(ramb!.caption)")
                                .font(.system(.body, design: .rounded))
                                .bold()
                        }
                        
                        Spacer()
                        
                        if position == CardPosition.bottom {
                            AudioControlView(player: globalPlayer.globalRambPlayer!, isExpanded: false)
                        }
                    }
                    
                    if position != CardPosition.bottom {
                        AudioControlView(player: globalPlayer.globalRambPlayer!, isExpanded: true)
                    }
                                        
                    Divider()
                    
                    Text("Profile About Section")
                    
                    Divider()
                    
                    Text("Song Que Coming Soon")
                    
                }
                .padding(.horizontal)
            } else {
                EmptyView()
            }
        }
    }
}
