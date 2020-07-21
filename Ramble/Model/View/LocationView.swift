//
//  LocationView.swift
//  Ramble
//
//  Created by Peter Keating on 6/16/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct LocationView: View {
    //  Link this to the environment variable
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var sessionSettings: SessionSettings

    var body: some View{
        ZStack{
            
            VStack{
                
                VStack(alignment: .leading) {
                            
                    Text("Distance").font(.system(size: 18, weight: .bold))
                            
                    Text("Up to \(sessionSettings.radius, specifier: "%.0f") miles away")
                            
                    Slider(value: $sessionSettings.radius, in: 0...50, step: 1)
                        .padding()
                        .accentColor(.red)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15.0)
                                .stroke(lineWidth: 2.0)
                                .foregroundColor(Color.red)
                        )
                    }
        
                Spacer()
            
            }
        }
    }
}
