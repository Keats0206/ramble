//
//  NowPlayingCard.swift
//  Ramble
//
//  Created by Peter Keating on 11/18/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

//import Foundation
//import SwiftUI
//import SDWebImageSwiftUI
//
//struct NowPlayingCard: View {
//    @EnvironmentObject var globalPlayer: GlobalPlayer
//    @Binding var position: CardPosition
//
//    @State var volume = 50.0
//
//    @State var height : CGFloat = 0
//    @State var floating = true
//
//    @State var width : CGFloat = 20
//
//    @Binding var actionState: Int?
//    @Binding var selectedUser: User
//
//    var ramb: Ramb2?
//
//    let screenBounds = UIScreen.main.bounds
//
//    var offset: CGFloat {
//        position == CardPosition.bottom ? 165 : 335
//    }
//
//    @State var showSlider: Bool = false
//
//    var body: some View {
//        ZStack(alignment: .top) {
//            if ramb != nil {
//                VStack {
//
//                    HStack {
//
//                        WebImage(url: URL(string: "\(ramb!.user.profileImageUrl)"))
//                            .resizable()
//                            .scaleEffect()
//                            .frame(width: 48, height: 48)
//                            .clipShape(Rectangle())
//                            .cornerRadius(8)
//                            .shadow(radius: 10)
//
//                        VStack(alignment: .leading) {
//                            Button(action: {
//                                self.selectedUser = ramb!.user
//                                self.actionState = 1
//                            }){
//                                Text("@\(ramb!.user.username)")
//                                    .font(.system(.caption))
//                                    .bold()
//
//                            }.foregroundColor(.primary)
//
//                            Text("\(ramb!.caption)")
//                                .font(.system(.body, design: .rounded))
//                                .bold()
//                        }
//
//                        Spacer()
//
//                        Button(action: {
//                            self.selectedUser = ramb!.user
//                            self.actionState = 1
//                        }) {
//                            Image(systemName: "arrow.right.circle")
//                                .resizable()
//                                .frame(width: 25, height: 25)
//                                .foregroundColor(Color.accent3)
//                        }
//
//                    }
//
//                    Spacer()
//
//                    VStack {
////                        if position == CardPosition.middle {
////
////                            VStack(alignment: .leading) {
////
////                                Divider()
////
////                                HStack(alignment: .bottom) {
////
////                                    Text("@\(ramb!.user.username)")
////                                        .font(.system(.headline))
////                                        .bold()
////
////                                    Text("\(ramb!.user.displayname)")
////                                        .font(.system(.subheadline, design: .rounded))
////
////                                    Spacer()
////
////                                    Button(action: {
////                                        self.selectedUser = ramb!.user
////                                        self.actionState = 1
////                                    }) {
////                                        Image(systemName: "arrow.right.circle.fill")
////                                            .resizable()
////                                            .frame(width: 25, height: 25)
////                                            .foregroundColor(Color.accent3)
////                                    }
////                                }
////
////                                Text("\(ramb!.user.bio)")
////                                    .font(.system(.body, design: .rounded))
////                                    .opacity(0.4)
////
////                                Divider()
////
////                            }
////                            .animation(.easeInOut)
////                            .onAppear{
////
////                                showSlider.toggle()
////
////                            }.onDisappear {
////
////                                showSlider.toggle()
////
////                            }
////                        } else {
//                            Spacer()
////                        }
//                    }.frame(height: position == CardPosition.middle ? 100 : 10)
//
//                    Spacer()
//
//                    Controls()
//                        .padding(.bottom, 35)
//
//                }
//                .foregroundColor(.primary)
//                .padding()
//                .frame(height: offset)
//            } else {
//                LoadingAnimation()
//                    .padding(.top, 50)
//            }
//        }
//    }
//}
