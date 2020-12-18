//
//  SplashView.swift
//  Ramble
//
//  Created by Peter Keating on 12/17/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct SplashScreen: View {
    @State var animate = true
    
    var body: some View {
        ZStack {
            
            Image("gradient2")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            Image("ramble_icon_white")
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fill)
                .frame(width: 115, height: 115, alignment: .center)
                .rotationEffect(Angle(degrees: animate ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
              withAnimation() {
                self.animate = false
              }
            }
        }
    }
}


#if DEBUG
struct SplashScreen_Previews : PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
#endif
