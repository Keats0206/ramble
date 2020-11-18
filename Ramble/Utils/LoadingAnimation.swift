//
//  LoadingAnimation.swift
//  Ramble
//
//  Created by Peter Keating on 11/17/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct LoadingAnimation: View {
    @State var animateUploading = false

    var body: some View {
        HStack {
            Circle()
                .fill(Color.accent1)
                .frame(width: 20, height: 20)
                .scaleEffect(animateUploading ? 1.0 : 0.5)
                .animation(Animation.easeInOut(duration: 0.5).repeatForever())
            Circle()
                .fill(Color.accent3)
                .frame(width: 20, height: 20)
                .scaleEffect(animateUploading ? 1.0 : 0.5)
                .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.3))
            Circle()
                .fill(Color.accent2)
                .frame(width: 20, height: 20)
                .scaleEffect(animateUploading ? 1.0 : 0.5)
                .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.6))
                }
        .onAppear {
            self.animateUploading = true
        }
    }
}


struct LoadingAnimation_Previews: PreviewProvider {
    static var previews: some View {
        LoadingAnimation()
    }
}
