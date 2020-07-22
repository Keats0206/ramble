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
    @EnvironmentObject var sessionSettings: SessionSettings
    @ObservedObject var viewModel = RambService()
    @Binding var dataToggle: Int
    @State private var isShowing = false
    
    init(_ model: RambService, dataToggle: Binding<Int>){
        self.viewModel = model
        self._dataToggle = dataToggle
        model.observeRambs(radius: 25)
    }
    
    var body: some View {
            List{
                if dataToggle != 1 {
                    ForEach(viewModel.rambs.sorted(by: { $0.claps < $1.claps })){ramb in
                        RambCell(ramb: ramb)
                    }
               } else {
                    ForEach(viewModel.rambs.sorted(by: { $0.timestamp < $1.timestamp })){ramb in
                        RambCell(ramb: ramb)
                    }
                }
            }.padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)).environmentObject(SessionSettings())
                .pullToRefresh(isShowing: $isShowing) {
                    self.viewModel.observeRambs(radius: 25)
                    self.isShowing = false
            }
        }
    }

// Helpers:

struct RambFeed_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
