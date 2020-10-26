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

    @State var profileImage: UIImage?
    @State var showAction: Bool = false
    @State var showImagePicker: Bool = false
    @State var loading = false
    @State var error = false
    
    @Binding var user: User
    
    func saveProfile(){
        UserService2.shared.saveUserProfile(user: user)
        RambService2.shared.updateUserData(user: user)
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
                        
            VStack(spacing: 20){
                
                VStack{
                    
                    WebImage(url: URL(string: user.profileImageUrl))
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(Color.accent3, lineWidth: 5))
                    
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
                                            
                VStack(alignment: .leading, spacing: 5){
                    
                    Text("Username")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                    
                    TextField(self.user.username, text: $user.username)
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .padding(5)
                    
                    Divider()

                }
                
                VStack(alignment: .leading, spacing: 5){
                    
                    Text("Fullname")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                    
                    TextField(self.user.displayname, text: $user.displayname)
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .padding(5)
                    
                    Divider()
                }
                
                VStack(alignment: .leading, spacing: 5){
                    
                    Text("Bio")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                    
                    TextField(self.user.bio, text: $user.bio)
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
        EditProfileView(user: .constant(testUser))
    }
}
