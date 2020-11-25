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
    @EnvironmentObject var globalPLayer: GlobalPlayer
    @ObservedObject var viewModel = RambService2()

    var user: User

    init(user: User){
        self.user = user
        viewModel.fetchUserRambs(user: user)
        return
    }
    
    var body: some View {
        ZStack(alignment: .leading){
            List{
                ForEach(viewModel.userRambs.sorted(by: { $0.timestamp < $1.timestamp })) { ramb in
                    RambRow(ramb: ramb)
                        .onTapGesture{
                            globalPLayer.playingRamb = ramb
                        }
                }.onDelete(perform: delete)
                .modifier(ClearCell())
            }
            Spacer()
        }.onAppear{
            viewModel.fetchUserRambs(user: user)
            UITableView.appearance().backgroundColor = UIColor.clear
            UITableViewCell.appearance().backgroundColor = UIColor.clear
        }
    }
    
    func delete(at offsets: IndexSet) {
//      Deleting from the view:
        viewModel.userRambs.remove(atOffsets: offsets)

//      Only works on the first delete then stops:
        print(viewModel.userRambs.sorted(by: { $0.timestamp < $1.timestamp })[offsets.first! - 1])

//      Setting the rmab
//      Let ramb = viewModel.userRambs[offsets.first! - 1]
//      Seleting from database
//      viewModel.deleteRamb(ramb: ramb)
    }
}

struct RambUserList_Previews: PreviewProvider {
    static var previews: some View {
        RambUserList(user: testUser)
    }
}

struct ClearCell: ViewModifier {
      func body(content: Content) -> some View {
          content
              .offset(x: -20)
              .padding(.horizontal)
              .font(.system(size: 18, weight: .bold, design: .rounded))
              .foregroundColor(.white)
              .listRowBackground(Color.clear)
      }
  }
