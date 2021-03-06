//
//  AuthView.swift
//  Ramble
//
//  Created by Peter Keating on 4/22/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct SignInView : View {
    @State var email: String = ""
    @State var password: String = ""
    @State var loading = false
    @State var error = false
    
    @EnvironmentObject var session: SessionStore
    
    func signIn () {
        loading = true
        error = false
        session.signIn(email: email, password: password) { (result, error) in
            self.loading = false
            if error != nil {
                self.error = true
            } else {
                self.email = ""
                self.password = ""
            }
        }
    }
    
    var body: some View {
        LoadingView(isShowing: $loading) {
            ZStack {
                Color.accent3.edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    Image(systemName: "music.mic")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .foregroundColor(.white)
                    
                    VStack {
                        TextField("Email Addesss", text: $email)
                            .font(.system(size: 18, weight: .bold))
                            .padding(12)
                            .background(Color(.white))
                        
                        SecureField("Password", text: $password)
                            .font(.system(size: 18, weight: .bold))
                            .padding(12)
                            .background(Color(.white))
                        
                        if (error) {
                            Text("ahhh crap")
                        }
                    }.padding(.vertical, 64).multilineTextAlignment(TextAlignment.center)
                    
                    Button(action: signIn) {
                        Text("Sign In")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 50)
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .bold))
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: SignUpView()) {
                        HStack {
                            Text("Create Account")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
    }
}

//To do - figure out how to upload a fucking photo

struct SignUpView : View {
    @State var email: String = ""
    @State var password: String = ""
    @State var username: String = ""
    @State var displayname: String = ""
    @State var profileImage: UIImage?
    
    @State var showAction: Bool = false
    @State var showImagePicker: Bool = false
    
    @State var loading = false
    @State var error = false
    
    @EnvironmentObject var session: SessionStore
    
    func signUp () {
        
        guard AppHelper.isValidEmail(email) else {
            AppHelper.alert(title: "Please enter valid email!")
            return
        }
        
        guard username.count > 3 && username.count < 13 else {
            AppHelper.alert(title: "Username must be of 4 - 12 characters!")
            return
        }
        
        loading = true
        error = false
        
        session.checkUsername(username: username) { check in
            if check {
                AppHelper.alert(title: "This username is already take, please enter unique username!")
                loading = false
            } else {
                self.session.signUp(email: email, password: password, fullname: displayname, username: username, profileImage: profileImage!) { (result, error) in
                    self.loading = false
                    if error != nil {
                        print("Oops")
                        self.error = true
                    } else {
                        self.email = ""
                        self.password = ""
                    }
                }
            }
        }
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
        LoadingView(isShowing: $loading) {
            ZStack {
                Color.accent3.edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    VStack {
                        if (profileImage == nil) {
                            VStack{
                                Image(systemName: "camera.on.rectangle")
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(6)
                                
                                Text("Add a profile pic").font(.system(size: 18, weight: .bold))
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
                            }
                    }.foregroundColor(.white)
                        
                    .sheet(isPresented: $showImagePicker, onDismiss: {
                        self.showImagePicker = false
                    }, content: {
                        ImagePicker(isShown: self.$showImagePicker, uiImage: self.$profileImage)
                    })
                        .actionSheet(isPresented: $showAction) {
                            sheet
                    }
                    
                    VStack{
                        TextField("Email", text: $email)
                            .font(.system(size: 18, weight: .bold))
                            .padding(12)
                            .background(Color(.white))
                        
                        TextField("Display Name", text: $displayname)
                            .font(.system(size: 18, weight: .bold))
                            .padding(12)
                            .background(Color(.white))
                        
                        TextField("Username", text: $username)
                            .font(.system(size: 18, weight: .bold))
                            .padding(12)
                            .background(Color(.white))
                        
                        SecureField("Password", text: $password)
                            .font(.system(size: 18, weight: .bold))
                            .padding(12)
                            .background(Color(.white))
                        
                    }.padding(.vertical, 64).multilineTextAlignment(TextAlignment.center)
                    
                    if (error) {
                        
                        InlineAlert(
                            title: "Hmm... That didn't work.",
                            subtitle: "Are you sure you don't already have an account with that email address?"
                        ).padding([.horizontal, .top])
                    }
                    
                    VStack{
                        Button(action: signUp) {
                            Text("Sign up")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .frame(height: 50)
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .bold))
                                .disabled(loading)
                        }
                        NavigationLink(destination: SignInView()) {
                            HStack {
                                Text("Already have an account? Sign In")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
        }
    }
}


struct AuthView: View {
    var body: some View {
        NavigationView {
            SignInView()
        }
    }
}

#if DEBUG
struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
            .environmentObject(SessionStore())
    }
}
#endif

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var isShown: Bool
    @Binding var uiImage: UIImage?
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var isShown: Bool
        @Binding var uiImage: UIImage?
        init(isShown: Binding<Bool>, uiImage: Binding<UIImage?>) {
            _isShown = isShown
            _uiImage = uiImage
        }
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//            swiftlint:disable force_cast
            let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//            swiftlint:enable force_cast
            uiImage = imagePicked
            isShown = false
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isShown = false
        }
    }
    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, uiImage: $uiImage)
    }
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
}
