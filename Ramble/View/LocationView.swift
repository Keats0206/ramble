//
//  LocationView.swift
//  Ramble
//
//  Created by Peter Keating on 6/16/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct LocationView: View {
    @State var radius: Double = 25
    
    var body: some View{
         VStack {
            
            VStack {
                
                Text("Distance")
                
                Text("Up to \(radius, specifier: "%.0f") miles away")
            
                Slider(value: $radius, in: 0...100, step: 1)
            
            }
            
            Spacer()
        }
    }
}
