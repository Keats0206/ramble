//
//  NowPlayingView.swift
//  Ramble
//
//  Created by Peter Keating on 11/13/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

//import SwiftUI
//import AVKit
//import SDWebImageSwiftUI
//
//struct  NowPlayingView: View {
//    @EnvironmentObject var globalPlayer: GlobalPlayer
////    @Namespace private var expandAnimation
//    @State private var isExpanded = false
//    @State var volume = 50.0
//    
//    @State var height : CGFloat = 0
//    @State var floating = true
//    
//    var ramb: Ramb2?
//    
//    let screenBounds = UIScreen.main.bounds
//    
//    var imageFrame: CGFloat {
//        isExpanded ? screenBounds.width * 0.7 : 48
//    }
//    var playFrame: CGFloat {
//        isExpanded ? 65 : 25
//    }
//    var cornerRadius: CGFloat {
//        isExpanded ? 20 : 0
//    }
//    
//    var alignment: Alignment {
//        isExpanded ? .center : .top
//    }
//    
//    var body: some View {
//        VStack {
//            GeometryReader { geo in
//                ZStack(alignment: alignment) {
//                    Color.white
//                        .edgesIgnoringSafeArea(.top)
//                        .opacity(0.0)
//                        .frame(height: isExpanded ? screenBounds.height + 60 : 80)
//                        .clipShape(CornerShape(corner: [.topLeft, .topRight], size: CGSize(width: cornerRadius, height: cornerRadius)))
//                        .background(Blur())
//                    
//                    VStack {
//                        if isExpanded {
//                            Rectangle()
//                                .foregroundColor(Color.secondary)
//                                .frame(width: 20, height: 5)
//                                .cornerRadius(25)
//                            
//                            Spacer()
//                        }
//                            HStack {
//                                if #available(iOS 14.0, *) {
//                                    WebImage(url: URL(string: "\(ramb!.user.profileImageUrl)"))
//                                        .resizable()
//                                        .scaleEffect()
//                                        .frame(width: imageFrame, height: imageFrame)
////                                            .matchedGeometryEffect(id: "AlbumImage", in: expandAnimation)
//                                        .clipShape(Rectangle())
//                                        .cornerRadius(8)
//                                } else {
//                                    // Fallback on earlier versions
//                                    WebImage(url: URL(string: "\(ramb!.user.profileImageUrl)"))
//                                        .resizable()
//                                        .scaleEffect()
//                                        .frame(width: imageFrame, height: imageFrame)
//                                        .clipShape(Rectangle())
//                                        .cornerRadius(8)
//                                }
//                                if !isExpanded {
//                                    VStack(alignment: .leading) {
//                                        Text("@\(ramb!.user.username)")
//                                            .font(.system(.caption, design: .rounded))
//                                            .onTapGesture(perform: {
////                                                self.selectedProfile = ramb!.user
////                                                self.openProfile = true
//                                            })
//                                        
//                                        Text("\(ramb!.caption)")
//                                            .font(.system(.body, design: .rounded))
//                                            .bold()
//                                    }
//                                    Spacer()
//                                    Button(action: {
//                                        print("Fuck YEA")
//                                    }){
//                                        Image(systemName: "play.fill")
//                                            .resizable()
//                                            .foregroundColor(.primary)
//                                            .frame(width: playFrame, height: playFrame)
//                                    }
//                                }
//                            }
//                        if isExpanded {
//                            VStack {
//                                Text("@\(ramb!.user.username)")
//                                        .font(.system(.title))
//                                        .bold()
//                                        .onTapGesture(perform: {
////                                            self.selectedProfile = ramb!.user
////                                            self.openProfile = true
//                                        })
//                                Text("\(ramb!.caption)")
//                                        .font(.system(.body, design: .rounded))
//                                        .bold()
//                                AudioView(player: AVPlayer(url: URL(string: ramb!.rambUrl)!))
//                                // Volume
//                                HStack(spacing: 32) {
//                                    
//                                    Image(systemName: "volume.fill")
//                                    
//                                    Slider(value: $volume, in: 0...100)
//                                        .accentColor(Color.secondary)
//                                    
//                                    Image(systemName: "volume.3.fill")
//                                }
//                            }
//                            .padding(.horizontal, 40)
//                        }
//                        Spacer()
//                    }
//                    .padding(.top, isExpanded ? 80 : 16)
//                    .padding(.horizontal)
//                }
//                .padding(.top, isExpanded ? 50 : 0)
//                .frame(maxHeight: isExpanded ? screenBounds.height - 120 : 80)
//                .onTapGesture {
//                    if self.floating {
//                        withAnimation(.spring()) {
//                            isExpanded.toggle()
//                            self.height = 0
//                            self.floating = false
//                        }
//                    }
//                }
//                .gesture(
//                    DragGesture()
//                        .onChanged({ (value) in
//                            if self.height < geo.size.height - 150 {
//                                self.height += value.translation.height / 8
//                                
//                            }
//                        })
//                        .onEnded({ (_) in
//                            if self.height > 100 && !self.floating {
//                                self.height = geo.size.height - 75
//                                self.floating = true
//                                self.isExpanded = false
//                                print("view A")
//                                print(floating)
//                                print(height)
//                            } else {
//                                if self.height < geo.size.height - 150 {
//                                    self.height = 0
//                                    self.floating = false
//                                    self.isExpanded = true
//                                    print("view B")
//                                    print(floating)
//                                    print(height)
//                                } else {
//                                    self.height = geo.size.height - 75
//                                    print("view C")
//                                    print(floating)
//                                    print(height)
//                                }
//                            }
//                        })
//                )
//                .onAppear {
//                    self.height = geo.size.height - 75
//                }
//                .offset(y: self.height)
//                .animation(.spring())
//            }
//        }
//    }
//}
//
//
//struct NowPlayingView_Previews: PreviewProvider {
//    static var previews: some View {
//        NowPlayingView(ramb: testRamb)
//    }
//}
//
