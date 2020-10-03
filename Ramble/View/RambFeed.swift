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
import SDWebImageSwiftUI

struct RambFeed : View {
    @EnvironmentObject var globalPlayer : GlobalPlayer
    @ObservedObject var viewModel = RambService2()
    @Binding var dataToggle: Int
    @State private var isShowing = false
    
    var body: some View {
        ZStack{
            VStack{
                if dataToggle != 0 {
                    List{
                        ForEach(viewModel.allRambs.sorted(by: { $0.plays > $1.plays })){ ramb in
                            RambCell(ramb: ramb)
                                .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        }
                    }
                    
                } else {
                    List{
                        ForEach(viewModel.allRambs.sorted(by: { $0.timestamp < $1.timestamp })){ ramb in
                            RambCell(ramb: ramb)
                                .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        }
                    }
                }
            }
        }
        .pullToRefresh(isShowing: $isShowing) {
            self.viewModel.fetchRambs()
            self.isShowing = false
        }
        .onAppear{
            self.dataToggle = 0
            viewModel.fetchRambs()
        }
    }
    
//    private func loadRamb(){
//        let ramb = viewModel.allRambs[0]
//        print(ramb)
//        globalPlayer.globalRamb = ramb
//        globalPlayer.setGlobalPlayer(ramb: ramb)
//        globalPlayer.globalRambPlayer?.play()
//    }
}

struct RambFeed_Previews: PreviewProvider {
    @State static var dataToggle = 0
    
    static var previews: some View {
        RambFeed(viewModel: RambService2(), dataToggle: $dataToggle)
    }
}
