//
//  ShareView.swift
//  Ramble
//
//  Created by Peter Keating on 12/9/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import UIKit
import UIImageColors

struct ShareView: View {
    @State var image: Image? = Image("swift")
    
    @State private var firstColor: Color = .white
    @State private var secondColor: Color = .black
    @State private var thirdColor: Color = .blue
    @State private var fourthColor: Color = .red
        
    @State private var shareHeight = UIScreen.main.bounds.height * 0.6
    @State private var shareWidth = UIScreen.main.bounds.width * 0.8
    @State private var imageSize = UIScreen.main.bounds.width * 0.6
    
    var ramb: Ramb2
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "speaker.3.fill")
                            .font(.body)
                            .foregroundColor(.white)
                            .opacity(0.5)
                    }.padding()
                    HStack {
                        Spacer()
                        image!
                            .resizable()
                            .frame(width: 250, height: 250, alignment: .center)
                            .shadow(radius: 20)
                            .cornerRadius(20)
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        VStack(alignment: .center) {
                            
                            Text("\(ramb.caption)")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(thirdColor)
                            
                            Text("\(ramb.user.displayname)")
                                .font(.headline)
                                .foregroundColor(fourthColor)
                        }
                    }
                    Spacer()
                    HStack {
                        Image("icon")
                            .resizable()
                            .frame(width: 25, height: 25)
                        Text("www.useramble.com")
                            .font(.caption)
                            .opacity(0.5)
                    }.padding()
                    .foregroundColor(.white)
                }
                    .background(
                        RadialGradient(
                            gradient: Gradient(colors: [firstColor, secondColor]),
                            center: .center,
                            startRadius: 2,
                            endRadius: 650)
                    )
                    .frame(width: shareWidth, height: shareHeight)
                    .cornerRadius(20)
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
            }.padding()
        }.onAppear {
            self.setAverageColor()
        }
    }
    
//  Set these colors when the user logs on?
    func setAverageColor() {
        let image = UIImage(named: "swift")!
        image.getColors { colors in
            firstColor = Color((colors?.background)!)
            secondColor  = Color((colors?.primary)!)
            thirdColor = Color((colors?.secondary)!)
            fourthColor = Color((colors?.detail)!)
        }
    }

}


struct ShareView_Previews: PreviewProvider {
    static var previews: some View {
        ShareView(ramb: testRamb)
    }
}

