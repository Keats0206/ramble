//
//  FilterPicker.swift
//  Ramble
//
//  Created by Peter Keating on 10/1/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct FilterPicker: View {
    @State var selected = true
    
    var body: some View {
        HStack(spacing: -20){
            
            Button(action: {
                self.selected = false
            }){
                Text("New")
                    .font(.system(size: 14, weight: .heavy, design: .rounded) )
            }.padding(5)
            .padding([.leading, .trailing])
            .background(selected ? Rectangle() : Capsule())
            
            Button(action: {
                print("Show filter modal")
            }){
                Text("Hot")
                    .font(.system(size: 14, weight: .heavy, design: .rounded))
            }.padding(5)
            .padding([.leading, .trailing])
            .background(Rectangle().foregroundColor(.gray).frame(height: 40).cornerRadius(10))
            
        }.padding(5)
    }
}

struct FilterPicker_Previews: PreviewProvider {
    static var previews: some View {
        FilterPicker()
    }
}
