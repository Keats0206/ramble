
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
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = UserService2()
    
    @State var searchText = ""
    @State var isSearching = false
    
    var body: some View {
        ZStack{
            VStack(alignment: .center) {
                SearchBar(searchText: $searchText, isSearching: $isSearching)
                List{
                    ForEach(self.viewModel.users.filter{($0.username.lowercased()).contains(self.searchText.lowercased()) || ($0.displayname.lowercased()).contains(self.searchText.lowercased())}, id: \.self) { user in
                        SearchCell(user: user)
                    }
                }
                Spacer()
            }
        }
        .onAppear{
            self.viewModel.fetchUsers()
        }
        .navigationBarItems(leading:
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }){
                Text("Cancel")
                    .foregroundColor(.red)
            }
        )
    }
}

struct SearchCell: View {
    var user: User
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: user.profileImageUrl))
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            VStack(alignment: .leading) {
                Text(user.username)
                    .font(.title)
                    .bold()
                Text(user.displayname)
                    .font(.subheadline)
            }
            Spacer()
            Spacer()
            Button(action: {
//                UserService.shared.followUser(uid: self.user.uid)
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
        
       HStack {
           HStack {
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

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
