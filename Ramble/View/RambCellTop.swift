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
    
    var ramb: Ramb
    
    @State var newClaps = 0
    @State var didClap = false
    @State var claps = 0
    
    var body: some View {
        
        HStack{
            
            VStack{
                
                AnimatedImage(url: ramb.user.profileImageUrl)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 60, height: 60, alignment: .center).onTapGesture {
                        
                        if self.session.session!.uid != self.ramb.user.uid {
                            
                            self.selectedRamb.user = self.ramb.user
                            
                            self.selectedRamb.userProfileShown.toggle()
                            
                            print("set selected user to user with id of: \(self.ramb.user.uid) and the view isShown is set to: \(self.selectedRamb.userProfileShown)")
                            
                        } else {
                            
                            print("no need to open my own profile")
                            
                        }
                        
                }
                
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
            
            VStack{
                
                HStack{
                    
                    //              Clap and clap count
                    
                    VStack{
                        
                        Button(action: {
                            
                            self.didClap.toggle()
                            self.viewModel.handleClap(ramb: self.ramb, didClap: self.didClap)
                            self.claps = self.didClap ? self.claps + 1 : self.claps - 1
                            
                        }){
                            
                            Image(systemName: self.didClap ? "hand.thumbsup.fill" : "hand.thumbsup")
                                .resizable()
                                .frame(width: 20, height: 20)
                            
                        }.buttonStyle(BorderlessButtonStyle())
                        
                        Text(String((self.claps)))
                        
                    }
                    
                    
                    
                }
                
            }
            
        }.onAppear{
            
            self.claps = self.ramb.claps
            
            self.viewModel.checkIfUserLikedRamb(self.ramb){ ramb in
                if ramb {
                    self.didClap = true
                } else {
                    self.didClap = false
                }
            }
            
        }
    }
}
