//
//  RambCell.swift
//  Ramble
//
//  Created by Peter Keating on 6/8/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import AVKit
import MinimizableView
import SwimplyPlayIndicator

struct RambCell : View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var globalPlayer: GlobalPlayer

    @State private var showingActionSheet = false
        
    var ramb: Ramb2
    
    var body: some View {
        HStack(alignment: .center) {
                    VStack(alignment: .center) {
                        ZStack {
                            
                            SwimplyPlayIndicator(state: $globalPlayer.playState, lineColor: Color.accent3)
                                           .frame(width: 20, height: 20)
                            
                            WebImage(url: URL(string: ramb.user.profileImageUrl))
                                .resizable()
                                .scaleEffect()
                                .frame(width: 50, height: 50)
                                .clipShape(Rectangle())
                                .cornerRadius(8)
                            }
                    }
                    VStack(alignment: .leading) {
                        HStack {
                            Text("@" + ramb.user.username)
                                .font(.headline)
                                .foregroundColor(.primary)
                                .bold()
                            
                            Text("\(formatDate(timestamp: ramb.timestamp)) ago")
                                .font(.system(.subheadline, design: .rounded))
                                .opacity(0.7)
                            
//                            Text("\(TimeHelper.formatSecondsToHMS(ramb.length))")
//                                .font(.system(.caption, design: .rounded))
//                                .bold()
                            
                            Spacer()
                            
                        }.font(.system(.caption, design: .rounded))
                        
                        Text(ramb.caption)
                            .font(.system(.body, design: .rounded))
                            .multilineTextAlignment(TextAlignment.leading)
                        
                    }
                    .background(Color.white)
            VStack(alignment: .center) {
                Button(action: {
                    self.showingActionSheet.toggle()
                }) {
                    Circle()
                        .foregroundColor(Color.flatDarkBackground.opacity(0.2))
                        .frame(width: 25, height: 25)
                        .overlay(
                            Image(systemName: "ellipsis")
                        )
                        .actionSheet(isPresented: $showingActionSheet) {
                            ActionSheet(title: Text("Report this ramb?"),
                                buttons: [.default(
                                    Text("Report")
                                ,action: {
                                    print("DEBUG: report ramb")
                                }), .cancel()
                            ])
                        }
                }.buttonStyle(BorderlessButtonStyle())
            }
        }.padding()
        .cornerRadius(15)
        .onTapGesture(perform: {
            play()
        })
    }
    
    func play() {
        globalPlayer.globalRambs = [self.ramb]
        globalPlayer.setGlobalPlayer(ramb: self.ramb)
        globalPlayer.play()
    }
}

struct RambCell_Previews: PreviewProvider {
    static var previews: some View {
        RambCell(ramb: testRamb)
    }
}
