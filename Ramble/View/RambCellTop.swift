//
//  RambCellTop.swift
//  Ramble
//
//  Created by Peter Keating on 9/4/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct RambCellTop: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var selectedRamb: SelectedRamb
    @ObservedObject var viewModel = RambService()
    
    @State private var showingActionSheet = false
    @State private var isActive = false
    
    var ramb: Ramb
    
//    @State var newClaps = 0
//    @State var didClap = false
//    @State var claps = 0
    
    var body: some View {
        
        HStack{
            
            VStack(alignment: .center, spacing: 10){
                
                WebImage(url: ramb.user.profileImageUrl)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                        .shadow(radius: 10)
                        .overlay(Circle().stroke(Color.red, lineWidth: 5))

                        .onTapGesture { self.isActive.toggle() } // activate link on image tap
                        .background(NavigationLink(destination:  // link in background
                            ProfileView(user: ramb.user), isActive: $isActive) { EmptyView() })
                
                if ramb.user.uid != session.session?.uid {
                    
                    Spacer().frame(height: 10)
                    
                } else {
                    
                    Button(action: {
                        self.showingActionSheet.toggle()
                    }){
                        Image(systemName: "ellipsis")
                            .frame(height: 10)
                            .accentColor(.red)
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
            
//              Center of Cell VStack
            
            VStack(alignment: .leading){

//                  Username + timestamp
                
                HStack {
                    
                    Text("@" + ramb.user.username).font(.body).fontWeight(.heavy)
                    
                    Text(formatDate(timestamp: ramb.timestamp) + " ago")
                    
                }
                
//                  Caption
                
                Text(ramb.caption)
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .multilineTextAlignment(TextAlignment.leading)
                
                Spacer()
                
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 10){
                
                Image(systemName: "play.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                
                Text("3:30")
                
            }
                        
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.2))
            )
//        .onAppear{
//
//            self.claps = self.ramb.claps
//
//            self.viewModel.checkIfUserLikedRamb(self.ramb){ ramb in
//                if ramb {
//                    self.didClap = true
//                } else {
//                    self.didClap = false
//                }
//            }
//
//        }
    }
}
