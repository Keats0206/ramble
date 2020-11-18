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
    
    @State var volume = 50.0
    
    @State var height : CGFloat = 0
    @State var floating = true
    
    @State var width : CGFloat = 20
    
    @Binding var actionState: Int?
    @Binding var selectedUser: User
    
    var ramb: Ramb2?
    
    let screenBounds = UIScreen.main.bounds
        
    var offset: CGFloat {
        position == CardPosition.bottom ? 165 : 335
    }
        
    var body: some View {
        ZStack(alignment: .top) {
            if ramb != nil {
                VStack {
                    HStack {
                        WebImage(url: URL(string: "\(ramb!.user.profileImageUrl)"))
                            .resizable()
                            .scaleEffect()
                            .frame(width: 48, height: 48)
                            .clipShape(Rectangle())
                            .cornerRadius(8)
                            .shadow(radius: 10)
                        VStack(alignment: .leading) {
                            Button(action: {
                                self.actionState = 1
                                self.selectedUser = ramb!.user
                            }){
                                Text("@\(ramb!.user.username)")
                                    .font(.system(.caption))
                                    .bold()
                                
                            }.foregroundColor(.primary)
                            
                            Text("\(ramb!.caption)")
                                .font(.system(.body, design: .rounded))
                                .bold()
                        }
                        Spacer()
                    }
                    Spacer()
                    VStack {
                        if position == CardPosition.middle {
                            VStack(alignment: .leading) {
                                Divider()
                                HStack(alignment: .bottom) {
                                    Text("@\(ramb!.user.username)")
                                        .font(.system(.headline))
                                        .bold()
                                    Text("\(ramb!.user.displayname)")
                                        .font(.system(.subheadline, design: .rounded))
                                    Spacer()
                                    
                                    Button(action: {
                                        print("Follow")
                                    }) {
                                        Circle()
                                            .foregroundColor(Color.flatDarkCardBackground.opacity(0.2))
                                            .frame(width: 25, height: 25)
                                            .overlay(Image(systemName: "plus")
                                                        .foregroundColor(Color.accent3))
                                    }
                                }
                                Text("\(ramb!.user.bio)")
                                    .font(.system(.body, design: .rounded))
                                    .opacity(0.4)
                                Divider()
                            }
                        } else {
                            Spacer()
                        }
                    }
                    .frame(height: position == CardPosition.middle ? 100 : 10)
                    .background(Color.red)
                    
                    Spacer()
                    
                    AudioControlView(player: globalPlayer.globalRambPlayer!)
                        .padding(.bottom, 25)
                    
                }
                .foregroundColor(.primary)
                .padding()
                .frame(height: offset)
//                    HStack {
//
//                        if #available(iOS 14.0, *) {
//
//                            WebImage(url: URL(string: "\(ramb!.user.profileImageUrl)"))
//                                .resizable()
//                                .scaleEffect()
//                                .frame(width: imageFrame, height: imageFrame)
//    //                                            .matchedGeometryEffect(id: "AlbumImage", in: expandAnimation)
//                                .clipShape(Rectangle())
//                                .cornerRadius(8)
//
//                        } else {
//                            // Fallback on earlier versions
//                            WebImage(url: URL(string: "\(ramb!.user.profileImageUrl)"))
//                                .resizable()
//                                .scaleEffect()
//                                .frame(width: imageFrame, height: imageFrame)
//                                .clipShape(Rectangle())
//                                .cornerRadius(8)
//                                .shadow(radius: 10)
//                        }
//
//                        VStack(alignment: .leading) {
//
//                            Text("@\(ramb!.user.username)")
//                                .font(.system(.caption, design: .rounded))
//
//                            Text("\(ramb!.caption)")
//                                .font(.system(.body, design: .rounded))
//                                .bold()
//                        }
//
//                        Spacer()
//
//                    }
            } else {
                EmptyView()
            }
        }
    }
}
