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
        
        ZStack{
            
            HStack(alignment: .center){
                
                VStack(alignment: .center, spacing: 10){
                    WebImage(url: URL(string: "\(ramb.user.profileImageUrl ?? "")"))
                        .frame(width: 75, height: 75)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(globalPlayer.globalRamb?.id == self.ramb.id ? Color.accent3 : .primary, lineWidth: 3))
                        .onTapGesture { self.isActive.toggle() } // activate link on image tap
                        .background(NavigationLink(destination:  // link in background
                                ProfileView(offset: CGSize(width: 0, height: 0), user: ramb.user), isActive: $isActive) { EmptyView()
                        }).buttonStyle(BorderlessButtonStyle())
                    
                    Spacer()
                    
//                    Button(action: {
//                        print("open ramb action menu")
//                    }){
//                        Image(systemName: "ellipsis")
//                            .frame(height: 10)
//                            .actionSheet(isPresented: $showingActionSheet) {
//                                ActionSheet(title: Text("Are you sure you want to delete this ramble?"),
//                                            buttons:[
//                                                .default(
//                                                    Text("Delete").foregroundColor(.red), action: {
//                                                        print("delete ramb")
////                                                        self.viewModel.deleteRamb(ramb: self.ramb)
//                                    }),.cancel()
//                                ])
//                        }
//                    }.buttonStyle(BorderlessButtonStyle())
//                    .foregroundColor(Color.accent4)
                }
                
//              Center of Cell VStack
                
                VStack(alignment: .leading){
                    //                  Username + timestamp
                    
                    HStack{
                        
                        Text("@" + (ramb.user.username ?? ""))
                            .font(.system(size: 18, weight: .heavy, design: .rounded))
                            .bold()
                        //                  Caption
                        
                        Text(formatDate(timestamp: ramb.timestamp))
                            .font(.system(.body, design: .rounded))
                        
                    }
                    
                    Text(ramb.caption)
                        .font(.system(size: 22,weight: .regular, design: .rounded))
                        .bold()
                        .multilineTextAlignment(TextAlignment.leading)
                    
                    Spacer()
                    
                }
                
                Spacer()
                
                VStack(alignment: .center){
                    
                    Button(action: {
                        globalPlayer.globalRamb = self.ramb
                        globalPlayer.setGlobalPlayer(ramb: self.ramb)
                        globalPlayer.globalRambPlayer?.play()
                        globalPlayer.isPlaying = true
                    }){
                        Image(systemName: "play.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(globalPlayer.globalRamb?.id == self.ramb.id ? .accent4 : .primary)

                    }.buttonStyle(BorderlessButtonStyle())
                    
                    Text("3:30")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                }
            }.padding()
        
        }
        .frame(height: 150)
        .cornerRadius(15)
    }
}


//struct RambCell_Previews: PreviewProvider {
//    static var previews: some View {
//        RambCell(ramb: _ramb)
//            .environmentObject(SessionStore())
//            .environmentObject(GlobalPlayer())
//    }
//}
