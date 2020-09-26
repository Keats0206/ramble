
//
//  SearchView.swift
//  Ramble
//
//  Created by Peter Keating on 9/8/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchView: View {
    @ObservedObject var viewModel = UserService()
        
    @State var searchText = ""
    @State var isSearching = false
    
    var body: some View {
        
          ZStack{
                
                Color.white
            
                VStack(alignment: .center){
                        HStack{
                            Button(action: {
                                self.viewModel.fetchUsers()
                            }){
                                Text("Fetch data")
                            }
                            Spacer()
                        }.padding()
                    
                        SearchBar(searchText: $searchText, isSearching: $isSearching)
                    
                        List{
                              ForEach(self.viewModel.users.filter{$0.fullname.lowercased().contains(self.searchText.lowercased())}, id: \.self) { user in
                                        SearchCell(user: user)
                            }
                        }
                    
                        Spacer()
                        
            }.padding(.top, UIApplication.shared.windows.first{$0.isKeyWindow}?.safeAreaInsets.top)
        
        }
    
    }

}

struct SearchCell: View {
    
    var user: User
    
    var body: some View {
        
        HStack{
            
            AnimatedImage(url: user.profileImageUrl)
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            VStack(alignment: .leading){
                
                Text("\(user.username)")
                    .font(.title)
                    .bold()
                
                Text("\(user.fullname)")
                    .font(.subheadline)
                
            }
            
            Spacer()
            
            Spacer()
            
            
            Button(action: {
                                
                UserService.shared.followUser(uid: self.user.uid)
                
            }){
                
                Image(systemName: "person.badge.plus.fill")
                    .foregroundColor(.red)
                    .frame(width: 30, height: 30)
                
            }.buttonStyle(BorderlessButtonStyle())
                
                
                

    
        }.padding()
    }
}

struct SearchBar: View {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    
    var body: some View {
        
       HStack{
           
           HStack{
                   
               TextField("Search terms here", text: $searchText)
                   .padding(.leading, 24)
               
           }.padding()
           .background(Color(.systemGray5))
           .cornerRadius(6)
           .padding(.horizontal)
           .onTapGesture(perform: {
               self.isSearching.toggle()
           })
           .overlay(
               HStack{
                   Image(systemName: "magnifyingglass")
                   
                   Spacer()
                   
                   if isSearching {
                       Button(action: { self.searchText = "" }, label: {
                           Image(systemName: "xmark.circle.fill")
                               .padding(.vertical)
                       })
                   }
               }.padding(.horizontal, 32)
               .foregroundColor(.gray)
           )
           
           if isSearching {
               
               Button(action: {
                   self.isSearching.toggle()
                   self.searchText = ""
               }, label: {
                   Text("Cancel")
                       .padding(.trailing)
                       .padding(.leading, 0)
               }).transition(.move(edge: .trailing))
               .animation(.easeInOut)
           }
       
       }

    }
}
