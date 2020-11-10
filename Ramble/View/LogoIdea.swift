//
//  LogoIdea.swift
//  Ramble
//
//  Created by Peter Keating on 11/9/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct LogoIdea: View {
    var body: some View {
        ZStack{
            
            Color.accent3
            
            Image(systemName: "dot.radiowaves.left.and.right")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.white)
            
            Image(systemName: "music.note")
                .resizable()
                .scaledToFit()
                .frame(width: 45)
                .foregroundColor(.white)
                .offset(x: 10, y: -25)
        }
    }
}

struct LogoIdea_Previews: PreviewProvider {
    static var previews: some View {
        LogoIdea()
    }
}
