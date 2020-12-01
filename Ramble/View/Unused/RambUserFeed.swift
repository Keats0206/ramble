//
//  RambUserFeed.swift
//  Ramble
//
//  Created by Peter Keating on 6/24/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

//import SwiftUI
//import AVKit
//import SDWebImageSwiftUI
//
//struct RambUserFeed : View {
//    @ObservedObject var viewModel = RambService2()
//
//    var user: User
//
//    init(user: User){
//        self.user = user
//        viewModel.fetchUserRambs(user: user)
//        return
//    }
//
//    var body: some View {
//        List {
//            ForEach(viewModel.userRambs.sorted(by: { $0.timestamp < $1.timestamp })) { ramb in
//                RambUserCell(ramb: ramb)
//            }
//            Spacer()
//        }.onAppear{
//            viewModel.fetchUserRambs(user: user)
//        }
//    }
//}
//
//struct RambUserFeed_Previews: PreviewProvider {
//    static var previews: some View {
//        RambUserFeed(user: testUser)
//    }
//}
