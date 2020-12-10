//
//  ShareView.swift
//  Ramble
//
//  Created by Peter Keating on 12/9/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct ShareView: View {
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Image("rambleexport")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 2)
                Spacer()
                Button(action: {
                    print("change image")
                }){
                    
                }
            }.padding(.top)
        }
    }
}

struct ShareView_Previews: PreviewProvider {
    static var previews: some View {
        ShareView()
    }
}
