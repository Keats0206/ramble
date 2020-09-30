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
    @ObservedObject var viewModel = RambService()
    
    @State private var showingActionSheet = false
    
    var ramb: Ramb
    
    var body: some View {
        HStack{
//              Center of Cell VStack
            VStack(alignment: .leading){
                
                Text(ramb.caption)
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .multilineTextAlignment(TextAlignment.leading)

//               Username + timestamp
                                        
                    Text(formatDate(timestamp: ramb.timestamp) + " ago")
                    
                }
                                        
            Spacer()
            
            Button(action: {
                self.showingActionSheet.toggle()
            }){
                Image(systemName: "ellipsis")
                    .frame(height: 10)
                    .accentColor(Color.accent1)
                    .actionSheet(isPresented: $showingActionSheet) {
                        ActionSheet(title: Text("Are you sure you want to delete this ramble?"),
                                    buttons:[
                                        .default(
                                            Text("Delete").foregroundColor(.red), action: {
                                                self.viewModel.deleteRamb(ramb: self.ramb)
                                    }),.cancel()
                        ])
                }
            }.buttonStyle(BorderlessButtonStyle())
        }
    }
}
