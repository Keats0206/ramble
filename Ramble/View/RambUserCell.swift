//
//  RambUserCell.swift
//  Ramble
//
//  Created by Peter Keating on 9/18/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct RambUserCell: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var globalPlayer: GlobalPlayer
    
    @State private var showingActionSheet = false
    
    var ramb: Ramb2
    
    var body: some View {
        HStack{
//              Center of Cell VStack
            VStack(alignment: .leading){
                Button(action:{
                    globalPlayer.globalRambs = [self.ramb]
                    globalPlayer.setGlobalPlayer(ramb: self.ramb)
                    globalPlayer.play()
                }){
                    Text(ramb.caption)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .multilineTextAlignment(TextAlignment.leading)
                        .foregroundColor(globalPlayer.globalRambs?.first?.id == self.ramb.id ? .accent4 : .primary)
                    
                }.buttonStyle(BorderlessButtonStyle())
                
                //               Username + timestamp
                Text(formatDate(timestamp: ramb.timestamp) + " ago")
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                
            }
            
            
            Spacer()
            
            Text("3:30")
                .font(.system(size: 18, weight: .regular, design: .rounded))
            
            if ramb.user.isCurrentUser {
                Button(action: {
                    self.showingActionSheet.toggle()
                }){
                    Image(systemName: "ellipsis")
                        .frame(height: 10)
                        .accentColor(Color.accent4)
                        .actionSheet(isPresented: $showingActionSheet) {
                            ActionSheet(title: Text("Are you sure you want to delete this ramble?"),
                                        buttons:[
                                            .default(
                                                Text("Delete").foregroundColor(.red), action: {
                                                    print("DEBUG: delete ramb")
                                                }),.cancel()
                                        ])
                        }
                }.buttonStyle(BorderlessButtonStyle())
            } else {
                Button(action: {
                    self.showingActionSheet.toggle()
                }){
                    Image(systemName: "ellipsis")
                        .frame(height: 10)
                        .accentColor(Color.accent4)
                        .actionSheet(isPresented: $showingActionSheet) {
                            ActionSheet(title: Text("Report this ramb?"),
                                        buttons:[
                                            .default(
                                                Text("Report").foregroundColor(.red), action: {
                                                    print("DEBUG: report ramb")
                                                }),.cancel()
                                        ])
                        }
                }.buttonStyle(BorderlessButtonStyle())
                
            }
            
        }
        .padding()
    }
}

struct RambUserCell_Previews: PreviewProvider {
    static var previews: some View {
        RambUserCell(ramb: testRamb)
    }
}
