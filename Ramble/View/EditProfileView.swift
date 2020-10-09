//
//  SettingView.swift
//  Ramble
//
//  Created by Peter Keating on 6/11/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct EditProfileView : View {
    @EnvironmentObject var session: SessionStore
    @Environment(\.presentationMode) var presentationMode

    @State var email: String = ""
    @State var username: String = ""
    @State var displayname: String = ""
    @State var profileImage: UIImage?
    @State var bio = ""
    @State var showAction: Bool = false
    @State var showImagePicker: Bool = false
    @State var loading = false
    @State var error = false
    
    var user: User
    
    func updateProfile(){
        print("DEBUG: Update user profile")
    }
    
    func openThing(){
        print("Open link to review")
    }
    
    var sheet: ActionSheet {
        
        ActionSheet(
            title: Text("Action"),
            message: Text("Quotemark"),
            buttons: [
                .default(Text("Change"), action: {
                    self.showAction = false
                    self.showImagePicker = true
                }),
                .cancel(Text("Close"), action: {
                    self.showAction = false
                }),
                .destructive(Text("Remove"), action: {
                    self.showAction = false
                    self.profileImage = nil
                })
            ])
    }
    
    var body : some View {
        
        NavigationView{
            
            ZStack{
            
            Color.white
            
            VStack(spacing: 20){
                
                HStack(alignment: .top){
                    
                    WebImage(url: URL(string: "\(user.profileImageUrl ?? "")"))
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(Color.red, lineWidth: 5))
                                                                    
                    Button(action: {
                        self.showImagePicker = true
                    }){
                        Text("Replace")
                            .font(.body).bold()
                            .padding(5)
                            .padding([.trailing,.leading])
                    }.background(Capsule().stroke(lineWidth: 2))
                        .sheet(isPresented: $showImagePicker, onDismiss: {
                    
                    self.showImagePicker = false
                    
                }, content: {
                        
                        ImagePicker(isShown: self.$showImagePicker, uiImage: self.$profileImage)
                        
                    }).actionSheet(isPresented: $showAction) {
                        sheet

                    }

                    Spacer()

                }
                                            
                VStack(alignment: .leading, spacing: 5){
                    
                    Text("Username")
                        .font(.system(size: 14, weight: .bold))
                    
                    TextField("\(self.user.username ?? "")", text: $username)
                        .font(.system(size: 18, weight: .bold))
                        .padding(12)
                    
                    Divider()

                }
                
                VStack(alignment: .leading, spacing: 5){
                    
                    Text("Fullname")
                        .font(.system(size: 14, weight: .bold))
                    
                    TextField("\(self.user.displayname ?? "")", text: $displayname)
                        .font(.system(size: 18, weight: .bold))
                        .padding(12)
                    
                    Divider()
                }
                
                VStack(alignment: .leading, spacing: 5){
                    
                    Text("Bio")
                        .font(.system(size: 14, weight: .bold))
                    
                    TextField("\(self.user.bio ?? "")", text: $bio)
                        .font(.system(size: 18, weight: .bold))
                        .padding(12)
                    
                    Divider()
                    
                }
                
                HStack{

                        Button(action: {

                        UIApplication.shared.open(URL(string:"https://www.rambleon.app/")!)

                    }) {

                        Text("Privacy & Terms")

                    }

                    Spacer()
                }

                Divider()

                HStack{

                        Button(action: {

                        UIApplication.shared.open(URL(string:"https://www.rambleon.app/")!)

                    }) {

                        Text("Give Feedback")

                    }

                    Spacer()
                }

                Divider()

                HStack{

                    Button(action: {

                        UIApplication.shared.open(URL(string:"https://www.rambleon.app/")!)

                    }) {

                        Text("Rate Us")

                    }

                    Spacer()

                }
     
            }.padding()
            }
            .navigationBarItems(trailing:
            Button(action: {
                print("Save changes")
                presentationMode.wrappedValue.dismiss()
            }){
                Text("Post")
                    .font(.system(.headline,design: .rounded)).bold()
                    .foregroundColor(.red)
                }
            )
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(user: _user2)
    }
}
