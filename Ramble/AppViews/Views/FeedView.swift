//
//  FeedView.swift
//  Ramble
//
//  Created by Peter Keating on 4/21/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct FeedView : View {

    @ObservedObject var observedData = getData()

    var body: some View {

        VStack{
                        
            ScrollView(.vertical, showsIndicators: false){

                VStack(alignment: .leading){

                    ForEach(observedData.datas){i in
                        rambleCellTop(id: i.tagId, userimage: i.userimage, title: i.title, length: i.length, date: i.date, applause: i.applause, stream: i.stream)
                                   }
                               }
                
                    }.padding(.bottom, 15)
        }
    }
}
                            


struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
