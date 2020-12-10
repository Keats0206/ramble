//
//  ErrorBubbleView.swift
//  Ramble
//
//  Created by P..D..! on 13/11/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct ErrorBubbleView: View {
    var error: String = "Lorem ipsum"
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            chatBubbleTriange(width: 7, height: 12, isIncoming: true)
                .rotationEffect(.degrees(90))
                .padding(.bottom, -4)
                .padding(.trailing, 22)
            Text(error)
                .foregroundColor(.white)
                .padding(8)
                .cornerRadius(6)
        }
    }
    
    private func chatBubbleTriange(
      width: CGFloat,
      height: CGFloat,
      isIncoming: Bool) -> some View {

        Path { path in
          path.move(to: CGPoint(x: 0, y: height * 0.5))
          path.addLine(to: CGPoint(x: width, y: height))
          path.addLine(to: CGPoint(x: width, y: 0))
          path.closeSubpath()
        }
        .fill(Color.gray)
        .frame(width: width, height: height)
        
    }
}

struct ErrorBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorBubbleView()
    }
}
