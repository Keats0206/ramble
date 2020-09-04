//
//  NavBarView.swift
//  Ramble
//
//  Created by Peter Keating on 6/15/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct NavBarView: View {
    var body: some View{
        VStack{
            Spacer()
            
            HStack{
                Button(action: {
                    self.profileModal_shown.toggle()
                }){
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                }.buttonStyle(BorderlessButtonStyle())
                
                Spacer()
                
                Text("Ramble").bold()
                
                Spacer()
                
                Button(action: {
                    self.recordingModal_shown.toggle()
                }){
                    Image(systemName: "mic.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                }.buttonStyle(BorderlessButtonStyle())
            }.padding([.top, .leading, .trailing])
        }.frame(height: 70)
    }
}
