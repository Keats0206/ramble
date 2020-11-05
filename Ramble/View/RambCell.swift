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


struct RambCell : View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var globalPlayer: GlobalPlayer

    @State private var showingActionSheet = false
    
    var ramb: Ramb2
    
    var body: some View {
        HStack(alignment: .center) {
                    VStack(alignment: .center) {
                        ZStack {
                            WebImage(url: URL(string: ramb.user.profileImageUrl))
                                .frame(width: 75, height: 75)
                                .clipShape(Rectangle())
                                .cornerRadius(8)
                            }
                        Spacer()
                    }
                    VStack(alignment: .leading) {
                        HStack {
                            Text("@" + ramb.user.username)
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundColor(.primary)
                                .bold()
                            Text(formatDate(timestamp: ramb.timestamp))
                                .bold()
                            Text("3:30s")
                                .font(.system(.caption, design: .rounded))
                                .bold()
                            Spacer()
                        }.font(.system(.caption, design: .rounded))
                        Text(ramb.caption)
                            .font(.system(.body, design: .rounded))
                            .bold()
                            .opacity(0.8)
                            .multilineTextAlignment(TextAlignment.leading)
                        Spacer()
                    }
                    .background(Color.white)
            VStack(alignment: .center) {
                    Button(action: {
                        self.showingActionSheet.toggle()
                    }) {
                        Circle()
                            .foregroundColor(Color.flatDarkCardBackground.opacity(0.2))
                            .frame(width: 25, height: 25)
                            .overlay(Image(systemName: "ellipsis"))
                            .actionSheet(isPresented: $showingActionSheet) {
                                ActionSheet(title: Text("Report this ramb?"),
                                    buttons: [.default(
                                        Text("Report")
                                            .foregroundColor(.red),
                                        action: {
                                            print("DEBUG: report ramb")
                                    }), .cancel()
                                ])
                            }.accentColor(.secondary)
                    }.buttonStyle(BorderlessButtonStyle())
                    Spacer()
                }
        }.frame(height: 100)
        .padding()
        .cornerRadius(15)
        .onTapGesture(perform: {
            play()
            print(ramb.id)
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
