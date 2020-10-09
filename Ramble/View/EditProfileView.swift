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
    
    func saveProfile(){
        UserService2.shared.saveUserProfile(user: user, username: username, fullname: displayname, bio: bio)
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
            
            Color.black
            
            VStack(spacing: 20){
                
                HStack(spacing: 20){
                    
                    WebImage(url: URL(string: "\(user.profileImageUrl ?? "")"))
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(Color.accent3, lineWidth: 5))
                                                                    
                    VStack{
                        
                        Text("Profile Pic")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                        
                            Button(action: {
                            
                            self.showImagePicker = true
                            
                        })
                            {
                            
                            Text("Change")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
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
                                                
                    }.frame(height: 100)

                    Spacer()

                }
                                            
                VStack(alignment: .leading, spacing: 5){
                    
                    Text("Username")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                    
                    TextField("\(self.user.username ?? "")", text: $username)
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .padding(5)
                    
                    Divider()

                }
                
                VStack(alignment: .leading, spacing: 5){
                    
                    Text("Fullname")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                    
                    TextField("\(self.user.displayname ?? "")", text: $displayname)
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .padding(5)
                    
                    Divider()
                }
                
                VStack(alignment: .leading, spacing: 5){
                    
                    Text("Bio")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                    
                    TextField("\(self.user.bio ?? "")", text: $bio)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .padding(5)
                    
                    Divider()
                    
                }
                
                HStack{

                        Button(action: {

                        UIApplication.shared.open(URL(string:"https://www.rambleon.app/")!)

                    }) {

                        Text("Privacy & Terms")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                    }

                    Spacer()
                }

                Divider()

                HStack{

                        Button(action: {

                        UIApplication.shared.open(URL(string:"https://www.rambleon.app/")!)

                    }) {

                        Text("Give Feedback")
                            .font(.system(size: 20, weight: .bold, design: .rounded))

                    }

                    Spacer()
                }

                Divider()

                HStack{

                    Button(action: {

                        UIApplication.shared.open(URL(string:"https://www.rambleon.app/")!)

                    }) {

                        Text("Rate Us")
                            .font(.system(size: 20, weight: .bold, design: .rounded))

                    }

                    Spacer()

                }
     
            }
                .foregroundColor(.white)
                .padding()
            }
            .navigationBarItems(leading:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                        }){
                    Text("Cancel")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .foregroundColor(Color.accent2)
                }, trailing:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    self.saveProfile()
                }){
                    Text("Save")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .foregroundColor(Color.accent1)
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
