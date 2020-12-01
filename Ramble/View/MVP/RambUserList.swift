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
    @EnvironmentObject var globalPlayer: GlobalPlayer
    @ObservedObject var viewModel = RambService2()
    
    var user: User

    init(user: User) {
        self.user = user
        viewModel.fetchUserRambs(user: user)
        return
    }
    var body: some View {
        ZStack(alignment: .leading) {
            List {
                ForEach(viewModel.userRambs.sorted(by: { $0.timestamp < $1.timestamp })) { ramb in
                    RambRow(ramb: ramb)
                        .onTapGesture {
                            globalPlayer.playingRamb = ramb
                            globalPlayer.setGlobalPlayer(ramb: ramb)
                            globalPlayer.isPlaying = false
                        }
                }.onDelete(perform: delete)
                .modifier(ClearCell())
            }
            Spacer()
        }.onAppear {
            viewModel.fetchUserRambs(user: user)
            UITableView.appearance().backgroundColor = UIColor.clear
            UITableViewCell.appearance().backgroundColor = UIColor.clear
        }
    }
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let ramb = viewModel.userRambs.sorted(by: { $0.timestamp < $1.timestamp })[index]
            viewModel.deleteRamb(ramb: ramb)
            print("delete this \(ramb.id!)")
        }
    }
}

struct RambUserList_Previews: PreviewProvider {
    static var previews: some View {
        RambUserList(user: testUser)
    }
}
