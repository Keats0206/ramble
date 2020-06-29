//
//  RambNewFeed.swift
//  Ramble
//
//  Created by Peter Keating on 6/24/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct RambNewFeed : View {
    @ObservedObject var viewModel = RambService()
    
    init(){
        viewModel.fetchRambs()
    }
    
    var body: some View {
        List{
            ForEach(viewModel.rambs.sorted(by: { $0.timestamp < $1.timestamp })){ramb in
                rambCell(ramb: ramb)
            }
        }.padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
    }
}

// Helpers:
struct RambNewFeed_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
