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
        ZStack {
            Color.red.edgesIgnoringSafeArea(.all)
            VStack{
                
                Spacer()
                
                Image(systemName: "waveform")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                
                Spacer()
                
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
                            .foregroundColor(.black)
                        
                    }
                }
            }
        }
    }
}

struct SignUpView : View {

@State var email: String = ""
@State var password: String = ""
@State var loading = false
@State var error = false

@EnvironmentObject var session: SessionStore

func signUp () {
    print("sign me up")
    loading = true
    error = false
    session.signUp(email: email, password: password) { (result, error) in
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

var body : some View {
    
    ZStack {
    
        Color.red.edgesIgnoringSafeArea(.all)
        
            VStack {
                
                Spacer()
                
                Image(systemName: "waveform")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("Create an account")
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 50)
                .foregroundColor(.white)
                
                VStack{
            
                TextField("Email", text: $email)
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
                                .foregroundColor(.black)
                                }
                        }
                }
                
                Spacer()
        
                    Text("Thanks for joining Ramble. By joining, you are agreeing to our terms of use, which can be found on our website ramble.com").font(.system(size: 14)).foregroundColor(.black)
                            
            }
        }
    }
}

struct AuthView : View {
    
    var body : some View {
        NavigationView {
            SignInView()
        }
    }
}

#if DEBUG
struct AuthView_Previews : PreviewProvider {
    static var previews: some View {
        AuthView()
            .environmentObject(SessionStore())
    }
}
#endif


