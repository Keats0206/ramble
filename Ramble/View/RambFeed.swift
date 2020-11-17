//
//  FeedView.swift
//  Ramble
//
//  Created by Peter Keating on 4/21/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import SwiftUIRefresh
import UIKit
import MinimizableView
import SDWebImageSwiftUI

struct RambFeed : View {
    @EnvironmentObject var miniHandler: MinimizableViewHandler
    @EnvironmentObject var globalPlayer : GlobalPlayer
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var viewModel = RambService2()
    @Binding var dataToggle: Int
    @State private var isShowing = false
        
    var backgroundColor: Color {
        colorScheme == .dark ? Color.black : Color.white
    }
    
    var body: some View {
        ZStack {
                        
            VStack {
                if dataToggle == 1 {
                    List{
                        ForEach(viewModel.allRambs.sorted(by: { $0.plays > $1.plays })){ ramb in
                            RambCell(ramb: ramb)
                                .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                                .environmentObject(globalPlayer)
                                .listRowBackground(backgroundColor)
                                .background(backgroundColor)
                        }
                    }
                } else {
                    List{
                        ForEach(viewModel.allRambs.sorted(by: { $0.timestamp < $1.timestamp })){ ramb in
                            RambCell(ramb: ramb)
                                .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                                .listRowBackground(backgroundColor)
                                .background(backgroundColor)
                        }
                    }
                }
            }
        }.pullToRefresh(isShowing: $isShowing) {
            self.viewModel.fetchRambs()
            self.isShowing = false
        }.onAppear {
            self.dataToggle = 1
            if self.globalPlayer.globalRambPlayer == nil {
                viewModel.setUp(globalPlayer: self.globalPlayer)
            }
        }
    }
}

struct RambFeed_Previews: PreviewProvider {
    @State static var dataToggle = 0
    @State static var availableWidth = UIScreen.main.bounds.width
    
    static var previews: some View {
        RambFeed(viewModel: RambService2(), dataToggle: $dataToggle)
    }
}
