//
//  BottomSheet.swift
//  Ramble
//
//  Created by Peter Keating on 11/23/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct BottomSheet: View {
    @State var txt = ""
    
    var body: some View {
        HStack {
            TextField("Hit record to capture your voice", text: $txt)
                .font(.headline)
            Spacer()            
            Button(action: {
                print("Whatever")
            }) {
                Image(systemName: "mic.circle")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
        }.padding()
    }
}

struct BottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheet()
    }
}

