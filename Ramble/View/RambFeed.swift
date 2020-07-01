//
//  FeedView.swift
//  Ramble
//
//  Created by Peter Keating on 4/21/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct RambFeed : View {
    @ObservedObject var viewModel = RambService()
    @Binding var dataToggle: Int
    
    init(_ model: RambService, dataToggle: Binding<Int>){
        self.viewModel = model
        self._dataToggle = dataToggle
        model.fetchRambs()
    }
    
    var body: some View {
        List{
            if dataToggle != 1 {
                ForEach(viewModel.rambs.sorted(by: { $0.claps < $1.claps })){ramb in
                    rambCell(ramb: ramb)
                }
            } else {
                ForEach(viewModel.rambs.sorted(by: { $0.timestamp < $1.timestamp })){ramb in
                    rambCell(ramb: ramb)
                }
            }
        }.padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
    }
}

// Helpers:

struct RambFeed_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
