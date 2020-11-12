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

@available(iOS 14.0, *)

struct NowPlayingBar<Content: View>: View {
    @EnvironmentObject var globalPlayer: GlobalPlayer
   
    @Namespace private var expandAnimation
    
    @State private var isExpanded = false
    @State var volume = 50.0
    @State private var isActive = false
    
    @State var height : CGFloat = 0
    @State var floating = true
    
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
                    
                    Spacer()
                    
                    GeometryReader { geo in
                        
                        ZStack(alignment: .top) {
                            
                            Color.white
                                .edgesIgnoringSafeArea(.top)
                                .opacity(0.0)
                                .frame(height: isExpanded ? screenBounds.height + 60 : 80)
                                .clipShape(CornerShape(corner: [.topLeft, .topRight], size: CGSize(width: cornerRadius, height: cornerRadius)))
                                .background(Blur())
                            
                            VStack {
                                
                                HStack {
                                    
                                    WebImage(url: URL(string: "\(ramb!.user.profileImageUrl)"))
                                        .resizable()
                                        .scaleEffect()
                                        .frame(width: imageFrame, height: imageFrame)
                                        .matchedGeometryEffect(id: "AlbumImage", in: expandAnimation)
                                        .clipShape(Rectangle())
                                        .cornerRadius(8)
                                    
                                    if !isExpanded {
                                        
                                        VStack(alignment: .leading) {
                                            
                                            Text("@\(ramb!.user.username)")
                                                .font(.system(.caption, design: .rounded))
                                                .onTapGesture(perform: {
                                                    //Open profile view from here.
                                                })
                                            
                                            Text("\(ramb!.caption)")
                                                .font(.system(.body, design: .rounded))
                                                .bold()
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            print("Fuck YEA")
                                        }){
                                            Image(systemName: "play.fill")
                                                .resizable()
                                                .foregroundColor(.primary)
                                                .frame(width: playFrame, height: playFrame)
                                        }
                                    }
                                    
                                }
                                
                                if isExpanded {
                                    VStack {
                                        ZStack {
                                            VStack(alignment: .leading) {
                                                NavigationLink(destination: ProfileView(user: .constant(ramb!.user)), isActive: $isActive){
                                                    Text("@\(ramb!.user.username)")
                                                        .font(.system(.title, design: .rounded))
                                                }
                                                Text("\(ramb!.caption)")
                                                    .font(.system(.body, design: .rounded))
                                                    .bold()
                                            }
                                        }
                                        
                                        AudioView(player: AVPlayer(url: URL(string: ramb!.rambUrl)!))
                                        
                                        Spacer()
                                        
                                        // Volume
                                        HStack(spacing: 32) {
                                            Image(systemName: "volume.fill")
                                            
                                            Slider(value: $volume, in: 0...100)
                                                .accentColor(Color.secondary)
                                            
                                            Image(systemName: "volume.3.fill")
                                        }
                                        
                                    }.padding(.vertical, 40)
                                    .padding(.horizontal, 40)
                                }
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

struct NowPlayingView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 14.0, *) {
            NowPlayingBar(ramb: Ramb2(id: "uSxc3OvHtHhk2dZGtK8i", caption: "I fuck w dominic fike", length: 12, rambUrl: "https://firebasestorage.googleapis.com/v0/b/ramb-ecce1.appspot.com/o/rambs%2F1FF073C0-620D-4227-932E-EAEBA5A2CF49?alt=media&token=f42ef81d-9da5-4c07-82e8-6ec841d20be0", fileId: "FieldId", timestamp: -1601682969, plays: 783, user: User(id: "uSxc3OvHtHhk2dZGtK8i", uid: "aNPWqgCxeuhVGnft9ccQWIqTzNk1", email: "Pete@pekeating.com", username: "NewUser", displayname: "Petek", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/ramb-ecce1.appspot.com/o/profile-images%2F6CD80D5B-464B-4664-98E1-9A3C59A5601A?alt=media&token=328ab7ad-15d6-4e6a-b1d4-d2acda634f4f", bio: "I like classic rock songs", isFollowed: false), uid: "aNPWqgCxeuhVGnft9ccQWIqTzNk1", isSelected: false), content: Text("Hello"))
                .padding(.bottom, 64)
        } else {
            // Fallback on earlier versions
        }
    }
}
