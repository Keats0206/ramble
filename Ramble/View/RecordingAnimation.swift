//
//  RecordingAnimation.swift
//  Ramble
//
//  Created by Peter Keating on 12/8/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct RecordingAnimation: View {
    @State var animate = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10).opacity(0.3)
                .frame(width: 350, height: 350)
                .scaleEffect(self.animate ? 1 : 0.3)
            
            Circle()
                .stroke(lineWidth: 10).opacity(0.5)
                .frame(width: 250, height: 250)
                .scaleEffect(self.animate ? 1 : 0.3)
            
            Circle()
                .stroke(lineWidth: 10).opacity(0.8)
                .frame(width: 150, height: 150)
                .scaleEffect(self.animate ? 1 : 0.3)
            
        }.foregroundColor(.white)
        .onAppear {
            self.animate.toggle()
        }
        .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: true))
    }
}

struct RecordingAnimation_Previews: PreviewProvider {
    static var previews: some View {
        RecordingAnimation()
    }
}
