//
//  SwiftUI+Validation.swift
//  Ramble
//
//  Created by P..D..! on 13/11/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation
import SwiftUI

struct ValidationModifier: ViewModifier {
    
    @State var latestValidation: Validation = .success
    
    let validationPublisher: ValidationPublisher
    @State var showErrorBubble: Bool = false
        
    func body(content: Content) -> some View {
        return content
//            ZStack(alignment: .trailing) {
//                content
//                    .border(borderColor, width: 1)
//                    .cornerRadius(2)
//                validationError.padding(.top, -50)
//                errorIcon.onTapGesture(perform: {
//                    self.showErrorBubble.toggle()
//                })
//            }.onReceive(validationPublisher) { validation in
//                self.latestValidation = validation
//            }.zIndex(1000)
//            .overlay(
//                HStack {
//                    Spacer()
//                    validationMessage.padding(.top, 80)
//                }
//            )
    }
    
//    var borderColor: Color {
//        switch latestValidation {
//        case .success,:
//            return K.Colors.cDCDCDC
//        case .failure( _):
//            return K.Colors.cC43535
//        }
//    }
//
//    var validationError: some View {
//        switch latestValidation {
//        case .success:
//            return AnyView(EmptyView())
//        case .failure( _):
//            let text = Text("VALIDATION ERROR")
//                .textStyle(regular10())
//                .foregroundColor(.red)
//            return AnyView(text)
//        }
//    }
//
//    var errorIcon: some View {
//        switch latestValidation {
//        case .success:
//            return AnyView(EmptyView())
//        case .failure( _):
//            let image = Image(uiImage: K.Images.basketball)
//                .renderingMode(.template)
//                .foregroundColor(Color.red)
//                .padding(.trailing, 16)
//            return AnyView(image)
//        }
//    }
//
//    var validationMessage: some View {
//        switch latestValidation {
//        case .success :
//            return AnyView(EmptyView())
//        case .failure(let message):
//            if showErrorBubble {
//                let text = ErrorBubbleView(error: message)
//                return AnyView(text)
//            }
//            return AnyView(EmptyView())
//        }
//    }
}

extension View {
    
    func validation(_ validationPublisher: ValidationPublisher) -> some View {
        self.modifier(ValidationModifier(validationPublisher: validationPublisher))
    }
    
}
