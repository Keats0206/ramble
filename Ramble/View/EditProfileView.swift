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
        
        ZStack{
            
            Color.white
            
            VStack(spacing: 20){
                
                HStack{
                    
                    Spacer()
                    
                    Button(action: {
                        
                        print("DEBUG: Update profile information")
                        
                    }) {
                        Text("Save")
                            .foregroundColor(.red)
                            .font(.system(size: 18, weight: .bold))
                    }
                    
                }.padding()
                
                Spacer().frame(height: 10)
                                
                VStack(alignment: .leading, spacing: 5){
                    
                    Text("Username")
                        .font(.system(size: 14, weight: .bold))
                    
                    TextField("\(self.user.username ?? "")", text: $username)
                        .font(.system(size: 18, weight: .bold))
                        .padding(12)
                    
                    Divider()

                }
                            
                HStack{
                    
                    WebImage(url: URL(string: "\(user.profileImageUrl ?? "")"))
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(Color.red, lineWidth: 5))
                    
                    VStack{
                        
                        Text("Profile Picture").font(.system(size: 14, weight: .bold))
                        
                        Button(action: {
                            self.showImagePicker = true
                        }){
                            Text("Upload")
                                .font(.body).bold()
                                .padding(5)
                                .padding([.trailing,.leading])
                        }.background(Capsule().stroke(lineWidth: 2))
                        
                    }.sheet(isPresented: $showImagePicker, onDismiss: {
                        
                        self.showImagePicker = false
                        
                    }, content: {
                        
                        ImagePicker(isShown: self.$showImagePicker, uiImage: self.$profileImage)
                        
                    }).actionSheet(isPresented: $showAction) {
                        sheet
                    }
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
                
                Spacer()
                
                Spacer()
                                
            }.padding()
            .padding(.top, UIApplication.shared.windows.first{$0.isKeyWindow}?.safeAreaInsets.top)
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(user: _user2)
    }
}
