//
//  RambUserList.swift
//  Ramble
//
//  Created by Peter Keating on 11/19/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import AVKit
import SDWebImageSwiftUI

struct RambUserList: View {
    @ObservedObject var viewModel = RambService2()

    var user: User

    init(user: User){
        self.user = user
        viewModel.fetchUserRambs(user: user)
        return
    }
    
    var body: some View {
        VStack(alignment: .leading){
            List{
                ForEach(viewModel.userRambs){ramb in
                    RambUserCell(ramb: ramb)
                }
            }
            Spacer()
        }.onAppear{
            viewModel.fetchUserRambs(user: user)
        }
    }
}

struct RambUserList_Previews: PreviewProvider {
    static var previews: some View {
        RambUserList(user: testUser)
    }
}
