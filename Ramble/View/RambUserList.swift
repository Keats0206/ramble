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
    @StateObject var viewModel = RambService2()
//  https://dev.to/waj/stateobject-alternative-for-ios-13-2271
    
    var user: User

    var body: some View {
        ZStack(alignment: .leading) {
            List {
                ForEach(viewModel.userRambs.sorted(by: { $0.timestamp < $1.timestamp })) { ramb in
                    RambRow(ramb: ramb)
                        .onTapGesture {
                            globalPlayer.setGlobalPlayer(ramb: ramb)
                        }
                }.onDelete(perform: delete)
                .modifier(ClearCell())
            }
            Spacer()
        }
        .onAppear {
            viewModel.fetchUserRambs(user: user, newRecording: false)
            UITableView.appearance().backgroundColor = UIColor.clear
            UITableViewCell.appearance().backgroundColor = UIColor.clear
        }
    }
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let ramb = viewModel.userRambs.sorted(by: { $0.timestamp < $1.timestamp })[index]
            viewModel.deleteRamb(ramb: ramb)
        }
    }
}

struct RambUserList_Previews: PreviewProvider {
    static var previews: some View {
        RambUserList(user: testUser)
    }
}
//
//struct Observer<Obs, Content>: View where Obs: ObservableObject, Content: View {
//    @State private var obs: Obs?
//    private var content: Content
//    private var initializer: () -> Obs
//
//    init(_ initializer: @autoclosure @escaping () -> Obs, @ViewBuilder content: () -> Content) {
//        self.content = content()
//        self.initializer = initializer
//    }
//
//    var body: some View {
//        if let obs = obs {
//            content.environmentObject(obs)
//        } else {
//            Color.clear.onAppear(perform: initialize)
//        }
//    }
//
//    private func initialize() {
//        obs = initializer()
//    }
//}
