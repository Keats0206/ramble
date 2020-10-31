//
//  SmallPlayerView.swift
//  Ramble
//
//  Created by Peter Keating on 10/24/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import MinimizableView

struct SmallPlayerView: View {
    @EnvironmentObject var minimizableViewHandler: MinimizableViewHandler
    @EnvironmentObject var globalPlayer: GlobalPlayer

    var ramb: Ramb2
    
    var body: some View {
        GeometryReader { proxy in
            HStack{
                WebImage(url: URL(string: "\(ramb.user.profileImageUrl)"))
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                
                VStack(alignment: .leading){
                    Text(ramb.caption)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                    
                    Text(globalPlayer.globalRambs?.first?.user.username ?? "No ramb")
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                }
                
                Spacer()
                        
                        if globalPlayer.isPlaying{
                            
                            Button(action: {
                                self.globalPlayer.globalRambPlayer?.pause()
                                globalPlayer.isPlaying = false
                            }){
                                Image(systemName: "pause.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                        } else {
                            Button(action: {
                                self.globalPlayer.play()
                            }){
                                Image(systemName: "play.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                        }
                        
                    }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .onTapGesture {
                self.minimizableViewHandler.expand()
            }.background(Color(.secondarySystemBackground))
            .verticalDragGesture(translationHeightTriggerValue: 40)
        }
    }
}

struct SmallPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        SmallPlayerView(ramb: testRamb)
    }
}

//struct ContentExample: View {
//
//    @EnvironmentObject var minimizableViewHandler: MinimizableViewHandler
//
//    var listContent:[String] {
//        var content = [String]()
//        for items in 0..<20 {
//            let text = "Content \(items)"
//            content.append(text)
//        }
//       return content
//
//    }
//
//    var body: some View {
//    GeometryReader { proxy in
//            VStack(alignment: .center, spacing: 5.0) {
//
//                TopDelimiterAreaView(areaWidth: proxy.size.width).onTapGesture {
//                        self.minimizableViewHandler.toggleExpansionState()
//                }
//
//                    HStack {
//                            Spacer()
//                            Button(action: {
//                                self.minimizableViewHandler.dismiss()
//                            }) {
//                                Image(systemName: "xmark.circle").font(.system(size: 20))
//                            }.padding(.trailing, 8)
//                    }.background(Color(.secondarySystemBackground)).verticalDragGesture(translationHeightTriggerValue: 30)
//
//                    List(self.listContent, id: \.self) { item in
//                        Text(item)
//                    }.frame(width: proxy.size.width - 10)
//
//            if self.minimizableViewHandler.isMinimized == false  {
//                        HStack(alignment: .bottom) {
//                            Spacer()
//                            // cancel button
//                            Button(action: {
//                                self.minimizableViewHandler.dismiss()
//                                    }) {
//                                        VerticalSymbolTextButtonView(imageSystemName: "xmark.circle", title:"Abort", foregroundColor: .red, size: 25.0)
//                            }
//                            Spacer()
//                                    // Add  button
//                                    Button(action: {
//                                                print("add button tapped")
//                                            }) {
//                                        VerticalSymbolTextButtonView(imageSystemName: "plus.circle", title: "Add", foregroundColor: .accentColor, size: 25.0)
//                                    }
//                                Spacer()
//                            }
//                        }
//            }.onAppear {
//
//                    print("appearing")
//
//                    self.minimizableViewHandler.onPresentation = {
//                            print("presenting")
//                        }
//
//                    self.minimizableViewHandler.onDismissal = {
//                        print("dismissing")
//                    }
//
//                    self.minimizableViewHandler.onExpansion = {
//
//                        print("expanding")
//                    }
//
//                    self.minimizableViewHandler.onMinimization = {
//                        print("contracting")
//                }
//        }
//    }
//}
//}

struct CompactViewExample: View {
    @EnvironmentObject var minimizableViewHandler: MinimizableViewHandler
    
    var body: some View {
        GeometryReader { proxy in
             HStack {
                Text("Compact View")
             }
             .frame(width: proxy.size.width, height: proxy.size.height)
             .onTapGesture {
                self.minimizableViewHandler.expand()
            }.background(Color(.secondarySystemBackground)
            ).verticalDragGesture(translationHeightTriggerValue: 40)
        }
    }
}

struct TranslucentTextButtonView: View {

    let title: String
    let foregroundColor: Color
    let backgroundColor: Color
    
    var body: some View {
        
        Text(title)
            .font(.headline)
            .padding(EdgeInsets(top: 5, leading: 7, bottom: 5, trailing: 7))
            .background(backgroundColor.opacity(0.4))
            .foregroundColor(foregroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 3)).padding()
    }
}

struct VerticalSymbolTextButtonView: View {
    
    let imageSystemName: String
    let title: String
    let foregroundColor: Color
    let size: CGFloat
    
    var body: some View {
        
        VStack(spacing: 1) {
            Image(systemName: self.imageSystemName).font(.system(size: size))
                                        
            Text(self.title).font(.caption).padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
        }.foregroundColor(self.foregroundColor).padding(EdgeInsets(top: 7, leading: 5, bottom: 1, trailing: 5))
    }
    
}
