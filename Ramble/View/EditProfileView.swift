//
//  SettingView.swift
//  Ramble
//
//  Created by Peter Keating on 6/11/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

// This view needs the current user passed in...

struct EditProfileView : View {
    @EnvironmentObject var session: SessionStore
    
    @State var email: String = ""
    @State var username: String = ""
    @State var fullname: String = ""
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
        ZStack {
            
            VStack {
                
                HStack{
                    
                    Spacer()
            
                    Button(action: updateProfile) {
                        Text("Save Updates")
                            .foregroundColor(.red)
                            .font(.system(size: 18, weight: .bold))
                    }
                }
            
                Spacer()
                // Image picker
                
                VStack {
                    if (profileImage == nil) {
                        
                        VStack{
                            Image(systemName: "camera.on.rectangle")
                                .frame(width: 100, height: 100)
                                .cornerRadius(6)
    
                            Text("Add a profile picture")
                                .font(.system(size: 18, weight: .bold))

                        }.onTapGesture {
                            self.showImagePicker = true
                        }
                    
                    } else {
                        Image(uiImage: profileImage!)
                            .resizable()
                            .frame(width: 200, height: 200)
                            .cornerRadius(200 / 2)
                            .onTapGesture {
                                self.showAction = true
                        }
                        Text("Change picture").font(.system(size: 18, weight: .bold))
                    }
                
                }.sheet(isPresented: $showImagePicker, onDismiss: {
                
                    self.showImagePicker = false
                
                }, content: {
                    ImagePicker(isShown: self.$showImagePicker, uiImage: self.$profileImage)
                }).actionSheet(isPresented: $showAction) {
                        sheet
                }
                
                Spacer()
                
                VStack(alignment: .leading){
                    
                    HStack{
                        
                        Text("Email").font(.system(size: 14, weight: .bold))
                        
                        TextField("\(self.user.email)", text: $email)
                            .font(.system(size: 18, weight: .bold))
                            .padding(12)
                    
                    }
                    
                    Divider()
                    
                    HStack{
                        
                        Text("Fullname")
                            .font(.system(size: 14, weight: .bold))
                        
                        TextField("\(self.user.fullname)", text: $fullname)
                            .font(.system(size: 18, weight: .bold))
                            .padding(12)
                    }
                    
                    Divider()
                    
                    HStack{
                        
                        Text("Username")
                            .font(.system(size: 14, weight: .bold))
                        
                        TextField("\(self.user.username)", text: $username)
                            .font(.system(size: 18, weight: .bold))
                            .padding(12)
                    }
                    
                    Divider()
                    
                    HStack{
                        
                        VStack{
                            
                            Spacer().frame(height: 25)
                            
                            Text("Bio")
                                .font(.system(size: 14, weight: .bold))
                                .onAppear{
                                self.bio = "\(String(describing: self.user.bio))"
                            }
                        
                            Spacer()
                            
                        }
                        
                        MultiLineTF(txt: $bio).padding()
                        
                    }
                }
                
                Spacer()
                
                VStack{
                    
                    Divider()
                    
                    HStack{
                        
                        Button(action: openThing) {
                        
                            Text("Report Feedback")
                                .font(.system(size: 14, weight: .bold))
                            
                            Spacer()
                        }
                    }
                    
                    Divider()
                    
                    HStack{
                        Button(action: openThing) {
                            Text("Leave A Review")
                                .font(.system(size: 14, weight: .bold))
                            Spacer()
                        }
                    }
                    
                    Divider()
                    
                    HStack{
                        Button(action: openThing) {
                            Text("Add Friends")
                                .font(.system(size: 14, weight: .bold))
                            Spacer()
                        }
                    }
                    
                    Divider()
                    
                    HStack{
                        Button(action: openThing) {
                            Text("Privacy Policy")
                                .font(.system(size: 14, weight: .bold))
                            Spacer()
                        }
                    }
                    
                    Divider()
                }
                
                HStack{
                    
                    Spacer()
                    
                    Button(action: updateProfile) {
                        Text("Logout")
                            .foregroundColor(.red)
                            .font(.system(size: 18, weight: .bold))
                    }
                    
                    Spacer()
                }
                
            }.padding()
        }
    }
}
