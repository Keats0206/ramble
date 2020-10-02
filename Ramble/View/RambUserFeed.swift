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
    @ObservedObject var viewModel = RambService2()

    var user: User2

    init(user: User2){
        self.user = user
        return
    }
    
    var body: some View {
        VStack{
            ForEach(viewModel.userRambs){ramb in
                RambUserCell(ramb: ramb)
            }
            Spacer()
        }
    }
}

struct RambUserFeed_Previews: PreviewProvider {
    static var previews: some View {
        RambUserFeed(user: _user2)
    }
}
