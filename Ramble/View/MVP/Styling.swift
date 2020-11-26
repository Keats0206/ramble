//
//  Styling.swift
//  Ramble
//
//  Created by Peter Keating on 11/25/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct ClearCell: ViewModifier {
      func body(content: Content) -> some View {
          content
              .offset(x: -20)
              .padding(.horizontal)
              .font(.system(size: 18, weight: .bold, design: .rounded))
              .foregroundColor(.white)
              .listRowBackground(Color.clear)
      }
  }


struct PlayerButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding()
            .scaleEffect(configuration.isPressed ? 1.3 : 1.0)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.3 : 1.0)
    }
}
