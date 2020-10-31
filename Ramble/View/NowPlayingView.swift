//
//  NowPlayingView.swift
//  Ramble
//
//  Created by Peter Keating on 10/30/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

@available(iOS 14.0, *)

struct NowPlayingBar<Content: View>: View {
    @EnvironmentObject var globalPlayer: GlobalPlayer
    @Namespace private var expandAnimation
    @State private var isExpanded = false
    @State var volume = 50.0

    
    var ramb: Ramb2 = testRamb
    
    let screenBounds = UIScreen.main.bounds
    
    var imageFrame: CGFloat {
        isExpanded ? screenBounds.width * 0.7 : 48
    }
    
    var playFrame: CGFloat {
        isExpanded ? 65 : 35
    }
    
    var cornerRadius: CGFloat {
        isExpanded ? 20 : 0
    }
    
    var content: Content
    
    @ViewBuilder var body: some View {
        
        ZStack(alignment: .bottom) {
            content
            
            VStack{
                
                Spacer()
                
                ZStack(alignment: .top) {
            
                    Color.white
                        .opacity(0.0)
                        .frame(height: isExpanded ? screenBounds.height - 100 : 80)
                        .clipShape(CornerShape(corner: [.topLeft, .topRight], size: CGSize(width: cornerRadius, height: cornerRadius)))
                        .background(Blur())

                    
                    VStack {
                        
                        HStack {
                           
                            if #available(iOS 14.0, *) {
                                
                                WebImage(url: URL(string: "\(ramb.user.profileImageUrl)"))
                                    .resizable()
                                    .scaleEffect()
                                    .frame(width: imageFrame, height: imageFrame)
                                    .matchedGeometryEffect(id: "AlbumImage", in: expandAnimation)
                                
                               
                            } else {
                                // Fallback on earlier versions
                                WebImage(url: URL(string: "\(ramb.user.profileImageUrl)"))
                                    .resizable()
                                    .frame(width: imageFrame, height: imageFrame)
                            }
                            
                            if !isExpanded {
                                
                                VStack(alignment: .leading) {
                                    
                                    Text("\(ramb.user.username))")
                                        .font(.system(.caption, design: .rounded))
                                        .matchedGeometryEffect(id: "Username", in: expandAnimation)
                                    
                                    Text("\(ramb.caption)")
                                        .font(.system(.body, design: .rounded))
                                        .bold()
                                        .matchedGeometryEffect(id: "Caption", in: expandAnimation)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    print("Fuck YEA")
                                }){
                                    Image(systemName: "play.circle")
                                        .resizable()
                                        .frame(width: playFrame, height: playFrame)
                                }
                            }
                            
                        }
                        
                        if isExpanded {
                                
                            VStack {
                                                            
                                VStack(alignment: .leading) {
                                    
                                    Text("\(ramb.user.username))")
                                        .font(.system(.caption, design: .rounded))
                                        .matchedGeometryEffect(id: "Username", in: expandAnimation)
                                    
                                    Text("\(ramb.caption)")
                                        .font(.system(.body, design: .rounded))
                                        .bold()
                                        .matchedGeometryEffect(id: "Caption", in: expandAnimation)
                                }
                                
                                Spacer()
                                
                                VStack {
                                    
                                    Rectangle()
                                        .frame(height: 3)
                                        .foregroundColor(Color(UIColor.tertiaryLabel))
                                        .cornerRadius(3)
                                    HStack {
                                        
                                        Text("0:00")
                                            .font(.caption)
                                            .foregroundColor(Color(UIColor.tertiaryLabel))
                                        Spacer()
                                        
                                        Text("-3:26")
                                            .font(.caption)
                                            .foregroundColor(Color(UIColor.tertiaryLabel))
                                    }
                                    
                                }
                                
                                Spacer()
                                
                                HStack {
                                    
                                    Button(action: {
                                        
                                        print("Fuck YEA")
                                        
                                    }){
                                        Image(systemName: "backward.fill")
                                            .font(.system(size: 20))
                                    }
                                    
                                    Spacer()
                                  
                                    Button(action: {
                                        
                                        print("Fuck YEA")
                                        
                                    }){
                                        Image(systemName: "play.fill")
                                            .font(.system(size: 36))
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        print("Fuck YEA")
                                    }){
                                        Image(systemName: "forward.fill").font(.system(size: 24))
              
                                    }
                                    
                                }
                                
                                Spacer()
                                
                                // Volume
                                HStack (spacing: 32) {
                                    Image(systemName: "volume.fill")
                                    Slider(value: $volume, in: 0...100)
                                        .accentColor(.pink)
                                    Image(systemName: "volume.3.fill")
                                }
                                
                                Spacer()
                                    
                            } .padding(.horizontal, 40)
                        
                        }
                    }
                    .padding(.top, isExpanded ? 55 : 16)
                    .padding(.horizontal)
                }
//                .padding(.top, isExpanded ? 50 : 0)
                .frame(maxHeight: isExpanded ? screenBounds.height - 60 : 80)
                .onTapGesture {
                    withAnimation(.spring()) {
                        isExpanded.toggle()
                    }
                }
            }
        }
    }
}
