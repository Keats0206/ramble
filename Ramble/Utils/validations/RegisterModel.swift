//
//  RegisterModel.swift
//  Ramble
//
//  Created by P..D..! on 13/11/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct FormField: View {
    var placeholder: String = "Email"
    @Binding var value: String
    var validation: ValidationPublisher
    @Binding var latestValidation: Validation
    @State var showErrorBubble: Bool = false

    var body: some View {
        VStack {
        ZStack(alignment: .trailing) {
            TextField(placeholder, text: $value)
                .font(.system(size: 18, weight: .bold))
                .padding(12)
                .background(Color(.white))
            
            errorIcon.onTapGesture(perform: {
                self.showErrorBubble.toggle()
            })
        }.validation(validation)
        .overlay(
            HStack {
                Spacer()
                validationMessage.padding(.top, 45)
            }.zIndex(1000), alignment: .top)
        
            
            TextField(placeholder, text: $value)
                .font(.system(size: 18, weight: .bold))
                .padding(12)
                .background(Color(.white))
        }.onReceive(validation) { validation in
            self.latestValidation = validation
        }
    }
    
    var validationMessage: some View {
        switch latestValidation {
        case .success, .none:
            return AnyView(EmptyView())
        case .failure(let message):
            if showErrorBubble {
                let text = ErrorBubbleView(error: message)
                return AnyView(text)
            }
            return AnyView(EmptyView())
        }
    }
    
    var errorIcon: some View {
        switch latestValidation {
        case .success, .none:
            return AnyView(EmptyView())
        case .failure( _):
            let image = Image(uiImage: #imageLiteral(resourceName: "Comment"))
                .renderingMode(.template)
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundColor(Color.red)
                .padding(.trailing, 16)
            return AnyView(image)
        }
    }
}

struct RegisterModel_Previews: PreviewProvider {
    static var previews: some View {
        FormField(value: .constant(""), validation: RegisterModel().usernameValidation, latestValidation: .constant(RegisterModel().usernameValidated))
    }
}


class RegisterModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var usernameValidated: Validation = .failure(message: "String")
    
    @Published var email: String = ""
    @Published var emailValidated: Validation = .failure(message: "String")
    
    lazy var usernameValidation: ValidationPublisher = {
        $username.matcherValidation("^[a-zA-Z0-9]{3,7}$", "Username must be of 4 - 12 characters!")
    }()
    
    lazy var emailValidation: ValidationPublisher = {
        $email.nonEmptyValidator("K.emailEmpty")
    }()
    
//    lazy var emailValidation: ValidationPublisher = {
//        $email.matcherValidation("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}", "Email you entered is not valid!")
//    }()

}
