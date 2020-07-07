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
        
        VStack {
            
            VStack(alignment: .leading) {
                
                Text("Distance").font(.system(size: 18, weight: .bold))
                
                Text("Up to \(sessionSettings.radius, specifier: "%.0f") miles away")
                
                Slider(value: $sessionSettings.radius, in: 0...60, step: 1, onEditingChanged: { bool in
                    if false {
//                        UserService.shared.updateUserRadius(uid: self.session.session!.uid, radius: self.$sessionSettings.radius)
                    }
                }).accentColor(.red)
                
            }
            Spacer()
        }
    }
}
