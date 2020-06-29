//
//  FeedView.swift
//  Ramble
//
//  Created by Peter Keating on 4/21/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct RambHotFeed : View {
    @ObservedObject var viewModel = RambService()
    
    init(){
        viewModel.fetchRambs()
    }
        
    var body: some View {
        List{
            ForEach(viewModel.rambs.sorted(by: { $0.claps < $1.claps })){ramb in
                rambCell(ramb: ramb)
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
