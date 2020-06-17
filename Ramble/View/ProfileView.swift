//
//  ProfileView.swift
//  Ramble
//
//  Created by Peter Keating on 4/21/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//
import SwiftUI

struct ProfileView: View {
    @Binding var isShown:Bool
    
    var body: some View {
        ZStack(){
            VStack{
                HStack{
                    
                Button(action: {
                    self.isShown.toggle()
                }){
                    Image(systemName: "arrow.uturn.down.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                }.buttonStyle(BorderlessButtonStyle())
                
                Spacer()
                
                Spacer()
                
                Spacer()
                
                Button(action: {
                     print("return to previous view")
                }){
                    Image(systemName: "gear")
                        .resizable()
                        .frame(width: 20, height: 20)
                }.buttonStyle(BorderlessButtonStyle())
                }.frame(height: 20)
                
                ProfileHeader()
                
//              TODO: Replace this feed with a a view of only a user's posts!
                
                RambFeed()
            }
        }
    }
}
