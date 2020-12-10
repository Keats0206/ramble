//
//  ShareView.swift
//  Ramble
//
//  Created by Peter Keating on 12/9/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import UIKit

struct ShareView: View {
    @State var image: Image? = Image("userimage")
    
    @State var shareHeight = UIScreen.main.bounds.height * 0.6
    @State var shareWidth = UIScreen.main.bounds.width * 0.8
    @State var imageSize = UIScreen.main.bounds.width * 0.6
    
    var ramb: Ramb2
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.red
                .frame(width: shareWidth, height: shareHeight)
                .cornerRadius(20)
            VStack {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        image!
                            .resizable()
                            .frame(width: 200, height: 200, alignment: .center)
                            .shadow(radius: 10)
                            .cornerRadius(20)
                        Spacer()
                    }
                    Spacer()
                    HStack{
                        VStack(alignment: .center){
                            Text("\(ramb.caption)")
                                .font(.title)
                            Text("\(ramb.user.displayname)")
                                .font(.headline)
                        }.foregroundColor(.white)
                    }
                    Spacer()
                }
                    .frame(width: shareWidth, height: shareHeight)
                Spacer()
                Divider()
                HStack {
                    Text("Instagram Stories")
                    Spacer()
                    Button(action: {
                        print("Share to IG")
                    }) {
                        Text("Share")
                            .font(.headline)
                    }
                    .buttonStyle(OutlineButtonStyle())
                }
                .padding()
            }
            .padding()
        }
    }
}

struct ShareView_Previews: PreviewProvider {
    static var previews: some View {
        ShareView(ramb: testRamb)
    }
}
