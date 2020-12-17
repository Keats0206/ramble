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
    @EnvironmentObject var settings: SessionSettings
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var userModel = UserService2.shared
    @ObservedObject var rambModel = RambService2.shared


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
                settings.setAverageColor(image: image)
                settings.setSettings(user: user)
                self.presentationMode.wrappedValue.dismiss()
            }
        } else {
            updateUserData()
            settings.setSettings(user: user)
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func updateUserData() {
        userModel.saveUserProfile(user: user)
        rambModel.updateUserData(user: user)
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
            ZStack {
                GeometryReader { geometry in
                    Image("gradient2")
                        .resizable()
                        .aspectRatio(geometry.size, contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                    Blur(style: .dark)
                        .edgesIgnoringSafeArea(.all)
                    VStack(spacing: 20) {
                            changeProfileImage
                            editUserInfo
                            Spacer()
                            settingsLinks
                                .padding(.bottom, 20)
                            logoutDelete
                    }.font(.system(.headline, design: .rounded))
                    .padding()
                }
            }
            .navigationBarItems(leading:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                        }) {
                    Text("Cancel")
                        .foregroundColor(.white)
                }, trailing:
                Button(action: {
                    self.saveProfile()
                }) {
                    Text("Save")
                        .foregroundColor(.white)
                        .bold()
                }
            )
            .font(.system(.headline, design: .rounded))
            .foregroundColor(.white)
        }
    }
    
}

private extension EditProfileView {
    var changeProfileImage: some View {
            VStack {
                NetworkImage(url: URL(string: user.profileImageUrl!), image: profileImage)
                    .frame(width: 200, height: 200)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    
                Button(action: {
                    self.showImagePicker = true
                }) {
                    Text("Change Photo")
                        .foregroundColor(.white)
                        .padding(5)
                        .padding([.trailing, .leading])
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
        VStack(spacing: 20) {
        VStack(alignment: .leading, spacing: 5) {
            Text("Username")
            TextField(user.username, text: $user.username)
                .padding(5)
                .opacity(0.5)
            Divider()
        }
        VStack(alignment: .leading, spacing: 5) {
            Text("Display Name")
            TextField(user.displayname, text: $user.displayname)
                .padding(5)
                .opacity(0.5)
            Divider()
        }
        VStack(alignment: .leading, spacing: 5) {
            Text("Bio")
            TextField(user.bio, text: $user.bio)
                .padding(5)
                .opacity(0.5)
            Divider()
        }
    }
            .font(.headline)
            .foregroundColor(.white)
        }
    var settingsLinks: some View {
        VStack(spacing: 20) {
//            HStack {
//                Button(action: {
//                    UIApplication.shared.open(URL(string: "https://www.rambleon.app/")!)
//                }) {
//                    Text("Privacy & Terms")
//                }
//                Spacer()
//            }
            HStack {
                Button(action: {
                    let email = "pete@pekeating.com"
                    if let url = URL(string: "mailto:\(email)") {
                      if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url)
                      } else {
                        UIApplication.shared.openURL(url)
                      }
                    }
                }) {
                    Text("Give Feedback")
                }
                Spacer()
            }
//            HStack {
//                Button(action: {
//                    UIApplication.shared.open(URL(string:"https://www.rambleon.app/")!)
//                }) {
//                    Text("Rate Us")
//                }
//                Spacer()
//            }
        }
        .font(.headline)
        .foregroundColor(.white)
    }
    var logoutDelete: some View {
        HStack {
            Spacer()
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
                self.session.signOut()
            }){
                HStack {
                    Image(systemName: "arrow.right.circle.fill")
                    Text("LOGOUT")
                }
            }
            Spacer()
        }
        .font(.headline)
        .foregroundColor(.white)
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
