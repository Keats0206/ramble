//
//  FeedHeaderView.swift
//  Ramble
//
//  Created by Peter Keating on 9/25/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct FeedHeaderView: View {
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Text("Ramble")
                    .font(.title)
                Text("New")
                    .font(.title)
                Spacer()
                Text("Hot")
            }.padding()
            .foregroundColor(.white)
            
        }.frame(height: 100)
        .background(Color.red)
    }
}

struct FeedHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        FeedHeaderView()
    }
}
