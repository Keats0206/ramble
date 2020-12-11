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
    @EnvironmentObject var settings: SessionSettings
    
    @State var profileImage: UIImage?
    @State private var shareHeight = UIScreen.main.bounds.height * 0.6
    @State private var shareWidth = UIScreen.main.bounds.width * 0.8
    @State private var imageSize = UIScreen.main.bounds.width * 0.6
    
    var ramb: Ramb2
    var user: User
    
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
                        
                        NetworkImage(url: URL(string: user.profileImageUrl), image: profileImage)
                            .frame(width: 200, height: 200)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                        
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        VStack(alignment: .center) {
                            
                            Text("\(ramb.caption)")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(settings.thirdColor)
                            
                            Text("\(ramb.user.displayname)")
                                .font(.headline)
                                .foregroundColor(settings.fourthColor)
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
                        gradient: Gradient(colors: [settings.firstColor, settings.secondColor]),
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
            }
            .padding()
        }
    }
}

struct ShareView_Previews: PreviewProvider {
    static var previews: some View {
        ShareView(ramb: testRamb, user: testUser)
    }
}
