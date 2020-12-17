//
//  GradientView.swift
//  Ramble
//
//  Created by Peter Keating on 12/17/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct GradientView: View {
    @EnvironmentObject var settings: SessionSettings

    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [settings.firstColor, settings.secondColor]), startPoint: .top, endPoint: .bottom)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct GradientView_Previews: PreviewProvider {
    static var previews: some View {
        GradientView()
    }
}
