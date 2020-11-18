//
//  NowPlayingView.swift
//  Ramble
//
//  Created by Peter Keating on 10/30/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import AVKit

struct NowPlayingBar<Content: View>: View {
    @EnvironmentObject var globalPlayer: GlobalPlayer
//    @Namespace private var expandAnimation
    @State private var isExpanded = false
    @State var volume = 50.0
    
    @State var height : CGFloat = 0
    @State var floating = true
    
    @State var width : CGFloat = 20
    
    var ramb: Ramb2?
    
    let screenBounds = UIScreen.main.bounds
    
    var imageFrame: CGFloat {
        isExpanded ? screenBounds.width * 0.7 : 48
    }
    var playFrame: CGFloat {
        isExpanded ? 65 : 25
    }
    var cornerRadius: CGFloat {
        isExpanded ? 20 : 0
    }
    
    var content: Content
    @ViewBuilder var body: some View {
        ZStack(alignment: .bottom) {
            content
            
            if ramb != nil {
                VStack {
                    GeometryReader { geo in
                        ZStack(alignment: .top) {
                            Color.white
                                .edgesIgnoringSafeArea(.top)
                                .opacity(0.0)
                                .frame(height: isExpanded ? screenBounds.height + 60 : 80)
                                .clipShape(CornerShape(corner: [.topLeft, .topRight], size: CGSize(width: cornerRadius, height: cornerRadius)))
                                .background(Blur())
                            
                            VStack {
                                if isExpanded {
                                    Rectangle()
                                        .foregroundColor(Color.secondary)
                                        .frame(width: 40, height: 5)
                                        .cornerRadius(25)
                                        .padding(.bottom, 40)
                                    
                                }
                                    HStack {
                                        if #available(iOS 14.0, *) {
                                            WebImage(url: URL(string: "\(ramb!.user.profileImageUrl)"))
                                                .resizable()
                                                .scaleEffect()
                                                .frame(width: imageFrame, height: imageFrame)
    //                                            .matchedGeometryEffect(id: "AlbumImage", in: expandAnimation)
                                                .clipShape(Rectangle())
                                                .cornerRadius(8)
                                            
                                        } else {
                                            // Fallback on earlier versions
                                            WebImage(url: URL(string: "\(ramb!.user.profileImageUrl)"))
                                                .resizable()
                                                .scaleEffect()
                                                .frame(width: imageFrame, height: imageFrame)
                                                .clipShape(Rectangle())
                                                .cornerRadius(8)
                                                .shadow(radius: 10)
                                        }
                                        
                                        if !isExpanded {
                                            VStack(alignment: .leading) {
                                                Text("@\(ramb!.user.username)")
                                                    .font(.system(.caption, design: .rounded))
                                        
                                                Text("\(ramb!.caption)")
                                                    .font(.system(.body, design: .rounded))
                                                    .bold()
                                            }
                                            
                                            Spacer()
                                            
                                            Button(action: {
                                                if self.globalPlayer.isPlaying {
                                                    self.globalPlayer.globalRambPlayer!.pause()
                                                    self.globalPlayer.isPlaying.toggle()
                                                } else {
                                                    self.globalPlayer.globalRambPlayer!.play()
                                                    self.globalPlayer.isPlaying.toggle()
                                                }
                                             }) {
                                                Image(systemName: self.globalPlayer.isPlaying ? "pause.fill" : "play.fill")
                                                    .resizable()
                                                    .foregroundColor(.primary)
                                                    .frame(width: playFrame, height: playFrame)

                                            }.padding(.trailing)
                                            .buttonStyle(BorderlessButtonStyle())
                                            
                                            Button(action: {
                                                print("DEBUG: Forward 15")
                                            }) {
                                                Image(systemName: "goforward.15")
                                                    .resizable()
                                                    .foregroundColor(.primary)
                                                    .frame(width: playFrame, height: playFrame)
                                            }
                                        }
                                        
                                    }
                                
                                if isExpanded {
                                    
                                    VStack(alignment: .leading) {
                                        
                                        Spacer()
                                                                                
                                        VStack {
                                            
                                            Text("@\(ramb!.user.username)")
                                                .font(.system(.title))
                                                .bold()
                                                .onTapGesture(perform: {
                                                    self.isExpanded.toggle()
                                                })
                                        
                                            Text("\(ramb!.caption)")
                                                    .font(.system(.body, design: .rounded))
                                                    .bold()
                                            
                                        }.padding(.horizontal)
                                        
                                        
                                        //swiftlint:enable identifier_name
                                                                                                                        
                                        AudioControlView(player: globalPlayer.globalRambPlayer!)
                                        
                                        Spacer()
                                        
                                        // Volume                                        
                                        Spacer()
                                        
                                        Spacer()
                                        
                                    }.padding(.top, 40)
                                    .padding(.bottom, 30)
                        
                                }
                                
                                Spacer()
                            }
                            .padding(.top, isExpanded ? 80 : 16)
                            .padding(.horizontal)
                        }
                        .padding(.top, isExpanded ? 50 : 0)
                        .frame(maxHeight: isExpanded ? screenBounds.height - 120 : 80)
                        .onTapGesture {
                            if self.floating {
                                withAnimation(.spring()) {
                                    isExpanded.toggle()
                                    self.height = 0
                                    self.floating = false
                                }
                            }
                        }
                        .gesture(
                            DragGesture()
                                .onChanged({ (value) in
                                    if self.height < geo.size.height - 150 {
                                        self.height += value.translation.height / 8
                                        
                                    }
                                })
                                .onEnded({ (_) in
                                    if self.height > 100 && !self.floating {
                                        self.height = geo.size.height - 75
                                        self.floating = true
                                        self.isExpanded = false
                                        print("view A")
                                        print(floating)
                                        print(height)
                                    } else {
                                        if self.height < geo.size.height - 150 {
                                            self.height = 0
                                            self.floating = false
                                            self.isExpanded = true
                                            print("view B")
                                            print(floating)
                                            print(height)
                                        } else {
                                            self.height = geo.size.height - 75
                                            print("view C")
                                            print(floating)
                                            print(height)
                                        }
                                    }
                                })
                        )
                        .onAppear {
                            self.height = geo.size.height - 75
                            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
                                if self.globalPlayer.isPlaying{
                                    let screen = UIScreen.main.bounds.width - 30
//                                    let value = self.globalPlayer.globalRambPlayer?.currentTime().value! / self.globalPlayer.globalRambPlayer?.currentItem.asset.duration!
                                    self.width = screen * CGFloat(0.5)
                                }
                            }
                        }
                        .offset(y: self.height)
                        .animation(.spring())
                    }
                }
            } else {
                EmptyView()
            }
        }
    }
}



//struct NowPlayingBar_Previews: PreviewProvider {
//    static var previews: some View {
//        NowPlayingBar(selectedProfile: testUser, openProfile: false, content: EmptyView())
//    }
//}
