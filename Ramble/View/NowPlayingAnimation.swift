//
//  NowPlayingAnimation.swift
//  Ramble
//
//  Created by Peter Keating on 11/4/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct NowPlayingAnimation: View {
    @State private var isLoading = false
 
    var body: some View {
        ZStack {
            Image(systemName: "speaker")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
            
            Circle()
                .trim(from: 0.65, to: 0.85)
                .stroke(Color.white, lineWidth: 3)
                .frame(width: 60, height: 60)
                .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                .onAppear() {
                    self.isLoading = true
            }
            
            Circle()
                .trim(from: 0.65, to: 0.85)
                .stroke(Color.white, lineWidth: 3)
                .frame(width: 40, height: 40)
                .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                .onAppear() {
                    self.isLoading = true
            }
            
            
            Circle()
                .trim(from: 0.15, to: 0.35)
                .stroke(Color.white, lineWidth: 3)
                .frame(width: 60, height: 60)
                .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                .onAppear() {
                    self.isLoading = true
            }
            
            Circle()
                .trim(from: 0.15, to: 0.35)
                .stroke(Color.white, lineWidth: 3)
                .frame(width: 40, height: 40)
                .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                .onAppear() {
                    self.isLoading = true
            }
            
        }.opacity(0.7)
        .background(Color.black)
    }
}

struct NowPlayingAnimation_Previews: PreviewProvider {
    static var previews: some View {
        NowPlayingAnimation()
    }
}
