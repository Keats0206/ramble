//
//  RambUserFeed.swift
//  Ramble
//
//  Created by Peter Keating on 6/24/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import AVKit
import SDWebImageSwiftUI

struct RambUserFeed : View {
    @ObservedObject var viewModel = RambService()
    
    var user: User
    
    init(_ model: RambService, user: User){
        self.viewModel = model
        self.user = user
        model.fetchUserRambs(forUser: user) { ramb in
            return
        }
    }
    
    var body: some View {
        List{
            ForEach(viewModel.userRambs){ramb in
                RambUserCell(ramb: ramb)
            }
        }.listStyle(GroupedListStyle())
    }
}

// Helpers:

struct RambUserFeed_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
