//
//  ProfileView.swift
//  Ramble
//
//  Created by Peter Keating on 4/21/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//
import SwiftUI
import FirebaseAuth

struct ProfileView: View {
//    @EnvironmentObject var session: SessionStore
    @Binding var isShown:Bool
    @State var flag = false
    
//     func signOut () -> Bool {
//           do {
//               try Auth.auth().signOut()
//               return true
//           } catch {
//               return false
//           }
//       }
    
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
                    self.flag.toggle()
                }){
                    Image(systemName: "gear")
                        .resizable()
                        .frame(width: 20, height: 20)
                }.buttonStyle(BorderlessButtonStyle())
                }.frame(height: 20).offset(y: 10)
                
                if flag {
                    SettingsView()
                    
                    Spacer()
                } else {
                
                ProfileHeader()
                
//              TODO: Replace this feed with a a view of only a user's posts!
                
                RambHotFeed()
                }
            }
        }
    }
}
