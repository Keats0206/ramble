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
    
    func saveProfile() {
        if let image = profileImage {
            self.loading = true
            UserService2.shared.updateProfileImage(image: image) { url in
                self.loading = false
                self.user.profileImageUrl = url
                self.updateUserData()
                self.presentationMode.wrappedValue.dismiss()
            }
        } else {
            updateUserData()
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func updateUserData() {
        UserService2.shared.saveUserProfile(user: user)
        RambService2.shared.updateUserData(user: user)
    }
    
    func openThing() {
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
        NavigationView {
            LoadingView(isShowing: $loading, content: {
                ZStack {
                    VStack(spacing: 20) {
                        changeProfileImage
                            .font(.system(.subheadline, design: .rounded))
                        editUserInfo
                        settingsLinks
                        Spacer()
                        logoutDelete
                            .font(.system(.subheadline, design: .rounded))
                    }
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.flatDarkBackground)
                    .padding()
                }
            })
            .navigationBarItems(leading:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                        }) {
                    Text("Cancel")
                }, trailing:
                Button(action: {
                    self.saveProfile()
                }) {
                    Text("Save")
                }
            ).font(.system(.headline, design: .rounded))
            .foregroundColor(Color.accent3)
        }
    }
}

private extension EditProfileView {
    var changeProfileImage: some View {
        VStack {
            NetworkImage(url: URL(string: user.profileImageUrl), image: profileImage)
                .frame(width: 200, height: 200)
                .cornerRadius(10)
                .shadow(radius: 10)
                
            Button(action: {
                self.showImagePicker = true
            }) {
                Text("Change Photo")
                    .foregroundColor(.primary)
                    .padding(5)
                    .padding([.trailing,.leading])
            }.sheet(isPresented: $showImagePicker, onDismiss: {
            self.showImagePicker = false
                }, content: {
                ImagePicker(isShown: self.$showImagePicker, uiImage: self.$profileImage)
                }).actionSheet(isPresented: $showAction) {
                    sheet
            }
        }
    }
    var editUserInfo: some View {
        VStack(spacing: 20){
            VStack(alignment: .leading, spacing: 5) {
                Text("Username")
                TextField(self.user.username, text: $user.username)
                    .padding(5)
                    .opacity(0.5)
                Divider()
            }
        
            VStack(alignment: .leading, spacing: 5) {
                Text("Fullname")
                TextField(self.user.displayname, text: $user.displayname)
                    .padding(5)
                    .opacity(0.5)
                Divider()
            }
            VStack(alignment: .leading, spacing: 5) {
                Text("Bio")
                TextField(self.user.bio, text: $user.bio)
                    .padding(5)
                    .opacity(0.5)
                Divider()
            }
        }.foregroundColor(.primary)
    }
    
    var settingsLinks: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {
                    UIApplication.shared.open(URL(string:"https://www.rambleon.app/")!)
                }) {
                    Text("Privacy & Terms")
                }
                Spacer()
            }
            HStack {
                Button(action: {
                    UIApplication.shared.open(URL(string:"https://www.rambleon.app/")!)
                }) {
                    Text("Give Feedback")
                }
                Spacer()
            }
            HStack {
                Button(action: {
                    UIApplication.shared.open(URL(string:"https://www.rambleon.app/")!)
                }) {
                    Text("Rate Us")
                }
                Spacer()
            }
        }.foregroundColor(Color.accent3)
    }
    
    var logoutDelete: some View {
        HStack {
            Spacer()
                Button(action: {
                    self.session.signOut()
                }) {
                    Text("Logout")
                }
            Spacer()
                Button(action: {
                    print("")
                }) {
                    Text("Delete")
                }
            Spacer()
            
        }.foregroundColor(Color.red)
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(user: .constant(testUser))
            .environment(\.colorScheme, .dark)
    }
}

struct NetworkImage: View {
    let url: URL?
    let image: UIImage?
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if let url = url, let imageData = try? Data(contentsOf: url), let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image(uiImage: #imageLiteral(resourceName: "Compose"))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
    }
}
