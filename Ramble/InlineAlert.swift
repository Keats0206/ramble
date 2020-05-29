//
//  InlineAlert.swift
//  Ramble
//
//  Created by Peter Keating on 4/22/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

enum AlertIntent {
    case info, success, question, danger, warning
}

struct InlineAlert : View {
    var title: String
    var subtitle: String?
    var intent: AlertIntent = .info
    
    var body: some View {

        HStack(alignment: .top) {
               
                Image(systemName: "exclamationmark.triangle.fill")
                    .padding(.vertical)
                    .foregroundColor(Color.white)
            
                VStack(alignment: .leading) {
                    Text(self.title)

                    if (self.subtitle != nil) {
                        Text(self.subtitle!)

                    }

                }.padding(.leading)
            
            }
                .padding()
                .background(Color.red)
    }
}

#if DEBUG
struct InlineAlert_Previews : PreviewProvider {
    static var previews: some View {
        InlineAlert(
            title: "Nostrud non magna quis veniam dolore magna voluptate.",
            subtitle: "Nulla id amet reprehenderit laboris irure Lorem ex esse eiusmod eiusmod occaecat officia. Quis in reprehenderit dolor veniam id sunt mollit reprehenderit.",
            intent: .info
        ).frame(height: 300)
    }
}
#endif
