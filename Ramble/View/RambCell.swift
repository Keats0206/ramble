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
    
    var isSelected: Bool {
        globalPlayer.globalRambs?.first?.id == ramb.id ? true : false
    }
    
    var body: some View {
        HStack(alignment: .center) {
                VStack(alignment: .center) {
                    ZStack {
//                    if isSelected {
//                        SwimplyPlayIndicator(state: $globalPlayer.playState, lineColor: Color.accent3)
//                            .frame(width: 20, height: 20)
//                    }
                        
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
                                .font(.system(.subheadline))
                                .bold()
                            
                            Text("\(formatDate(timestamp: ramb.timestamp)) ago")
                                .font(.system(.subheadline, design: .rounded))
                            
//                            Text("\(TimeHelper.formatSecondsToHMS(ramb.length))")
//                                .font(.system(.caption, design: .rounded))
//                                .bold()
                            
                            Spacer()
                        }.opacity(0.7)

                        Button(action: {
                            play(ramb: ramb)
                        }){
                            Text(ramb.caption)
                                .font(.system(.body, design: .rounded))
                                .multilineTextAlignment(TextAlignment.leading)
                                .foregroundColor(isSelected ? .accent3 : .primary)
                        }
                    }
                    VStack(alignment: .center) {
                        Button(action: {
                            self.showingActionSheet.toggle()
                        }) {
                            Image(systemName: "ellipsis")
                                .font(.body)
                                .foregroundColor(Color.secondary)
                                .actionSheet(isPresented: $showingActionSheet) {
                                    ActionSheet(title: Text("New features coming - likes, comments, audio que, more!"),
                                        buttons: [.default(
                                            Text("Wahooo")
                                        ,action: {
                                            print("DEBUG: report ramb")
                                        }), .cancel()
                                    ])
                                }
                        }.buttonStyle(BorderlessButtonStyle())
                    }
                }
                .padding()
                .cornerRadius(15)
            }
    func play(ramb: Ramb2) {
        globalPlayer.globalRambs = [ramb]
        globalPlayer.setGlobalPlayer(ramb: ramb)
        globalPlayer.play()
    }
}

struct RambCell_Previews: PreviewProvider {
    static var previews: some View {
        RambCell(ramb: testRamb)
    }
}
