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
                        .overlay(Circle().stroke(globalPlayer.globalRamb?.first?.id == self.ramb.id ? Color.accent3 : .clear, lineWidth: 3))
                        .onTapGesture { self.isActive.toggle() } // activate link on image tap
                    
                    Spacer()
                }
                VStack(alignment: .leading) {
                    HStack{
                        Text("@" + ramb.user.username)
                            .font(.system(size: 18, weight: .heavy, design: .rounded))
                            .bold()
                        Text(formatDate(timestamp: ramb.timestamp))
                            .font(.system(.body, design: .rounded))
                        Spacer()
                    }
                    
                    Text(ramb.caption)
                        .font(.system(size: 22,weight: .regular, design: .rounded))
                        .bold()
                        .multilineTextAlignment(TextAlignment.leading)
                    Spacer()
                }.background(Color.white)
                
                VStack(alignment: .center){
                    
                    Button(action: {
                        play()
                    }){
                        Image(systemName: "play.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(globalPlayer.globalRamb?.first?.id == self.ramb.id ? .accent4 : .primary)
                        
                    }.buttonStyle(BorderlessButtonStyle())
                    
                    Text("3:30")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                }
            }.padding()
            
        }.onTapGesture(perform: {
            play()
        })
        .cornerRadius(15)
    }
    
    func play() {
        globalPlayer.globalRamb = [self.ramb]
        globalPlayer.setGlobalPlayer(ramb: self.ramb)
        globalPlayer.play()
    }
}


//struct RambCell_Previews: PreviewProvider {
//    static var previews: some View {
//        RambCell(ramb: _ramb)
//            .environmentObject(SessionStore())
//            .environmentObject(GlobalPlayer())
//    }
//}
