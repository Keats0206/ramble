//
//  SettingsView.swift
//  Ramble
//
//  Created by Peter Keating on 9/3/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var session = SessionStore()
    @State private var showingActionSheet = false
    
    var body: some View {
        
        ZStack{
            
            Color.white
            
            VStack(alignment: .leading){
                
                HStack{
                    
                    Spacer()
                                        
                }.padding()
                
                    VStack(alignment: .leading, spacing: 30){
                        
                        Button(action: {
                            
                            print("DEBUG: delete function")
                        
                        }) {
                        
                            Text("Edit Account")
                        
                        }
                        
                        Button(action: {
                            
                            UIApplication.shared.open(URL(string:"https://www.rambleon.app/")!)
                            
                        }) {
                            
                            Text("Privacy & Terms")
                        
                        }
                        
                            Button(action: {
                                
                                UIApplication.shared.open(URL(string:"https://www.rambleon.app/")!)
                            
                            }) {
                            
                                Text("Give Feedback")
                            
                            }
                        
                            Button(action: {
                            
                                UIApplication.shared.open(URL(string:"https://www.rambleon.app/")!)
                            
                            }) {
                            
                                Text("Rate Us")
                            
                            }
                        
                    }.padding()
                
                Spacer()
                
                Spacer()
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 30){
                                    
                    Button(action: {
                        
                        self.showingActionSheet.toggle()
                        
                    }) {
                        
                        Text("Logout")
                            .actionSheet(isPresented: $showingActionSheet) {
                            
                                ActionSheet(title: Text("Are you sure you want to logout?"), buttons:[.default(Text("Logout").foregroundColor(.blue),
                                            action: {
                                                self.session.signOut()
                                                
                                }),.cancel()
                                    ]
                                )
                            }
                    }
                    
                }.padding()
                
                Spacer()
                
            }.padding(.top, UIApplication.shared.windows.first{$0.isKeyWindow}?.safeAreaInsets.top)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    
    @State static var value = false
    
    static var previews: some View {
        SettingsView()
    }
}
