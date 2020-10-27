//
//  InPlayingAnimation.swift
//  Ramble
//
//  Created by Peter Keating on 10/22/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct InPlayingAnimation: View {
    var body: some View {
        ZStack {
                Circle().stroke(Color.white, lineWidth: 46)

                Circle()
                    .trim(from: 0, to: CGFloat(0.8))
                    .stroke(gradient, style: StrokeStyle(lineWidth: 46, lineCap: .round))
                    .overlay(
                        Circle().trim(from: 0, to: CGFloat(0.8))
                        .rotation(Angle.degrees(-4))
                        .stroke(gradient, style: StrokeStyle(lineWidth: 46, lineCap: .butt)))

        }.padding(60)
    }
}

struct InPlayingAnimation_Previews: PreviewProvider {
    static var previews: some View {
        InPlayingAnimation()
    }
}

private let gradient = AngularGradient(
    gradient: Gradient(colors: [Color.blue, .white]),
    center: .center,
    startAngle: .degrees(270),
    endAngle: .degrees(0))


