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

    @ObservedObject var observedData = getData()

    var body: some View {
        
        ZStack {
            List {
                ForEach(observedData.datas){i in
                        rambCell(id: i.tagId, userimage: i.userimage, title: i.title, length: i.length, date: i.date, applause: i.applause, stream: i.stream)
                }
            }.padding(.bottom, 15)
        }
    }
}

struct RambFeed_Previews: PreviewProvider {
    static var previews: some View {
        RambFeed()
    }
}
