//
//  BigPlayerView.swift
//  Ramble
//
//  Created by Peter Keating on 10/9/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import MinimizableView
import AVKit

struct BigPlayerView: View {
    @EnvironmentObject var minimizableViewHandler: MinimizableViewHandler

    var ramb: Ramb2
    var player: AVPlayer
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center, spacing: 5.0) {
                
                TopDelimiterAreaView(areaWidth: proxy.size.width).onTapGesture {
                     self.minimizableViewHandler.toggleExpansionState()
                }
                
                HStack {
                    Spacer()
                        Button(action: {
                            self.minimizableViewHandler.dismiss()
                        }) {
                            Image(systemName: "xmark.circle").font(.system(size: 20))
                            }.padding(.trailing, 8)
                }.background(Color(.secondarySystemBackground)).verticalDragGesture(translationHeightTriggerValue: 30)

                WebImage(url: URL(string: ramb.user.profileImageUrl))
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
           
            }.onAppear {
                
                    print("appearing")
                    
                    self.minimizableViewHandler.onPresentation = {
                          print("presenting")
                      }
                    
                    self.minimizableViewHandler.onDismissal = {
                        print("dismissing")
                    }
                    
                    self.minimizableViewHandler.onExpansion = {
                        
                        print("expanding")
                    }

                    self.minimizableViewHandler.onMinimization = {
                        print("contracting")
                    }
                
          
        }
            
//            VStack {
//
//                TopDelimiterAreaView(areaWidth: proxy.size.width).onTapGesture {
//
//                    self.minimizableViewHandler.toggleExpansionState()
//
//                }.verticalDragGesture(translationHeightTriggerValue: 40)
//
//
//                WebImage(url: URL(string: ramb.user.profileImageUrl))
//                    .frame(width: 150, height: 150)
//                    .clipShape(Circle())
//
//                Text("@ \(ramb.user.displayname)")
//                    .foregroundColor(.gray)
//                    .padding(.top, 20)
//
//                Text(ramb.user.username)
//                    .foregroundColor(.gray)
//                    .padding(.top, 20)
//
//                Text(ramb.caption)
//                    .font(.system(size: 22,weight: .regular, design: .rounded))
//                    .padding(.top, 10)
//                    .padding(.horizontal)
//
//                AudioView(player: player)
//
//                Spacer(minLength: 0)
//
//            }
//                .frame(width: proxy.size.width - 10)
//                .padding()
//                .onAppear {
//                    print("appearing")
//                    self.minimizableViewHandler.onPresentation = {
//                        print("presenting")
//                    }
//                    self.minimizableViewHandler.onDismissal = {
//                        print("dismissing")
//                    }
//                    self.minimizableViewHandler.onExpansion = {
//                        print("expanding")
//                    }
//                    self.minimizableViewHandler.onMinimization = {
//                        print("contracting")
//                    }
//                }
        }.background(Color.white)
    }
}

struct BigPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        BigPlayerView(ramb: testRamb, player: testPlayer)
    }
}
