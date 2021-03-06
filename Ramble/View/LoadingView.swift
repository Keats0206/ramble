//
//  LoadingView.swift
//  Ramble
//
//  Created by P..D..! on 11/11/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

//struct ActivityIndicator: UIViewRepresentable {
//    @Binding var isAnimating: Bool
//    let style: UIActivityIndicatorView.Style
//
//    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
//        return UIActivityIndicatorView(style: style)
//    }
//
//    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
//        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
//    }
//}

struct LoadingView<Content>: View where Content: View {
    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)
                
                if isShowing {
                    LoadingAnimation()
                }
            }
        }
    }
}

struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(isShowing: .constant(true)) {
            Text("Loading View")
        }
    }
}
