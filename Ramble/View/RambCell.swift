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

struct RambCell : View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var globalPlayer: GlobalPlayer
    
    @State private var showingActionSheet = false
    @State private var isActive = false
    
    var ramb: Ramb2
    
    var body: some View {
        ZStack {
            NavigationLink(destination:  // link in background
                ProfileView(offset: CGSize(width: 0, height: 0), user: .constant(ramb.user)), isActive: $isActive) { EmptyView()
            }
            HStack(alignment: .center) {
                VStack(alignment: .center, spacing: 10) {
                    WebImage(url: URL(string: ramb.user.profileImageUrl))
                        .frame(width: 75, height: 75)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(globalPlayer.globalRambs?.first?.id == self.ramb.id ? Color.accent3 : .clear, lineWidth: 3))
                        .onTapGesture { self.isActive.toggle() } // activate link on image tap
                    Spacer()
                }
                VStack(alignment: .leading) {
                    HStack{
                        Text("@" + ramb.user.username)
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(globalPlayer.globalRambs?.first?.id == self.ramb.id ? .accent3 : .primary)
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
                        .multilineTextAlignment(TextAlignment.leading)
                    Spacer()
                }.background(Color.white)
                VStack(alignment: .center){
                    Button(action: {
                        self.showingActionSheet.toggle()
                    }) {
                        Image(systemName: "ellipsis")
                            .frame(height: 10)
                            .accentColor(Color.accent4)
                            .actionSheet(isPresented: $showingActionSheet) {
                                ActionSheet(title: Text("Report this ramb?"),
                                            buttons:[.default(
                                                    Text("Report").foregroundColor(.red), action: {
                                                        print("DEBUG: report ramb")
                                                    }), .cancel()
                                            ])
                            }
                    }.buttonStyle(BorderlessButtonStyle())
                    Spacer()
                }
            }.padding()
        }.cornerRadius(15)
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
