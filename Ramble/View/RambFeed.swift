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
    @ObservedObject var viewModel = RambService()
    @Binding var dataToggle: Int
    @State private var isShowing = false
    
    init(_ model: RambService, dataToggle: Binding<Int>){
        self.viewModel = model
        self._dataToggle = dataToggle
        model.observeRambs()
    }
    
    var body: some View {
        ZStack{
            if dataToggle != 1 {
                List{
                    ForEach(viewModel.rambs.sorted(by: { $0.claps > $1.claps })){ ramb in
                        RambCell(ramb: ramb)
                            .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                    }
                }
            } else {
                List{
                    ForEach(viewModel.rambs.sorted(by: { $0.timestamp < $1.timestamp })){ ramb in
                        RambCell(ramb: ramb)
                            .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                    }
                }
            }
        }
        .pullToRefresh(isShowing: $isShowing) {
            self.viewModel.observeRambs()
            self.isShowing = false
        }
        .onAppear{
            print("DEBUG: Ramb feed called")
        }
    }
}

struct RambFeed_Previews: PreviewProvider {
    @State static var dataToggle = 0
    
    static var previews: some View {
        RambFeed(RambService(), dataToggle: $dataToggle)
    }
}
