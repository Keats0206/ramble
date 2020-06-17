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
    @ObservedObject var viewModel = RambViewModel()
    
    init(){
        viewModel.fetchRambs()
    }
    
    var body: some View {
        List{
            ForEach(viewModel.rambs){ramb in
                rambCell(ramb: ramb)
            }
        }.padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
    }
}
